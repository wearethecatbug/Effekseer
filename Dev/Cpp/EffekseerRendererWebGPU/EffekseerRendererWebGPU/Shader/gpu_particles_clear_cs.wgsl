// Effekseer GPU Particles Clear Compute Shader (WGSL)
// Equivalent to gpu_particles_clear_cs.fx

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

struct ComputeConstants {
    coordinateReversed: u32,
    reserved0: f32,
    reserved1: f32,
    reserved2: f32,
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

// Particle data structure (80 bytes per particle)
// Stored as raw bytes in storage buffer

@group(0) @binding(0)
var<uniform> constants: ComputeConstants;

@group(0) @binding(1)
var<uniform> paramData: ParameterData;

@group(0) @binding(2)
var<uniform> emitter: EmitterData;

@group(1) @binding(0)
var<storage, read_write> particles: array<u32>;

@compute @workgroup_size(256, 1, 1)
fn main(@builtin(global_invocation_id) dtid: vec3<u32>) {
    let particleID = emitter.particleHead + dtid.x;
    let baseOffset = particleID * 20u; // 80 bytes / 4 bytes per u32 = 20 u32s
    
    // Clear particle data
    // FlagBits = 0 (inactive)
    particles[baseOffset + 0u] = 0u;
    // Seed = 0
    particles[baseOffset + 1u] = 0u;
    // LifeAge = 0.0
    particles[baseOffset + 2u] = 0u;
    // InheritColor = 0
    particles[baseOffset + 3u] = 0u;
    // Color = 0
    particles[baseOffset + 4u] = 0u;
    // Direction = 0
    particles[baseOffset + 5u] = 0u;
    // Velocity (2 u32s)
    particles[baseOffset + 6u] = 0u;
    particles[baseOffset + 7u] = 0u;
    // Transform (12 floats = 12 u32s)
    for (var i = 0u; i < 12u; i = i + 1u) {
        particles[baseOffset + 8u + i] = 0u;
    }
}
