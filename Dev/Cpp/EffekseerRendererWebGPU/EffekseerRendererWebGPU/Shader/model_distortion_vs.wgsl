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
    UV: vec2<f32>,
    ProjBinormal: vec4<f32>,
    ProjTangent: vec4<f32>,
    PosP: vec4<f32>,
    Color: vec4<f32>,
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
    @location(0) member: vec2<f32>,
    @location(1) member_1: vec4<f32>,
    @location(2) member_2: vec4<f32>,
    @location(3) member_3: vec4<f32>,
    @location(4) member_4: vec4<f32>,
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
var<private> _entryPointOutput_UV: vec2<f32>;
var<private> _entryPointOutput_ProjBinormal: vec4<f32>;
var<private> _entryPointOutput_ProjTangent: vec4<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;
var<private> _entryPointOutput_Color: vec4<f32>;

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

    let _e49 = (*Input).Index;
    index = _e49;
    let _e50 = index;
    let _e53 = _31_.mModel_Inst[_e50];
    mModel = transpose(_e53);
    let _e55 = index;
    let _e58 = _31_.fUV[_e55];
    uv = _e58;
    let _e59 = index;
    let _e62 = _31_.fModelColor[_e59];
    let _e64 = (*Input).Color;
    modelColor = (_e62 * _e64);
    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec2<f32>(0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e68 = (*Input).Pos[0u];
    let _e71 = (*Input).Pos[1u];
    let _e74 = (*Input).Pos[2u];
    localPos = vec4<f32>(_e68, _e71, _e74, 1f);
    let _e76 = localPos;
    let _e77 = mModel;
    worldPos = (_e76 * _e77);
    let _e79 = worldPos;
    let _e81 = _31_.mCameraProj;
    Output.PosVS = (_e79 * transpose(_e81));
    let _e85 = modelColor;
    Output.Color = _e85;
    let _e88 = (*Input).UV1_;
    outputUV = _e88;
    let _e90 = outputUV[0u];
    let _e92 = uv[2u];
    let _e95 = uv[0u];
    outputUV[0u] = ((_e90 * _e92) + _e95);
    let _e99 = outputUV[1u];
    let _e101 = uv[3u];
    let _e104 = uv[1u];
    outputUV[1u] = ((_e99 * _e101) + _e104);
    let _e109 = _31_.mUVInversed[0u];
    let _e112 = _31_.mUVInversed[1u];
    let _e114 = outputUV[1u];
    outputUV[1u] = (_e109 + (_e112 * _e114));
    let _e118 = outputUV;
    Output.UV = _e118;
    let _e122 = (*Input).Normal[0u];
    let _e125 = (*Input).Normal[1u];
    let _e128 = (*Input).Normal[2u];
    localNormal = vec4<f32>(_e122, _e125, _e128, 0f);
    let _e132 = (*Input).Binormal[0u];
    let _e135 = (*Input).Binormal[1u];
    let _e138 = (*Input).Binormal[2u];
    localBinormal = vec4<f32>(_e132, _e135, _e138, 0f);
    let _e142 = (*Input).Tangent[0u];
    let _e145 = (*Input).Tangent[1u];
    let _e148 = (*Input).Tangent[2u];
    localTangent = vec4<f32>(_e142, _e145, _e148, 0f);
    let _e150 = localNormal;
    let _e151 = mModel;
    worldNormal = (_e150 * _e151);
    let _e153 = localBinormal;
    let _e154 = mModel;
    worldBinormal = (_e153 * _e154);
    let _e156 = localTangent;
    let _e157 = mModel;
    worldTangent = (_e156 * _e157);
    let _e159 = worldNormal;
    worldNormal = normalize(_e159);
    let _e161 = worldBinormal;
    worldBinormal = normalize(_e161);
    let _e163 = worldTangent;
    worldTangent = normalize(_e163);
    let _e165 = worldPos;
    let _e166 = worldBinormal;
    let _e169 = _31_.mCameraProj;
    Output.ProjBinormal = ((_e165 + _e166) * transpose(_e169));
    let _e173 = worldPos;
    let _e174 = worldTangent;
    let _e177 = _31_.mCameraProj;
    Output.ProjTangent = ((_e173 + _e174) * transpose(_e177));
    let _e182 = Output.PosVS;
    Output.PosP = _e182;
    let _e184 = Output;
    return _e184;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param: VS_Input;
    var _position: vec4<f32>;

    let _e37 = Input_Pos_1;
    Input_1.Pos = _e37;
    let _e39 = Input_Normal_1;
    Input_1.Normal = _e39;
    let _e41 = Input_Binormal_1;
    Input_1.Binormal = _e41;
    let _e43 = Input_Tangent_1;
    Input_1.Tangent = _e43;
    let _e45 = Input_UV1_1;
    Input_1.UV1_ = _e45;
    let _e47 = Input_UV2_1;
    Input_1.UV2_ = _e47;
    let _e49 = Input_Color_1;
    Input_1.Color = _e49;
    let _e51 = gl_InstanceIndex_1;
    Input_1.Index = bitcast<u32>(_e51);
    let _e54 = Input_1;
    param = _e54;
    let _e55 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b((&param));
    flattenTemp = _e55;
    let _e57 = flattenTemp.PosVS;
    _position = _e57;
    let _e59 = _position[1u];
    _position[1u] = -(_e59);
    let _e62 = _position;
    unnamed.gl_Position = _e62;
    let _e65 = flattenTemp.UV;
    _entryPointOutput_UV = _e65;
    let _e67 = flattenTemp.ProjBinormal;
    _entryPointOutput_ProjBinormal = _e67;
    let _e69 = flattenTemp.ProjTangent;
    _entryPointOutput_ProjTangent = _e69;
    let _e71 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e71;
    let _e73 = flattenTemp.Color;
    _entryPointOutput_Color = _e73;
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
    let _e25 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e25);
    let _e27 = unnamed.gl_Position;
    let _e28 = _entryPointOutput_UV;
    let _e29 = _entryPointOutput_ProjBinormal;
    let _e30 = _entryPointOutput_ProjTangent;
    let _e31 = _entryPointOutput_PosP;
    let _e32 = _entryPointOutput_Color;
    return VertexOutput(_e27, _e28, _e29, _e30, _e31, _e32);
}
