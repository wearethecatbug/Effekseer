// Effekseer Sprite/Model Lit Pixel Shader (WGSL)
// Equivalent to model_lit_ps.fx (also used for sprites)

struct PSInput {
    @location(0) color: vec4<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) worldN: vec3<f32>,
    @location(3) worldB: vec3<f32>,
    @location(4) worldT: vec3<f32>,
    @location(5) posP: vec4<f32>,
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
var colorSampler: sampler;

@group(1) @binding(2)
var normalTex: texture_2d<f32>;

@group(1) @binding(3)
var normalSampler: sampler;

@group(1) @binding(4)
var depthTex: texture_2d<f32>;

@group(1) @binding(5)
var depthSampler: sampler;

// Helper functions
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

fn SoftParticle(
    backgroundZ: f32,
    meshZ: f32,
    softparticleParam: vec4<f32>,
    reconstruct1: vec4<f32>,
    reconstruct2: vec4<f32>
) -> f32 {
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
    
    // Sample and convert color texture
    let texColor = textureSample(colorTex, colorSampler, input.uv);
    var Output = ConvertFromSRGBTexture(texColor, convertColorSpace) * input.color;
    
    // Sample normal map and compute lighting
    let texNormal = (textureSample(normalTex, normalSampler, input.uv).xyz - vec3<f32>(0.5)) * 2.0;
    let TBN = mat3x3<f32>(input.worldT, input.worldB, input.worldN);
    let localNormal = normalize(texNormal * TBN);
    
    let diffuse = max(dot(cb.fLightDirection.xyz, localNormal), 0.0);
    Output = vec4<f32>(
        Output.xyz * (cb.fLightColor.xyz * diffuse + cb.fLightAmbient.xyz),
        Output.w
    );
    
    // Emissive scaling
    Output = vec4<f32>(Output.xyz * cb.fEmissiveScaling.x, Output.w);
    
    // Soft particle
    let screenPos = input.posP / input.posP.w;
    var screenUV = (screenPos.xy + vec2<f32>(1.0)) / 2.0;
    screenUV.y = 1.0 - screenUV.y;
    screenUV.y = cb.mUVInversedBack.x + cb.mUVInversedBack.y * screenUV.y;
    
    if (cb.softParticleParam.w != 0.0) {
        let backgroundZ = textureSample(depthTex, depthSampler, screenUV).x;
        Output.w = Output.w * SoftParticle(backgroundZ, screenPos.z, cb.softParticleParam, cb.reconstructionParam1, cb.reconstructionParam2);
    }
    
    if (Output.w == 0.0) {
        discard;
    }
    
    return ConvertToScreen(Output, convertColorSpace);
}
