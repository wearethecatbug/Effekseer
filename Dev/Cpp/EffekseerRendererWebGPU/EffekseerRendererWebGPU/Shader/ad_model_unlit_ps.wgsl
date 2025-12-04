// Effekseer Advanced Model Unlit Pixel Shader (WGSL)
// Converted from ad_model_unlit_ps.fx.frag

struct PSInput {
    @location(0) color: vec4<f32>,
    @location(1) uv_others: vec4<f32>,
    @location(2) worldN: vec3<f32>,
    @location(3) alpha_dist_uv: vec4<f32>,
    @location(4) blend_alpha_dist_uv: vec4<f32>,
    @location(5) blend_fb_next_uv: vec4<f32>,
    @location(6) posP: vec4<f32>,
}

struct AdvancedParameter {
    alphaUV: vec2<f32>,
    uvDistortionUV: vec2<f32>,
    blendUV: vec2<f32>,
    blendAlphaUV: vec2<f32>,
    blendUVDistortionUV: vec2<f32>,
    flipbookNextIndexUV: vec2<f32>,
    flipbookRate: f32,
    alphaThreshold: f32,
}

struct PSConstantBuffer {
    fLightDirection: vec4<f32>,
    fLightColor: vec4<f32>,
    fLightAmbient: vec4<f32>,
    fFlipbookParameter: vec4<f32>,
    fUVDistortionParameter: vec4<f32>,
    fBlendTextureParameter: vec4<f32>,
    fCameraFrontDirection: vec4<f32>,
    fFalloffParameter: vec4<f32>,
    fFalloffBeginColor: vec4<f32>,
    fFalloffEndColor: vec4<f32>,
    fEmissiveScaling: vec4<f32>,
    fEdgeColor: vec4<f32>,
    fEdgeParameter: vec4<f32>,
    softParticleParam: vec4<f32>,
    reconstructionParam1: vec4<f32>,
    reconstructionParam2: vec4<f32>,
    mUVInversedBack: vec4<f32>,
    miscFlags: vec4<f32>,
}

@group(0) @binding(1)
var<uniform> cb: PSConstantBuffer;

@group(1) @binding(0)
var colorTex: texture_2d<f32>;
@group(1) @binding(1)
var alphaTex: texture_2d<f32>;
@group(1) @binding(2)
var uvDistortionTex: texture_2d<f32>;
@group(1) @binding(3)
var blendTex: texture_2d<f32>;
@group(1) @binding(4)
var blendAlphaTex: texture_2d<f32>;
@group(1) @binding(5)
var blendUVDistortionTex: texture_2d<f32>;
@group(1) @binding(6)
var depthTex: texture_2d<f32>;
@group(1) @binding(7)
var texSampler: sampler;

fn disolveAdvancedParameter(input: PSInput) -> AdvancedParameter {
    var ret: AdvancedParameter;
    ret.alphaUV = input.alpha_dist_uv.xy;
    ret.uvDistortionUV = input.alpha_dist_uv.zw;
    ret.blendUV = input.blend_fb_next_uv.xy;
    ret.blendAlphaUV = input.blend_alpha_dist_uv.xy;
    ret.blendUVDistortionUV = input.blend_alpha_dist_uv.zw;
    ret.flipbookNextIndexUV = input.blend_fb_next_uv.zw;
    ret.flipbookRate = input.uv_others.z;
    ret.alphaThreshold = input.uv_others.w;
    return ret;
}

fn PositivePow(base: vec3<f32>, power: vec3<f32>) -> vec3<f32> {
    return pow(max(abs(base), vec3<f32>(1.175494351e-38)), power);
}

fn LinearToSRGB(c: vec3<f32>) -> vec3<f32> {
    return max(1.055 * PositivePow(c, vec3<f32>(0.416666667)) - vec3<f32>(0.055), vec3<f32>(0.0));
}

fn SRGBToLinear(c: vec3<f32>) -> vec3<f32> {
    return min(c, c * (c * (c * 0.305306 + vec3<f32>(0.682171)) + vec3<f32>(0.012523)));
}

fn ConvertFromSRGBTexture(c: vec4<f32>, isValid: bool) -> vec4<f32> {
    if (!isValid) {
        return c;
    }
    return vec4<f32>(LinearToSRGB(c.xyz), c.w);
}

fn ConvertToScreen(c: vec4<f32>, isValid: bool) -> vec4<f32> {
    if (!isValid) {
        return c;
    }
    return vec4<f32>(SRGBToLinear(c.xyz), c.w);
}

fn UVDistortionOffset(uv: vec2<f32>, uvInversed: vec2<f32>, convertFromSRGB: bool, tex: texture_2d<f32>, samp: sampler) -> vec2<f32> {
    var sampledColor = textureSample(tex, samp, uv);
    if (convertFromSRGB) {
        sampledColor = ConvertFromSRGBTexture(sampledColor, true);
    }
    var uvOffset = (sampledColor.xy * 2.0) - vec2<f32>(1.0);
    uvOffset.y = uvOffset.y * -1.0;
    uvOffset.y = uvInversed.x + uvInversed.y * uvOffset.y;
    return uvOffset;
}

fn ApplyFlipbook(dst: ptr<function, vec4<f32>>, flipbookParameter: vec4<f32>, vcolor: vec4<f32>, nextUV: vec2<f32>, flipbookRate: f32, convertFromSRGB: bool, tex: texture_2d<f32>, samp: sampler) {
    if (flipbookParameter.x > 0.0) {
        var sampledColor = textureSample(tex, samp, nextUV);
        if (convertFromSRGB) {
            sampledColor = ConvertFromSRGBTexture(sampledColor, true);
        }
        let nextPixelColor = sampledColor * vcolor;
        if (flipbookParameter.y == 1.0) {
            *dst = mix(*dst, nextPixelColor, vec4<f32>(flipbookRate));
        }
    }
}

fn ApplyTextureBlending(dstColor: ptr<function, vec4<f32>>, blendColor: vec4<f32>, blendType: f32) {
    if (blendType == 0.0) {
        // Mix
        (*dstColor) = vec4<f32>(
            blendColor.xyz * blendColor.w + (*dstColor).xyz * (1.0 - blendColor.w),
            (*dstColor).w
        );
    } else if (blendType == 1.0) {
        // Add
        (*dstColor) = vec4<f32>((*dstColor).xyz + blendColor.xyz * blendColor.w, (*dstColor).w);
    } else if (blendType == 2.0) {
        // Sub
        (*dstColor) = vec4<f32>((*dstColor).xyz - blendColor.xyz * blendColor.w, (*dstColor).w);
    } else if (blendType == 3.0) {
        // Mul
        (*dstColor) = vec4<f32>((*dstColor).xyz * blendColor.xyz * blendColor.w, (*dstColor).w);
    }
}

fn SoftParticle(backgroundZ: f32, meshZ: f32, softparticleParam: vec4<f32>, reconstruct1: vec4<f32>, reconstruct2: vec4<f32>) -> f32 {
    let distanceFar = softparticleParam.x;
    let distanceNear = softparticleParam.y;
    let distanceNearOffset = softparticleParam.z;
    let rescale = reconstruct1.xy;
    let params = reconstruct2;
    
    let zs = vec2<f32>(backgroundZ * rescale.x + rescale.y, meshZ);
    let depth = (zs * params.w - vec2<f32>(params.y)) / (vec2<f32>(params.x) - zs * params.z);
    let dir = sign(depth.x);
    let depthSigned = depth * dir;
    
    let alphaFar = (depthSigned.x - depthSigned.y) / distanceFar;
    let alphaNear = (depthSigned.y - distanceNearOffset) / distanceNear;
    
    return clamp(min(alphaFar, alphaNear), 0.0, 1.0);
}

@fragment
fn main(input: PSInput) -> @location(0) vec4<f32> {
    let convertColorSpace = cb.miscFlags.x != 0.0;
    let advancedParam = disolveAdvancedParameter(input);
    
    // UV distortion
    var uvOffset = UVDistortionOffset(advancedParam.uvDistortionUV, cb.fUVDistortionParameter.zw, convertColorSpace, uvDistortionTex, texSampler);
    uvOffset = uvOffset * cb.fUVDistortionParameter.x;
    
    // Main color
    let texColor = textureSample(colorTex, texSampler, input.uv_others.xy + uvOffset);
    var Output = ConvertFromSRGBTexture(texColor, convertColorSpace) * input.color;
    
    // Flipbook
    ApplyFlipbook(&Output, cb.fFlipbookParameter, input.color, advancedParam.flipbookNextIndexUV + uvOffset, advancedParam.flipbookRate, convertColorSpace, colorTex, texSampler);
    
    // Alpha texture
    let alphaTexColor = ConvertFromSRGBTexture(textureSample(alphaTex, texSampler, advancedParam.alphaUV + uvOffset), convertColorSpace);
    Output.w = Output.w * alphaTexColor.x * alphaTexColor.w;
    
    // Blend UV distortion
    var blendUVOffset = UVDistortionOffset(advancedParam.blendUVDistortionUV, cb.fUVDistortionParameter.zw, convertColorSpace, blendUVDistortionTex, texSampler);
    blendUVOffset = blendUVOffset * cb.fUVDistortionParameter.y;
    
    // Blend texture
    var blendTextureColor = ConvertFromSRGBTexture(textureSample(blendTex, texSampler, advancedParam.blendUV + blendUVOffset), convertColorSpace);
    let blendAlphaTextureColor = ConvertFromSRGBTexture(textureSample(blendAlphaTex, texSampler, advancedParam.blendAlphaUV + blendUVOffset), convertColorSpace);
    blendTextureColor.w = blendTextureColor.w * blendAlphaTextureColor.x * blendAlphaTextureColor.w;
    
    ApplyTextureBlending(&Output, blendTextureColor, cb.fBlendTextureParameter.x);
    
    // Falloff
    if (cb.fFalloffParameter.x == 1.0) {
        let cameraVec = normalize(-cb.fCameraFrontDirection.xyz);
        let CdotN = clamp(dot(cameraVec, normalize(input.worldN)), 0.0, 1.0);
        let falloffBlendColor = mix(cb.fFalloffEndColor, cb.fFalloffBeginColor, vec4<f32>(pow(CdotN, cb.fFalloffParameter.z)));
        
        if (cb.fFalloffParameter.y == 0.0) {
            Output = vec4<f32>(Output.xyz + falloffBlendColor.xyz, Output.w);
        } else if (cb.fFalloffParameter.y == 1.0) {
            Output = vec4<f32>(Output.xyz - falloffBlendColor.xyz, Output.w);
        } else if (cb.fFalloffParameter.y == 2.0) {
            Output = vec4<f32>(Output.xyz * falloffBlendColor.xyz, Output.w);
        }
        Output.w = Output.w * falloffBlendColor.w;
    }
    
    // Emissive scaling
    Output = vec4<f32>(Output.xyz * cb.fEmissiveScaling.x, Output.w);
    
    // Soft particle
    let screenPos = input.posP / input.posP.w;
    var screenUV = (screenPos.xy + vec2<f32>(1.0)) / 2.0;
    screenUV.y = 1.0 - screenUV.y;
    screenUV.y = cb.mUVInversedBack.x + cb.mUVInversedBack.y * screenUV.y;
    
    if (cb.softParticleParam.w != 0.0) {
        let backgroundZ = textureSample(depthTex, texSampler, screenUV).x;
        Output.w = Output.w * SoftParticle(backgroundZ, screenPos.z, cb.softParticleParam, cb.reconstructionParam1, cb.reconstructionParam2);
    }
    
    // Alpha threshold and edge
    if (Output.w <= max(0.0, advancedParam.alphaThreshold)) {
        discard;
    }
    
    let edgeFactor = ceil((Output.w - advancedParam.alphaThreshold) - cb.fEdgeParameter.x);
    Output = vec4<f32>(
        mix(cb.fEdgeColor.xyz * cb.fEdgeParameter.y, Output.xyz, vec3<f32>(edgeFactor)),
        Output.w
    );
    
    return ConvertToScreen(Output, convertColorSpace);
}
