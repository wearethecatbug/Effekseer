// Effekseer GPU Particles Update Compute Shader (WGSL)
// Converted from gpu_particles_update_cs.fx.comp

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

struct TrailData {
    Position: vec3<f32>,
    Direction: u32,
}

struct ComputeConstants {
    CoordinateReversed: u32,
    Reserved0: f32,
    Reserved1: f32,
    Reserved2: f32,
}

@group(0) @binding(0)
var<uniform> constants: ComputeConstants;

@group(0) @binding(1)
var<uniform> paramData: ParameterData;

@group(0) @binding(2)
var<uniform> emitter: EmitterData;

@group(1) @binding(2)
var noiseTex: texture_3d<f32>;
@group(1) @binding(3)
var noiseSampler: sampler;

@group(1) @binding(4)
var gradientTex: texture_2d<f32>;
@group(1) @binding(5)
var gradientSampler: sampler;

@group(2) @binding(0)
var<storage, read_write> Particles: array<ParticleData>;

@group(2) @binding(1)
var<storage, read_write> Trails: array<TrailData>;

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

fn RandomFloat4Range(seed: ptr<function, u32>, min: vec4<f32>, max: vec4<f32>) -> vec4<f32> {
    let r = RandomFloat(seed);
    return mix(max, min, vec4<f32>(r));
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

fn UnpackFloat4(bits: vec2<u32>) -> vec4<f32> {
    return vec4<f32>(
        unpack2x16float(bits.x).x,
        unpack2x16float(bits.x >> 16u).x,
        unpack2x16float(bits.y).x,
        unpack2x16float(bits.y >> 16u).x
    );
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

fn UnpackColor(color32: u32) -> vec4<f32> {
    return vec4<f32>(
        f32(color32 & 255u),
        f32((color32 >> 8u) & 255u),
        f32((color32 >> 16u) & 255u),
        f32((color32 >> 24u) & 255u)
    ) / 255.0;
}

fn PackColor(color: vec4<f32>) -> u32 {
    let colori = vec4<u32>(clamp(color * 255.0, vec4<f32>(0.0), vec4<f32>(255.0)));
    return colori.x | (colori.y << 8u) | (colori.z << 16u) | (colori.w << 24u);
}

fn RandomColorRange(seed: ptr<function, u32>, minColor: u32, maxColor: u32) -> vec4<f32> {
    let r = RandomFloat(seed);
    return mix(UnpackColor(maxColor), UnpackColor(minColor), vec4<f32>(r));
}

fn HSV2RGB(c: vec3<f32>) -> vec3<f32> {
    let k = vec4<f32>(1.0, 0.666666687, 0.333333343, 3.0);
    let p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
    return mix(k.xxx, clamp(p - k.xxx, vec3<f32>(0.0), vec3<f32>(1.0)), vec3<f32>(c.y)) * c.z;
}

fn EasingSpeed(t: f32, params: vec3<f32>) -> f32 {
    return params.x * t * t * t + params.y * t * t + params.z * t;
}

fn Vortex(rotation: f32, attraction: f32, center: vec3<f32>, axis: vec3<f32>, position: vec3<f32>, transform: mat4x3<f32>) -> vec3<f32> {
    let worldCenter = transform[3] + center;
    let worldAxis = normalize(transform * vec4<f32>(axis, 0.0));
    let localPos = position - worldCenter;
    let axisToPos = localPos - worldAxis * dot(worldAxis, localPos);
    let dist = length(axisToPos);
    if (dist < 0.0001) {
        return vec3<f32>(0.0);
    }
    let radial = normalize(axisToPos);
    let tangent = cross(worldAxis, radial);
    return tangent * rotation - radial * attraction;
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

@compute @workgroup_size(256, 1, 1)
fn main(@builtin(global_invocation_id) dtid: vec3<u32>) {
    let particleID = emitter.ParticleHead + dtid.x;
    var particle = Particles[particleID];
    
    if ((particle.FlagBits & 1u) != 0u) {
        let updateCount = (particle.FlagBits >> 1u) & 255u;
        let deltaTime = emitter.DeltaTime;
        var seed = particle.Seed;
        
        let lifeTime = RandomFloatRange(&seed, paramData.LifeTime);
        let lifeRatio = particle.LifeAge / lifeTime;
        let damping = RandomFloatRange(&seed, paramData.Damping) * 0.01;
        let angularOffset = RandomFloat4Range(&seed, paramData.AngularOffset0, paramData.AngularOffset1);
        let angularVelocity = RandomFloat4Range(&seed, paramData.AngularVelocity0, paramData.AngularVelocity1);
        
        var position = particle.Transform[3];
        let lastPosition = position;
        var direction = normalize(UnpackNormalizedFloat3(particle.Direction));
        var velocity = UnpackFloat4(particle.Velocity).xyz;
        
        // Trail handling
        if (emitter.TrailSize > 0u) {
            let trailID = emitter.TrailHead + (dtid.x * paramData.ShapeData) + emitter.TrailPhase;
            var trail: TrailData;
            trail.Position = position;
            trail.Direction = PackNormalizedFloat3(direction);
            Trails[trailID] = trail;
        }
        
        // Update flags
        particle.FlagBits = particle.FlagBits & 4294966785u;
        particle.FlagBits = particle.FlagBits | (clamp(updateCount + 1u, 0u, 255u) << 1u);
        particle.LifeAge = particle.LifeAge + deltaTime;
        
        if (particle.LifeAge >= lifeTime) {
            particle.FlagBits = particle.FlagBits & 4294967294u;
        }
        
        // Apply gravity
        velocity = velocity + paramData.Gravity * deltaTime;
        
        // Apply damping
        let speed = length(velocity);
        if (speed > 0.0) {
            let newSpeed = max(0.0, speed - damping * deltaTime);
            velocity = velocity * (newSpeed / speed);
        }
        
        // Update position
        position = position + velocity * deltaTime;
        
        // Vortex
        if (paramData.VortexRotation != 0.0 || paramData.VortexAttraction != 0.0) {
            let vortexForce = Vortex(
                paramData.VortexRotation,
                paramData.VortexAttraction,
                paramData.VortexCenter,
                paramData.VortexAxis,
                position,
                emitter.Transform
            );
            position = position + vortexForce * deltaTime;
        }
        
        // Turbulence
        if (paramData.TurbulencePower != 0.0) {
            let noiseCoord = position * paramData.TurbulenceScale + vec3<f32>(0.5);
            let vfTexel = textureSampleLevel(noiseTex, noiseSampler, noiseCoord, 0.0);
            position = position + (vfTexel.xyz * 2.0 - vec3<f32>(1.0)) * paramData.TurbulencePower * deltaTime;
        }
        
        // Update direction
        let diff = position - lastPosition;
        if (length(diff) > 0.0001) {
            direction = normalize(diff);
        }
        
        // Rotation
        let rotation = angularOffset.xyz + angularVelocity.xyz * particle.LifeAge;
        
        // Scale
        var scale = vec4<f32>(1.0);
        let scaleMode = paramData.ScaleFlags & 7u;
        if (scaleMode == 0u) {
            scale = RandomFloat4Range(&seed, paramData.ScaleData1_0, paramData.ScaleData1_1);
        } else if (scaleMode == 2u) {
            let scale1 = RandomFloat4Range(&seed, paramData.ScaleData1_0, paramData.ScaleData1_1);
            let scale2 = RandomFloat4Range(&seed, paramData.ScaleData2_0, paramData.ScaleData2_1);
            scale = mix(scale1, scale2, vec4<f32>(EasingSpeed(lifeRatio, paramData.ScaleEasing)));
        }
        
        // Color
        var color = vec4<f32>(1.0);
        let colorMode = paramData.ColorFlags & 7u;
        if (colorMode == 0u) {
            color = UnpackColor(paramData.ColorData.x);
        } else if (colorMode == 1u) {
            color = RandomColorRange(&seed, paramData.ColorData.x, paramData.ColorData.y);
        } else if (colorMode == 2u) {
            let colorStart = RandomColorRange(&seed, paramData.ColorData.x, paramData.ColorData.y);
            let colorEnd = RandomColorRange(&seed, paramData.ColorData.z, paramData.ColorData.w);
            color = mix(colorStart, colorEnd, vec4<f32>(EasingSpeed(lifeRatio, paramData.ColorEasing)));
        } else if (colorMode == 3u || colorMode == 4u) {
            color = textureSampleLevel(gradientTex, gradientSampler, vec2<f32>(lifeRatio, 0.0), 0.0);
        }
        
        // HSV to RGB conversion
        if (((paramData.ColorFlags >> 5u) & 1u) != 0u) {
            color = vec4<f32>(HSV2RGB(color.xyz), color.w);
        }
        
        // Color inheritance
        let colorInherit = (paramData.ColorFlags >> 3u) & 3u;
        if (colorInherit == 2u || colorInherit == 3u) {
            color = color * UnpackColor(emitter.Color);
        } else {
            color = color * UnpackColor(particle.InheritColor);
        }
        
        // Fade in/out
        color.w = color.w * clamp(particle.LifeAge / paramData.FadeIn, 0.0, 1.0);
        color.w = color.w * clamp((lifeTime - particle.LifeAge) / paramData.FadeOut, 0.0, 1.0);
        
        // Update particle
        particle.Transform = TRSMatrix(position, rotation, scale.xyz * scale.w * paramData.ShapeSize);
        particle.Velocity = PackFloat4(vec4<f32>(velocity, 0.0));
        particle.Direction = PackNormalizedFloat3(direction);
        particle.Color = PackColor(color);
        
        Particles[particleID] = particle;
    }
}
