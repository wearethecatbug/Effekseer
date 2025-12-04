// Effekseer Advanced Model Distortion Pixel Shader (WGSL)
// Converted from ad_model_distortion_ps.fx.frag

struct PSInput {
    @location(0) uv_others: vec4<f32>,
    @location(1) projBinormal: vec4<f32>,
    @location(2) projTangent: vec4<f32>,
    @location(3) posP: vec4<f32>,
    @location(4) color: vec4<f32>,
    @location(5) alpha_dist_uv: vec4<f32>,
    @location(6) blend_alpha_dist_uv: vec4<f32>,
    @location(7) blend_fb_next_uv: vec4<f32>,
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
    g_scale: vec4<f32>,
    mUVInversedBack: vec4<f32>,
    fFlipbookParameter: vec4<f32>,
    fUVDistortionParameter: vec4<f32>,
    fBlendTextureParameter: vec4<f32>,
    softParticleParam: vec4<f32>,
    reconstructionParam1: vec4<f32>,
    reconstructionParam2: vec4<f32>,
}

@group(0) @binding(1)
var<uniform> cb: PSConstantBuffer;

@group(1) @binding(0)
var colorTex: texture_2d<f32>;
@group(1) @binding(1)
var backTex: texture_2d<f32>;
@group(1) @binding(2)
var alphaTex: texture_2d<f32>;
@group(1) @binding(3)
var uvDistortionTex: texture_2d<f32>;
@group(1) @binding(4)
var blendTex: texture_2d<f32>;
@group(1) @binding(5)
var blendAlphaTex: texture_2d<f32>;
@group(1) @binding(6)
var blendUVDistortionTex: texture_2d<f32>;
@group(1) @binding(7)
var depthTex: texture_2d<f32>;
@group(1) @binding(8)
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

fn ConvertFromSRGBTexture(c: vec4<f32>, isValid: bool) -> vec4<f32> {
    if (!isValid) {
        return c;
    }
    return vec4<f32>(LinearToSRGB(c.xyz), c.w);
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
        (*dstColor) = vec4<f32>(
            blendColor.xyz * blendColor.w + (*dstColor).xyz * (1.0 - blendColor.w),
            (*dstColor).w
        );
    } else if (blendType == 1.0) {
        (*dstColor) = vec4<f32>((*dstColor).xyz + blendColor.xyz * blendColor.w, (*dstColor).w);
    } else if (blendType == 2.0) {
        (*dstColor) = vec4<f32>((*dstColor).xyz - blendColor.xyz * blendColor.w, (*dstColor).w);
    } else if (blendType == 3.0) {
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
    let advancedParam = disolveAdvancedParameter(input);
    
    // UV distortion
    var uvOffset = UVDistortionOffset(advancedParam.uvDistortionUV, cb.fUVDistortionParameter.zw, false, uvDistortionTex, texSampler);
    uvOffset = uvOffset * cb.fUVDistortionParameter.x;
    
    // Main color (distortion map)
    var Output = textureSample(colorTex, texSampler, input.uv_others.xy + uvOffset);
    Output.w = Output.w * input.color.w;
    
    // Flipbook
    ApplyFlipbook(&Output, cb.fFlipbookParameter, input.color, advancedParam.flipbookNextIndexUV + uvOffset, advancedParam.flipbookRate, false, colorTex, texSampler);
    
    // Alpha texture
    let alphaTexColor = textureSample(alphaTex, texSampler, advancedParam.alphaUV + uvOffset);
    Output.w = Output.w * alphaTexColor.x * alphaTexColor.w;
    
    // Blend UV distortion
    var blendUVOffset = UVDistortionOffset(advancedParam.blendUVDistortionUV, cb.fUVDistortionParameter.zw, false, blendUVDistortionTex, texSampler);
    blendUVOffset = blendUVOffset * cb.fUVDistortionParameter.y;
    
    // Blend texture
    var blendTextureColor = textureSample(blendTex, texSampler, advancedParam.blendUV + blendUVOffset);
    let blendAlphaTextureColor = textureSample(blendAlphaTex, texSampler, advancedParam.blendAlphaUV + blendUVOffset);
    blendTextureColor.w = blendTextureColor.w * blendAlphaTextureColor.x * blendAlphaTextureColor.w;
    
    ApplyTextureBlending(&Output, blendTextureColor, cb.fBlendTextureParameter.x);
    
    // Alpha threshold
    if (Output.w <= max(0.0, advancedParam.alphaThreshold)) {
        discard;
    }
    
    // Distortion calculation
    let pos = input.posP.xy / input.posP.w;
    let posR = input.projTangent.xy / input.projTangent.w;
    let posU = input.projBinormal.xy / input.projBinormal.w;
    
    let xscale = ((Output.x * 2.0 - 1.0) * input.color.x) * cb.g_scale.x;
    let yscale = ((Output.y * 2.0 - 1.0) * input.color.y) * cb.g_scale.x;
    
    var uv = pos + (posR - pos) * xscale + (posU - pos) * yscale;
    uv.x = (uv.x + 1.0) * 0.5;
    uv.y = 1.0 - (uv.y + 1.0) * 0.5;
    uv.y = cb.mUVInversedBack.x + cb.mUVInversedBack.y * uv.y;
    
    // Sample background
    let color = textureSample(backTex, texSampler, uv).xyz;
    Output = vec4<f32>(color, Output.w);
    
    // Soft particle
    let screenPos = input.posP / input.posP.w;
    var screenUV = (screenPos.xy + vec2<f32>(1.0)) / 2.0;
    screenUV.y = 1.0 - screenUV.y;
    
    if (cb.softParticleParam.w != 0.0) {
        let backgroundZ = textureSample(depthTex, texSampler, screenUV).x;
        Output.w = Output.w * SoftParticle(backgroundZ, screenPos.z, cb.softParticleParam, cb.reconstructionParam1, cb.reconstructionParam2);
    }
    
    return Output;
}
