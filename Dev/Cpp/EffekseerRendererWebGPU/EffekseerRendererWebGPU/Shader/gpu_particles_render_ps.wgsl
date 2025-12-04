// Effekseer GPU Particles Render Pixel Shader (WGSL)
// Equivalent to gpu_particles_render_ps.fx

struct PSInput {
    @location(0) uv: vec2<f32>,
    @location(1) color: vec4<f32>,
    @location(2) worldN: vec3<f32>,
    @location(3) worldB: vec3<f32>,
    @location(4) worldT: vec3<f32>,
}

struct RenderConstants {
    cameraPos: vec3<f32>,
    coordinateReversed: u32,
    cameraFront: vec3<f32>,
    reserved1: f32,
    lightDir: vec3<f32>,
    reserved2: f32,
    lightColor: vec4<f32>,
    lightAmbient: vec4<f32>,
    projMat: mat4x4<f32>,
    cameraMat: mat4x4<f32>,
    billboardMat: mat4x3<f32>,
    yAxisFixedMat: mat4x3<f32>,
}

struct ParameterData {
    emitCount: i32,
    emitPerFrame: i32,
    emitOffset: f32,
    padding0: u32,
    lifeTime: vec2<f32>,
    emitShapeType: u32,
    emitRotationApplied: u32,
    emitShapeData: array<vec4<f32>, 2>,
    direction: vec3<f32>,
    spread: f32,
    initialSpeed: vec2<f32>,
    damping: vec2<f32>,
    angularOffset: array<vec4<f32>, 2>,
    angularVelocity: array<vec4<f32>, 2>,
    scaleData1: array<vec4<f32>, 2>,
    scaleData2: array<vec4<f32>, 2>,
    scaleEasing: vec3<f32>,
    scaleFlags: u32,
    gravity: vec3<f32>,
    padding2: u32,
    vortexCenter: vec3<f32>,
    vortexRotation: f32,
    vortexAxis: vec3<f32>,
    vortexAttraction: f32,
    turbulencePower: f32,
    turbulenceSeed: u32,
    turbulenceScale: f32,
    turbulenceOctave: f32,
    renderState: u32,
    shapeType: u32,
    shapeData: u32,
    shapeSize: f32,
    emissive: f32,
    fadeIn: f32,
    fadeOut: f32,
    materialType: u32,
    colorData: vec4<u32>,
    colorEasing: vec3<f32>,
    colorFlags: u32,
}

@group(0) @binding(0)
var<uniform> constants: RenderConstants;

@group(0) @binding(1)
var<uniform> paramData: ParameterData;

@group(1) @binding(0)
var colorTex: texture_2d<f32>;

@group(1) @binding(1)
var colorSampler: sampler;

@group(1) @binding(2)
var normalTex: texture_2d<f32>;

@group(1) @binding(3)
var normalSampler: sampler;

@fragment
fn main(input: PSInput) -> @location(0) vec4<f32> {
    var color = input.color * textureSample(colorTex, colorSampler, input.uv);
    
    // Lit material
    if (paramData.materialType == 1u) {
        let texNormal = textureSample(normalTex, normalSampler, input.uv).xyz * 2.0 - vec3<f32>(1.0);
        let TBN = mat3x3<f32>(input.worldT, input.worldB, input.worldN);
        let normal = normalize(texNormal * TBN);
        let diffuse = max(dot(constants.lightDir, normal), 0.0);
        color = vec4<f32>(
            color.xyz * (constants.lightColor.xyz * diffuse + constants.lightAmbient.xyz),
            color.w
        );
    }
    
    return color;
}
