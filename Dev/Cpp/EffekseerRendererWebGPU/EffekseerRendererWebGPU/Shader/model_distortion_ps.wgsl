// Effekseer Model Distortion Pixel Shader (WGSL)
// Equivalent to model_distortion_ps.fx
// Note: This is the same as sprite_distortion_ps.wgsl

struct PSInput {
    @location(0) uv: vec2<f32>,
    @location(1) projBinormal: vec4<f32>,
    @location(2) projTangent: vec4<f32>,
    @location(3) posP: vec4<f32>,
    @location(4) color: vec4<f32>,
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
var colorSampler: sampler;

@group(1) @binding(2)
var backTex: texture_2d<f32>;

@group(1) @binding(3)
var backSampler: sampler;

@group(1) @binding(4)
var depthTex: texture_2d<f32>;

@group(1) @binding(5)
var depthSampler: sampler;

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
    var Output = textureSample(colorTex, colorSampler, input.uv);
    Output.w = Output.w * input.color.w;
    
    // Compute distortion UV offset
    let pos = input.posP.xy / input.posP.w;
    let posR = input.projTangent.xy / input.projTangent.w;
    let posU = input.projBinormal.xy / input.projBinormal.w;
    
    let xscale = ((Output.x * 2.0 - 1.0) * input.color.x) * cb.g_scale.x;
    let yscale = ((Output.y * 2.0 - 1.0) * input.color.y) * cb.g_scale.x;
    
    var uv = pos + (posR - pos) * xscale + (posU - pos) * yscale;
    uv.x = (uv.x + 1.0) * 0.5;
    uv.y = 1.0 - ((uv.y + 1.0) * 0.5);
    uv.y = cb.mUVInversedBack.x + cb.mUVInversedBack.y * uv.y;
    
    // Sample background with distorted UV
    let color = textureSample(backTex, backSampler, uv).xyz;
    Output = vec4<f32>(color, Output.w);
    
    // Soft particle
    let screenPos = input.posP / input.posP.w;
    var screenUV = (screenPos.xy + vec2<f32>(1.0)) / 2.0;
    screenUV.y = 1.0 - screenUV.y;
    
    if (cb.softParticleParam.w != 0.0) {
        let backgroundZ = textureSample(depthTex, depthSampler, screenUV).x;
        Output.w = Output.w * SoftParticle(backgroundZ, screenPos.z, cb.softParticleParam, cb.reconstructionParam1, cb.reconstructionParam2);
    }
    
    if (Output.w == 0.0) {
        discard;
    }
    
    return Output;
}
