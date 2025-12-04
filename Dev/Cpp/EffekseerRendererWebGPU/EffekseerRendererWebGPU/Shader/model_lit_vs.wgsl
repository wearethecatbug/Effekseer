// Effekseer Model Lit Vertex Shader (WGSL)
// Equivalent to model_lit_vs.fx

struct VSInput {
    @location(0) pos: vec3<f32>,
    @location(1) normal: vec3<f32>,
    @location(2) binormal: vec3<f32>,
    @location(3) tangent: vec3<f32>,
    @location(4) uv1: vec2<f32>,
    @location(5) uv2: vec2<f32>,
    @location(6) color: vec4<f32>,
}

struct VSOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec4<f32>,
    @location(1) uv: vec2<f32>,
    @location(2) worldN: vec3<f32>,
    @location(3) worldB: vec3<f32>,
    @location(4) worldT: vec3<f32>,
    @location(5) posP: vec4<f32>,
}

// Model constant buffer - contains per-instance data
// Max 40 instances (matching DX12)
struct VSConstantBuffer {
    mCameraProj: mat4x4<f32>,
    mModel_Inst: array<mat4x4<f32>, 40>,
    fUV: array<vec4<f32>, 40>,
    fModelColor: array<vec4<f32>, 40>,
    fLightDirection: vec4<f32>,
    fLightColor: vec4<f32>,
    fLightAmbient: vec4<f32>,
    mUVInversed: vec4<f32>,
}

@group(0) @binding(0)
var<uniform> cb: VSConstantBuffer;

@vertex
fn main(input: VSInput, @builtin(instance_index) instanceIndex: u32) -> VSOutput {
    var output: VSOutput;
    
    let index = instanceIndex;
    let mModel = cb.mModel_Inst[index];
    let uv = cb.fUV[index];
    let modelColor = cb.fModelColor[index] * input.color;
    
    let localPos = vec4<f32>(input.pos.x, input.pos.y, input.pos.z, 1.0);
    let worldPos = mModel * localPos;
    output.position = cb.mCameraProj * worldPos;
    output.color = modelColor;
    
    var outputUV = input.uv1;
    outputUV.x = outputUV.x * uv.z + uv.x;
    outputUV.y = outputUV.y * uv.w + uv.y;
    outputUV.y = cb.mUVInversed.x + cb.mUVInversed.y * outputUV.y;
    output.uv = outputUV;
    
    // Transform normals to world space
    let localNormal = vec4<f32>(input.normal, 0.0);
    let localBinormal = vec4<f32>(input.binormal, 0.0);
    let localTangent = vec4<f32>(input.tangent, 0.0);
    
    var worldNormal = mModel * localNormal;
    var worldBinormal = mModel * localBinormal;
    var worldTangent = mModel * localTangent;
    
    worldNormal = normalize(worldNormal);
    worldBinormal = normalize(worldBinormal);
    worldTangent = normalize(worldTangent);
    
    output.worldN = worldNormal.xyz;
    output.worldB = worldBinormal.xyz;
    output.worldT = worldTangent.xyz;
    output.posP = output.position;
    
    return output;
}
