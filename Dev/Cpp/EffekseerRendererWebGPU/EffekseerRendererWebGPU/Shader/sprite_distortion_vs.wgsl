// Effekseer Sprite Distortion Vertex Shader (WGSL)
// Equivalent to sprite_distortion_vs.fx

struct VSInput {
    @location(0) pos: vec3<f32>,
    @location(1) color: vec4<f32>,
    @location(2) normal: vec4<f32>,
    @location(3) tangent: vec4<f32>,
    @location(4) uv1: vec2<f32>,
    @location(5) uv2: vec2<f32>,
}

struct VSOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) uv: vec2<f32>,
    @location(1) projBinormal: vec4<f32>,
    @location(2) projTangent: vec4<f32>,
    @location(3) posP: vec4<f32>,
    @location(4) color: vec4<f32>,
}

struct VSConstantBuffer {
    mCamera: mat4x4<f32>,
    mCameraProj: mat4x4<f32>,
    mUVInversed: vec4<f32>,
    mflipbookParameter: vec4<f32>,
}

@group(0) @binding(0)
var<uniform> cb: VSConstantBuffer;

@vertex
fn main(input: VSInput) -> VSOutput {
    var output: VSOutput;
    
    // Decode normals/tangents from [0,1] to [-1,1] range
    let worldNormal = vec4<f32>((input.normal.xyz - vec3<f32>(0.5)) * 2.0, 0.0);
    let worldTangent = vec4<f32>((input.tangent.xyz - vec3<f32>(0.5)) * 2.0, 0.0);
    let worldBinormal = vec4<f32>(cross(worldNormal.xyz, worldTangent.xyz), 0.0);
    
    let worldPos = vec4<f32>(input.pos.x, input.pos.y, input.pos.z, 1.0);
    output.position = cb.mCameraProj * worldPos;
    output.color = input.color;
    
    var uv1 = input.uv1;
    uv1.y = cb.mUVInversed.x + (cb.mUVInversed.y * uv1.y);
    output.uv = uv1;
    
    output.projTangent = cb.mCameraProj * (worldPos + worldTangent);
    output.projBinormal = cb.mCameraProj * (worldPos + worldBinormal);
    output.posP = output.position;
    
    return output;
}
