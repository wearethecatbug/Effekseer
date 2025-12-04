// Effekseer Sprite Unlit Pixel/Fragment Shader (WGSL)
// Equivalent to sprite_unlit_ps.fx

struct PSInput {
    @location(0) color: vec4<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) posP: vec4<f32>,
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
var depthTex: texture_2d<f32>;

@group(1) @binding(3)
var depthSampler: sampler;

// Helper functions
fn PositivePow(base: vec3<f32>, power: vec3<f32>) -> vec3<f32> {
    return pow(max(abs(base), vec3<f32>(1.175494351e-38)), power);
}

fn LinearToSRGB(c: vec3<f32>) -> vec3<f32> {
    return max(1.055 * PositivePow(c, vec3<f32>(0.416666667)) - vec3<f32>(0.055), vec3<f32>(0.0));
}

fn SRGBToLinear(c: vec3<f32>) -> vec3<f32> {
    return min(PositivePow(c, vec3<f32>(2.4)) * vec3<f32>(0.947867299), PositivePow((c + vec3<f32>(0.055)) / vec3<f32>(1.055), vec3<f32>(2.4)));
}

fn ConvertFromSRGBTexture(c: vec3<f32>, textureSRGB: bool) -> vec3<f32> {
    if (textureSRGB) {
        return c;
    }
    return SRGBToLinear(c);
}

fn ConvertToScreen(c: vec3<f32>, isOutputSRGB: bool) -> vec3<f32> {
    if (isOutputSRGB) {
        return LinearToSRGB(c);
    }
    return c;
}

fn SoftParticle(
    backgroundZ: f32,
    meshZ: f32,
    softparticleParam: vec4<f32>,
    reconstructionParam1: vec4<f32>,
    reconstructionParam2: vec4<f32>
) -> f32 {
    let softParticleDepthFade = softparticleParam.x;
    let softParticleBackgroundFade = softparticleParam.y;
    
    let rescale = reconstructionParam1.x;
    let offset = reconstructionParam1.y;
    
    let backgroundZConverted = backgroundZ * rescale + offset;
    let meshZConverted = meshZ * rescale + offset;
    
    let backgroundDepth = reconstructionParam2.x / backgroundZConverted;
    let meshDepth = reconstructionParam2.x / meshZConverted;
    
    let distance = backgroundDepth - meshDepth;
    let fade = saturate(distance * softParticleDepthFade);
    
    return fade;
}

@fragment
fn main(input: PSInput) -> @location(0) vec4<f32> {
    var Output: vec4<f32>;
    
    // Sample color texture
    var texColor = textureSample(colorTex, colorSampler, input.uv);
    
    // Apply vertex color
    Output = texColor * input.color;
    
    // Handle soft particle if enabled
    let softParticleEnabled = cb.softParticleParam.w != 0.0;
    if (softParticleEnabled) {
        let posZ = input.posP.z / input.posP.w;
        
        // Get screen UV
        var screenUV = input.posP.xy / input.posP.w;
        screenUV = screenUV * 0.5 + 0.5;
        screenUV.y = cb.mUVInversedBack.x + (cb.mUVInversedBack.y * screenUV.y);
        
        // Sample depth texture
        let backgroundZ = textureSample(depthTex, depthSampler, screenUV).x;
        
        let fade = SoftParticle(backgroundZ, posZ, cb.softParticleParam, cb.reconstructionParam1, cb.reconstructionParam2);
        Output.a = Output.a * fade;
    }
    
    // Color conversion flags
    let textureSRGB = cb.miscFlags.x != 0.0;
    let outputSRGB = cb.miscFlags.y != 0.0;
    
    // Emissive scaling
    let emissive = cb.fEmissiveScaling.x;
    
    // Convert color spaces
    var rgb = Output.rgb;
    rgb = ConvertFromSRGBTexture(rgb, textureSRGB);
    rgb = rgb * emissive;
    rgb = ConvertToScreen(rgb, outputSRGB);
    Output = vec4<f32>(rgb, Output.a);
    
    // Discard if fully transparent
    if (Output.a <= 0.0) {
        discard;
    }
    
    return Output;
}
