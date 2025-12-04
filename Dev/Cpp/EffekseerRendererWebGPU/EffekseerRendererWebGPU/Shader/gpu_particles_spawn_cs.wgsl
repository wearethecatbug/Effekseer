// Effekseer GPU Particles Spawn Compute Shader (WGSL)
// Converted from gpu_particles_spawn_cs.fx.comp

struct EmitterData {
    FlagBits: u32,
    Seed: u32,
    ParticleHead: u32,
    ParticleSize: u32,
    TrailHead: u32,
    TrailSize: u32,
    TrailPhase: u32,
    NextEmitCount: u32,
    TotalEmitCount: u32,
    EmitPointCount: u32,
    TimeCount: f32,
    TimeStopped: f32,
    Reserved0: u32,
    Reserved1: u32,
    DeltaTime: f32,
    Color: u32,
    Transform: mat4x3<f32>,
}

struct ParameterData {
    EmitCount: i32,
    EmitPerFrame: i32,
    EmitOffset: f32,
    Padding0: u32,
    LifeTime: vec2<f32>,
    EmitShapeType: u32,
    EmitRotationApplied: u32,
    EmitShapeData0: vec4<f32>,
    EmitShapeData1: vec4<f32>,
    Direction: vec3<f32>,
    Spread: f32,
    InitialSpeed: vec2<f32>,
    Damping: vec2<f32>,
    AngularOffset0: vec4<f32>,
    AngularOffset1: vec4<f32>,
    AngularVelocity0: vec4<f32>,
    AngularVelocity1: vec4<f32>,
    ScaleData1_0: vec4<f32>,
    ScaleData1_1: vec4<f32>,
    ScaleData2_0: vec4<f32>,
    ScaleData2_1: vec4<f32>,
    ScaleEasing: vec3<f32>,
    ScaleFlags: u32,
    Gravity: vec3<f32>,
    Padding2: u32,
    VortexCenter: vec3<f32>,
    VortexRotation: f32,
    VortexAxis: vec3<f32>,
    VortexAttraction: f32,
    TurbulencePower: f32,
    TurbulenceSeed: u32,
    TurbulenceScale: f32,
    TurbulenceOctave: f32,
    RenderState: u32,
    ShapeType: u32,
    ShapeData: u32,
    ShapeSize: f32,
    Emissive: f32,
    FadeIn: f32,
    FadeOut: f32,
    MaterialType: u32,
    ColorData: vec4<u32>,
    ColorEasing: vec3<f32>,
    ColorFlags: u32,
}

struct ComputeConstants {
    CoordinateReversed: u32,
    Reserved0: f32,
    Reserved1: f32,
    Reserved2: f32,
}

struct EmitPoint {
    Position: vec3<f32>,
    Reserved: u32,
    Normal: u32,
    Tangent: u32,
    UV: u32,
    Color: u32,
}

struct ParticleData {
    FlagBits: u32,
    Seed: u32,
    LifeAge: f32,
    InheritColor: u32,
    Color: u32,
    Direction: u32,
    Velocity: vec2<u32>,
    Transform: mat4x3<f32>,
}

@group(0) @binding(0)
var<uniform> constants: ComputeConstants;

@group(0) @binding(1)
var<uniform> paramData: ParameterData;

@group(0) @binding(2)
var<uniform> emitter: EmitterData;

@group(2) @binding(0)
var<storage, read_write> Particles: array<ParticleData>;

@group(2) @binding(1)
var<storage, read> EmitPoints: array<EmitPoint>;

fn RandomUint(seed: ptr<function, u32>) -> u32 {
    let state = *seed;
    *seed = (*seed * 747796405u) + 2891336453u;
    let word = ((state >> ((state >> 28u) + 4u)) ^ state) * 277803737u;
    return (word >> 22u) ^ word;
}

fn RandomFloat(seed: ptr<function, u32>) -> f32 {
    let result = RandomUint(seed);
    return f32(result) / 4294967296.0;
}

fn RandomFloatRange(seed: ptr<function, u32>, maxmin: vec2<f32>) -> f32 {
    let r = RandomFloat(seed);
    return mix(maxmin.y, maxmin.x, r);
}

fn RandomDirection(seed: ptr<function, u32>) -> vec3<f32> {
    let r1 = RandomFloat(seed);
    let cosTheta = -2.0 * r1 + 1.0;
    let sinTheta = sqrt(1.0 - cosTheta * cosTheta);
    let phi = 6.283184 * RandomFloat(seed);
    return vec3<f32>(sinTheta * cos(phi), sinTheta * sin(phi), cosTheta);
}

fn RandomCircle(seed: ptr<function, u32>, axis: vec3<f32>) -> vec3<f32> {
    let theta = 6.283184 * RandomFloat(seed);
    let direction = vec3<f32>(cos(theta), 0.0, sin(theta));
    let axisNorm = normalize(axis);
    if (abs(axisNorm.y) != 1.0) {
        let up = vec3<f32>(0.0, 1.0, 0.0);
        let right = normalize(cross(up, axisNorm));
        let front = cross(axisNorm, right);
        return mat3x3<f32>(right, axisNorm, front) * direction;
    } else {
        return direction * sign(axisNorm.y);
    }
}

fn RandomSpread(seed: ptr<function, u32>, baseDir: vec3<f32>, angle: f32) -> vec3<f32> {
    let theta = 6.283184 * RandomFloat(seed);
    let phi = angle * RandomFloat(seed);
    let randDir = vec3<f32>(sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi));
    let baseDirNorm = normalize(baseDir);
    if (abs(baseDirNorm.z) != 1.0) {
        let front = vec3<f32>(0.0, 0.0, 1.0);
        let right = normalize(cross(front, baseDirNorm));
        let up = cross(baseDirNorm, right);
        return mat3x3<f32>(right, up, baseDirNorm) * randDir;
    } else {
        return randDir * sign(baseDirNorm.z);
    }
}

fn UnpackNormalizedFloat3(bits: u32) -> vec3<f32> {
    let v = vec3<f32>(
        f32(bits & 1023u),
        f32((bits >> 10u) & 1023u),
        f32((bits >> 20u) & 1023u)
    );
    return (v / 1023.0) * 2.0 - vec3<f32>(1.0);
}

fn PackNormalizedFloat3(v: vec3<f32>) -> u32 {
    let i = vec3<u32>((v + vec3<f32>(1.0)) * 0.5 * 1023.0);
    return i.x | (i.y << 10u) | (i.z << 20u);
}

fn PackFloat4(v: vec4<f32>) -> vec2<u32> {
    let v16 = vec4<u32>(
        pack2x16float(vec2<f32>(v.x, 0.0)),
        pack2x16float(vec2<f32>(v.y, 0.0)),
        pack2x16float(vec2<f32>(v.z, 0.0)),
        pack2x16float(vec2<f32>(v.w, 0.0))
    );
    return vec2<u32>(v16.x | (v16.y << 16u), v16.z | (v16.w << 16u));
}

fn TRSMatrix(translation: vec3<f32>, rotation: vec3<f32>, scale: vec3<f32>) -> mat4x3<f32> {
    let s = sin(rotation);
    let c = cos(rotation);
    return mat4x3<f32>(
        vec3<f32>(
            scale.x * (c.z * c.y + s.z * s.x * s.y),
            scale.x * (-s.z * c.y + c.z * s.x * s.y),
            scale.x * c.x * s.y
        ),
        vec3<f32>(
            scale.y * s.z * c.x,
            scale.y * c.z * c.x,
            scale.y * -s.x
        ),
        vec3<f32>(
            scale.z * (c.z * -s.y + s.z * s.x * c.y),
            scale.z * (s.z * s.y + c.z * s.x * c.y),
            scale.z * c.x * c.y
        ),
        translation
    );
}

@compute @workgroup_size(1, 1, 1)
fn main(@builtin(global_invocation_id) dtid: vec3<u32>) {
    var seed = emitter.Seed ^ (emitter.TotalEmitCount + dtid.x);
    var position = vec3<f32>(0.0);
    var direction = RandomSpread(&seed, paramData.Direction, paramData.Spread * 3.14159 / 180.0);
    let speed = RandomFloatRange(&seed, paramData.InitialSpeed);
    
    // Emit shape handling
    if (paramData.EmitShapeType == 1u) {
        // Line
        let lineStart = paramData.EmitShapeData0.xyz;
        let lineEnd = paramData.EmitShapeData1.xyz;
        let lineWidth = paramData.EmitShapeData1.w;
        let t = RandomFloat(&seed);
        position = position + mix(lineStart, lineEnd, vec3<f32>(t));
        position = position + RandomDirection(&seed) * lineWidth * 0.5;
    } else if (paramData.EmitShapeType == 2u) {
        // Circle
        let circleAxis = paramData.EmitShapeData0.xyz;
        let circleInner = paramData.EmitShapeData1.x;
        let circleOuter = paramData.EmitShapeData1.y;
        let r = RandomFloat(&seed);
        let circleRadius = sqrt(mix(circleInner * circleInner, circleOuter * circleOuter, r));
        let circleDirection = RandomCircle(&seed, circleAxis);
        position = position + circleDirection * circleRadius;
        if (paramData.EmitRotationApplied != 0u) {
            var cd = circleDirection;
            if (constants.CoordinateReversed != 0u) {
                cd.z = -cd.z;
            }
            direction = mat3x3<f32>(cross(circleAxis, cd), circleAxis, cd) * direction;
        }
    } else if (paramData.EmitShapeType == 3u) {
        // Sphere
        let sphereRadius = paramData.EmitShapeData0.x;
        let sphereDirection = RandomDirection(&seed);
        position = position + sphereDirection * sphereRadius;
        if (paramData.EmitRotationApplied != 0u) {
            let sphereUp = vec3<f32>(0.0, 1.0, 0.0);
            var sd = sphereDirection;
            if (constants.CoordinateReversed != 0u) {
                sd.z = -sd.z;
            }
            direction = mat3x3<f32>(cross(sphereUp, sd), sphereUp, sd) * direction;
        }
    } else if (paramData.EmitShapeType == 4u) {
        // Model emit points
        let modelSize = paramData.EmitShapeData0.y;
        if (emitter.EmitPointCount > 0u) {
            let emitIndex = RandomUint(&seed) % emitter.EmitPointCount;
            var emitPosition = EmitPoints[emitIndex].Position;
            if (constants.CoordinateReversed != 0u) {
                emitPosition.z = -emitPosition.z;
            }
            position = position + emitPosition * modelSize;
            if (paramData.EmitRotationApplied != 0u) {
                let emitNormal = normalize(UnpackNormalizedFloat3(EmitPoints[emitIndex].Normal));
                let emitTangent = normalize(UnpackNormalizedFloat3(EmitPoints[emitIndex].Tangent));
                let emitBinormal = normalize(cross(emitTangent, emitNormal));
                direction = mat3x3<f32>(emitTangent, emitBinormal, emitNormal) * direction;
            }
        }
    }
    
    if (constants.CoordinateReversed != 0u) {
        direction.z = -direction.z;
    }
    
    // Transform to world space
    position = emitter.Transform * vec4<f32>(position, 1.0);
    direction = emitter.Transform * vec4<f32>(direction, 0.0);
    
    let particleID = emitter.ParticleHead + ((emitter.TotalEmitCount + dtid.x) % emitter.ParticleSize);
    
    var particle: ParticleData;
    particle.FlagBits = 1u;
    particle.Seed = seed;
    particle.LifeAge = 0.0;
    if (paramData.ColorFlags == 0u) {
        particle.InheritColor = 4294967295u;
    } else {
        particle.InheritColor = emitter.Color;
    }
    particle.Color = 4294967295u;
    particle.Transform = TRSMatrix(position, vec3<f32>(0.0), vec3<f32>(1.0));
    particle.Direction = PackNormalizedFloat3(direction);
    particle.Velocity = PackFloat4(vec4<f32>(direction * speed, 0.0));
    
    Particles[particleID] = particle;
}
