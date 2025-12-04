// Effekseer Sprite Unlit Vertex Shader (WGSL)
// Equivalent to sprite_unlit_vs.fx

struct VSInput {
    @location(0) pos: vec3<f32>,
    @location(1) color: vec4<f32>,
    @location(2) uv: vec2<f32>,
}

struct VSOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec4<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) posP: vec4<f32>,
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
    
    let worldPos = vec4<f32>(input.pos.x, input.pos.y, input.pos.z, 1.0);
    output.position = cb.mCameraProj * worldPos;
    output.color = input.color;
    
    var uv1 = input.uv;
    uv1.y = cb.mUVInversed.x + (cb.mUVInversed.y * uv1.y);
    output.uv = uv1;
    
    output.posP = output.position;
    
    return output;
}
