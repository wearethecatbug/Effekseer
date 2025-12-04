// Effekseer GPU Particles Render Vertex Shader (WGSL)
// Equivalent to gpu_particles_render_vs.fx
// This is a simplified version - full GPU particles requires compute shader integration

struct VSInput {
    @location(0) pos: vec3<f32>,
    @location(1) normal: vec3<f32>,
    @location(2) binormal: vec3<f32>,
    @location(3) tangent: vec3<f32>,
    @location(4) uv: vec2<f32>,
    @location(5) color: vec4<f32>,
}

struct VSOutput {
    @builtin(position) position: vec4<f32>,
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

struct EmitterData {
    flagBits: u32,
    seed: u32,
    particleHead: u32,
    particleSize: u32,
    trailHead: u32,
    trailSize: u32,
    trailPhase: u32,
    nextEmitCount: u32,
    totalEmitCount: u32,
    emitPointCount: u32,
    timeCount: f32,
    timeStopped: f32,
    reserved0: u32,
    reserved1: u32,
    deltaTime: f32,
    color: u32,
    transform: mat4x3<f32>,
}

@group(0) @binding(0)
var<uniform> constants: RenderConstants;

@group(0) @binding(1)
var<uniform> paramData: ParameterData;

@group(0) @binding(2)
var<uniform> emitter: EmitterData;

@group(1) @binding(0)
var<storage, read> particles: array<u32>;

fn UnpackNormalizedFloat3(bits: u32) -> vec3<f32> {
    let v = vec3<f32>(vec3<u32>(bits, bits >> 10u, bits >> 20u) & vec3<u32>(1023u));
    return (v / 1023.0) * 2.0 - vec3<f32>(1.0);
}

fn UnpackColor(color32: u32) -> vec4<f32> {
    return vec4<f32>(
        f32(color32 & 255u),
        f32((color32 >> 8u) & 255u),
        f32((color32 >> 16u) & 255u),
        f32((color32 >> 24u) & 255u)
    ) / 255.0;
}

@vertex
fn main(
    input: VSInput,
    @builtin(instance_index) instanceIndex: u32,
    @builtin(vertex_index) vertexIndex: u32
) -> VSOutput {
    var output: VSOutput;
    
    let index = emitter.particleHead + instanceIndex;
    let baseOffset = index * 20u;
    
    // Read particle data
    let flagBits = particles[baseOffset + 0u];
    let particleColor = particles[baseOffset + 4u];
    
    // Read transform
    let t00 = bitcast<f32>(particles[baseOffset + 8u]);
    let t10 = bitcast<f32>(particles[baseOffset + 9u]);
    let t20 = bitcast<f32>(particles[baseOffset + 10u]);
    let t30 = bitcast<f32>(particles[baseOffset + 11u]);
    let t01 = bitcast<f32>(particles[baseOffset + 12u]);
    let t11 = bitcast<f32>(particles[baseOffset + 13u]);
    let t21 = bitcast<f32>(particles[baseOffset + 14u]);
    let t31 = bitcast<f32>(particles[baseOffset + 15u]);
    let t02 = bitcast<f32>(particles[baseOffset + 16u]);
    let t12 = bitcast<f32>(particles[baseOffset + 17u]);
    let t22 = bitcast<f32>(particles[baseOffset + 18u]);
    let t32 = bitcast<f32>(particles[baseOffset + 19u]);
    
    let transform = mat4x3<f32>(
        vec3<f32>(t00, t01, t02),
        vec3<f32>(t10, t11, t12),
        vec3<f32>(t20, t21, t22),
        vec3<f32>(t30, t31, t32)
    );
    
    if ((flagBits & 1u) != 0u) {
        var position = input.pos;
        var uv = input.uv;
        var color = input.color;
        
        // Simple sprite billboard transform
        if (paramData.shapeType == 0u) {
            // Apply particle scale/rotation from transform
            position = transform * vec4<f32>(position, 0.0);
            // Apply billboard
            position = constants.billboardMat * vec4<f32>(position, 0.0);
            // Add particle position
            position = position + transform[3];
        } else if (paramData.shapeType == 1u) {
            // Model: apply full transform
            if (constants.coordinateReversed != 0u) {
                position.z = -position.z;
            }
            position = transform * vec4<f32>(position, 1.0);
        }
        
        // Apply particle color
        color = color * UnpackColor(particleColor);
        color = vec4<f32>(color.xyz * paramData.emissive, color.w);
        
        output.position = constants.projMat * constants.cameraMat * vec4<f32>(position, 1.0);
        output.uv = uv;
        output.color = color;
        
        if (paramData.materialType == 1u) {
            output.worldN = transform * vec4<f32>(input.normal, 0.0);
            output.worldB = transform * vec4<f32>(input.binormal, 0.0);
            output.worldT = transform * vec4<f32>(input.tangent, 0.0);
        } else {
            output.worldN = vec3<f32>(0.0);
            output.worldB = vec3<f32>(0.0);
            output.worldT = vec3<f32>(0.0);
        }
    } else {
        // Inactive particle - degenerate
        output.position = vec4<f32>(0.0);
        output.uv = vec2<f32>(0.0);
        output.color = vec4<f32>(0.0);
        output.worldN = vec3<f32>(0.0);
        output.worldB = vec3<f32>(0.0);
        output.worldT = vec3<f32>(0.0);
    }
    
    return output;
}
