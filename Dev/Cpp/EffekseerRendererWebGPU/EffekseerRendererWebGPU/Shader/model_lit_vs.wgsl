struct VS_Input {
    Pos: vec3<f32>,
    Normal: vec3<f32>,
    Binormal: vec3<f32>,
    Tangent: vec3<f32>,
    UV1_: vec2<f32>,
    UV2_: vec2<f32>,
    Color: vec4<f32>,
    Index: u32,
}

struct VS_Output {
    PosVS: vec4<f32>,
    Color: vec4<f32>,
    UV: vec2<f32>,
    WorldN: vec3<f32>,
    WorldB: vec3<f32>,
    WorldT: vec3<f32>,
    PosP: vec4<f32>,
}

struct VS_ConstantBuffer {
    mCameraProj: mat4x4<f32>,
    mModel_Inst: array<mat4x4<f32>, 40>,
    fUV: array<vec4<f32>, 40>,
    fModelColor: array<vec4<f32>, 40>,
    fLightDirection: vec4<f32>,
    fLightColor: vec4<f32>,
    fLightAmbient: vec4<f32>,
    mUVInversed: vec4<f32>,
}

struct gl_PerVertex {
    @builtin(position) gl_Position: vec4<f32>,
    gl_PointSize: f32,
    gl_ClipDistance: array<f32, 1>,
}

struct VertexOutput {
    @builtin(position) gl_Position: vec4<f32>,
    @location(0) member: vec4<f32>,
    @location(1) member_1: vec2<f32>,
    @location(2) member_2: vec3<f32>,
    @location(3) member_3: vec3<f32>,
    @location(4) member_4: vec3<f32>,
    @location(5) member_5: vec4<f32>,
}

@group(0) @binding(0) 
var<uniform> _31_: VS_ConstantBuffer;
var<private> Input_Pos_1: vec3<f32>;
var<private> Input_Normal_1: vec3<f32>;
var<private> Input_Binormal_1: vec3<f32>;
var<private> Input_Tangent_1: vec3<f32>;
var<private> Input_UV1_1: vec2<f32>;
var<private> Input_UV2_1: vec2<f32>;
var<private> Input_Color_1: vec4<f32>;
var<private> gl_InstanceIndex_1: i32;
var<private> unnamed: gl_PerVertex = gl_PerVertex(vec4<f32>(0f, 0f, 0f, 1f), 1f, array<f32, 1>());
var<private> _entryPointOutput_Color: vec4<f32>;
var<private> _entryPointOutput_UV: vec2<f32>;
var<private> _entryPointOutput_WorldN: vec3<f32>;
var<private> _entryPointOutput_WorldB: vec3<f32>;
var<private> _entryPointOutput_WorldT: vec3<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var index: u32;
    var mModel: mat4x4<f32>;
    var uv: vec4<f32>;
    var modelColor: vec4<f32>;
    var Output: VS_Output;
    var localPos: vec4<f32>;
    var worldPos: vec4<f32>;
    var outputUV: vec2<f32>;
    var localNormal: vec4<f32>;
    var localBinormal: vec4<f32>;
    var localTangent: vec4<f32>;
    var worldNormal: vec4<f32>;
    var worldBinormal: vec4<f32>;
    var worldTangent: vec4<f32>;

    let _e51 = (*Input).Index;
    index = _e51;
    let _e52 = index;
    let _e55 = _31_.mModel_Inst[_e52];
    mModel = transpose(_e55);
    let _e57 = index;
    let _e60 = _31_.fUV[_e57];
    uv = _e60;
    let _e61 = index;
    let _e64 = _31_.fModelColor[_e61];
    let _e66 = (*Input).Color;
    modelColor = (_e64 * _e66);
    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec2<f32>(0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e70 = (*Input).Pos[0u];
    let _e73 = (*Input).Pos[1u];
    let _e76 = (*Input).Pos[2u];
    localPos = vec4<f32>(_e70, _e73, _e76, 1f);
    let _e78 = localPos;
    let _e79 = mModel;
    worldPos = (_e78 * _e79);
    let _e81 = worldPos;
    let _e83 = _31_.mCameraProj;
    Output.PosVS = (_e81 * transpose(_e83));
    let _e87 = modelColor;
    Output.Color = _e87;
    let _e90 = (*Input).UV1_;
    outputUV = _e90;
    let _e92 = outputUV[0u];
    let _e94 = uv[2u];
    let _e97 = uv[0u];
    outputUV[0u] = ((_e92 * _e94) + _e97);
    let _e101 = outputUV[1u];
    let _e103 = uv[3u];
    let _e106 = uv[1u];
    outputUV[1u] = ((_e101 * _e103) + _e106);
    let _e111 = _31_.mUVInversed[0u];
    let _e114 = _31_.mUVInversed[1u];
    let _e116 = outputUV[1u];
    outputUV[1u] = (_e111 + (_e114 * _e116));
    let _e120 = outputUV;
    Output.UV = _e120;
    let _e124 = (*Input).Normal[0u];
    let _e127 = (*Input).Normal[1u];
    let _e130 = (*Input).Normal[2u];
    localNormal = vec4<f32>(_e124, _e127, _e130, 0f);
    let _e134 = (*Input).Binormal[0u];
    let _e137 = (*Input).Binormal[1u];
    let _e140 = (*Input).Binormal[2u];
    localBinormal = vec4<f32>(_e134, _e137, _e140, 0f);
    let _e144 = (*Input).Tangent[0u];
    let _e147 = (*Input).Tangent[1u];
    let _e150 = (*Input).Tangent[2u];
    localTangent = vec4<f32>(_e144, _e147, _e150, 0f);
    let _e152 = localNormal;
    let _e153 = mModel;
    worldNormal = (_e152 * _e153);
    let _e155 = localBinormal;
    let _e156 = mModel;
    worldBinormal = (_e155 * _e156);
    let _e158 = localTangent;
    let _e159 = mModel;
    worldTangent = (_e158 * _e159);
    let _e161 = worldNormal;
    worldNormal = normalize(_e161);
    let _e163 = worldBinormal;
    worldBinormal = normalize(_e163);
    let _e165 = worldTangent;
    worldTangent = normalize(_e165);
    let _e167 = worldNormal;
    Output.WorldN = _e167.xyz;
    let _e170 = worldBinormal;
    Output.WorldB = _e170.xyz;
    let _e173 = worldTangent;
    Output.WorldT = _e173.xyz;
    let _e177 = Output.PosVS;
    Output.PosP = _e177;
    let _e179 = Output;
    return _e179;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param: VS_Input;
    var _position: vec4<f32>;

    let _e39 = Input_Pos_1;
    Input_1.Pos = _e39;
    let _e41 = Input_Normal_1;
    Input_1.Normal = _e41;
    let _e43 = Input_Binormal_1;
    Input_1.Binormal = _e43;
    let _e45 = Input_Tangent_1;
    Input_1.Tangent = _e45;
    let _e47 = Input_UV1_1;
    Input_1.UV1_ = _e47;
    let _e49 = Input_UV2_1;
    Input_1.UV2_ = _e49;
    let _e51 = Input_Color_1;
    Input_1.Color = _e51;
    let _e53 = gl_InstanceIndex_1;
    Input_1.Index = bitcast<u32>(_e53);
    let _e56 = Input_1;
    param = _e56;
    let _e57 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b((&param));
    flattenTemp = _e57;
    let _e59 = flattenTemp.PosVS;
    _position = _e59;
    let _e61 = _position[1u];
    _position[1u] = -(_e61);
    let _e64 = _position;
    unnamed.gl_Position = _e64;
    let _e67 = flattenTemp.Color;
    _entryPointOutput_Color = _e67;
    let _e69 = flattenTemp.UV;
    _entryPointOutput_UV = _e69;
    let _e71 = flattenTemp.WorldN;
    _entryPointOutput_WorldN = _e71;
    let _e73 = flattenTemp.WorldB;
    _entryPointOutput_WorldB = _e73;
    let _e75 = flattenTemp.WorldT;
    _entryPointOutput_WorldT = _e75;
    let _e77 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e77;
    return;
}

@vertex 
fn main(@location(0) Input_Pos: vec3<f32>, @location(1) Input_Normal: vec3<f32>, @location(2) Input_Binormal: vec3<f32>, @location(3) Input_Tangent: vec3<f32>, @location(4) Input_UV1_: vec2<f32>, @location(5) Input_UV2_: vec2<f32>, @location(6) Input_Color: vec4<f32>, @builtin(instance_index) gl_InstanceIndex: u32) -> VertexOutput {
    Input_Pos_1 = Input_Pos;
    Input_Normal_1 = Input_Normal;
    Input_Binormal_1 = Input_Binormal;
    Input_Tangent_1 = Input_Tangent;
    Input_UV1_1 = Input_UV1_;
    Input_UV2_1 = Input_UV2_;
    Input_Color_1 = Input_Color;
    gl_InstanceIndex_1 = i32(gl_InstanceIndex);
    main_1();
    let _e26 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e26);
    let _e28 = unnamed.gl_Position;
    let _e29 = _entryPointOutput_Color;
    let _e30 = _entryPointOutput_UV;
    let _e31 = _entryPointOutput_WorldN;
    let _e32 = _entryPointOutput_WorldB;
    let _e33 = _entryPointOutput_WorldT;
    let _e34 = _entryPointOutput_PosP;
    return VertexOutput(_e28, _e29, _e30, _e31, _e32, _e33, _e34);
}
