struct VS_Input {
    Pos: vec3<f32>,
    Color: vec4<f32>,
    Normal: vec4<f32>,
    Tangent: vec4<f32>,
    UV1_: vec2<f32>,
    UV2_: vec2<f32>,
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
    mCamera: mat4x4<f32>,
    mCameraProj: mat4x4<f32>,
    mUVInversed: vec4<f32>,
    mflipbookParameter: vec4<f32>,
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
var<uniform> _72_: VS_ConstantBuffer;
var<private> Input_Pos_1: vec3<f32>;
var<private> Input_Color_1: vec4<f32>;
var<private> Input_Normal_1: vec4<f32>;
var<private> Input_Tangent_1: vec4<f32>;
var<private> Input_UV1_1: vec2<f32>;
var<private> Input_UV2_1: vec2<f32>;
var<private> unnamed: gl_PerVertex = gl_PerVertex(vec4<f32>(0f, 0f, 0f, 1f), 1f, array<f32, 1>());
var<private> _entryPointOutput_UV: vec2<f32>;
var<private> _entryPointOutput_ProjBinormal: vec4<f32>;
var<private> _entryPointOutput_ProjTangent: vec4<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;
var<private> _entryPointOutput_Color: vec4<f32>;

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf21_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var Output: VS_Output;
    var worldNormal: vec4<f32>;
    var worldTangent: vec4<f32>;
    var worldBinormal: vec4<f32>;
    var worldPos: vec4<f32>;
    var uv1_: vec2<f32>;

    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec2<f32>(0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e38 = (*Input).Normal;
    let _e41 = ((_e38.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldNormal = vec4<f32>(_e41.x, _e41.y, _e41.z, 0f);
    let _e47 = (*Input).Tangent;
    let _e50 = ((_e47.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldTangent = vec4<f32>(_e50.x, _e50.y, _e50.z, 0f);
    let _e55 = worldNormal;
    let _e57 = worldTangent;
    let _e59 = cross(_e55.xyz, _e57.xyz);
    worldBinormal = vec4<f32>(_e59.x, _e59.y, _e59.z, 0f);
    let _e66 = (*Input).Pos[0u];
    let _e69 = (*Input).Pos[1u];
    let _e72 = (*Input).Pos[2u];
    worldPos = vec4<f32>(_e66, _e69, _e72, 1f);
    let _e74 = worldPos;
    let _e76 = _72_.mCameraProj;
    Output.PosVS = (_e74 * transpose(_e76));
    let _e81 = (*Input).Color;
    Output.Color = _e81;
    let _e84 = (*Input).UV1_;
    uv1_ = _e84;
    let _e87 = _72_.mUVInversed[0u];
    let _e90 = _72_.mUVInversed[1u];
    let _e92 = uv1_[1u];
    uv1_[1u] = (_e87 + (_e90 * _e92));
    let _e96 = uv1_;
    Output.UV = _e96;
    let _e98 = worldPos;
    let _e99 = worldTangent;
    let _e102 = _72_.mCameraProj;
    Output.ProjTangent = ((_e98 + _e99) * transpose(_e102));
    let _e106 = worldPos;
    let _e107 = worldBinormal;
    let _e110 = _72_.mCameraProj;
    Output.ProjBinormal = ((_e106 + _e107) * transpose(_e110));
    let _e115 = Output.PosVS;
    Output.PosP = _e115;
    let _e117 = Output;
    return _e117;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param: VS_Input;
    var _position: vec4<f32>;

    let _e34 = Input_Pos_1;
    Input_1.Pos = _e34;
    let _e36 = Input_Color_1;
    Input_1.Color = _e36;
    let _e38 = Input_Normal_1;
    Input_1.Normal = _e38;
    let _e40 = Input_Tangent_1;
    Input_1.Tangent = _e40;
    let _e42 = Input_UV1_1;
    Input_1.UV1_ = _e42;
    let _e44 = Input_UV2_1;
    Input_1.UV2_ = _e44;
    let _e46 = Input_1;
    param = _e46;
    let _e47 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf21_u003b((&param));
    flattenTemp = _e47;
    let _e49 = flattenTemp.PosVS;
    _position = _e49;
    let _e51 = _position[1u];
    _position[1u] = -(_e51);
    let _e54 = _position;
    unnamed.gl_Position = _e54;
    let _e57 = flattenTemp.UV;
    _entryPointOutput_UV = _e57;
    let _e59 = flattenTemp.ProjBinormal;
    _entryPointOutput_ProjBinormal = _e59;
    let _e61 = flattenTemp.ProjTangent;
    _entryPointOutput_ProjTangent = _e61;
    let _e63 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e63;
    let _e65 = flattenTemp.Color;
    _entryPointOutput_Color = _e65;
    return;
}

@vertex 
fn main(@location(0) Input_Pos: vec3<f32>, @location(1) Input_Color: vec4<f32>, @location(2) Input_Normal: vec4<f32>, @location(3) Input_Tangent: vec4<f32>, @location(4) Input_UV1_: vec2<f32>, @location(5) Input_UV2_: vec2<f32>) -> VertexOutput {
    Input_Pos_1 = Input_Pos;
    Input_Color_1 = Input_Color;
    Input_Normal_1 = Input_Normal;
    Input_Tangent_1 = Input_Tangent;
    Input_UV1_1 = Input_UV1_;
    Input_UV2_1 = Input_UV2_;
    main_1();
    let _e20 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e20);
    let _e22 = unnamed.gl_Position;
    let _e23 = _entryPointOutput_UV;
    let _e24 = _entryPointOutput_ProjBinormal;
    let _e25 = _entryPointOutput_ProjTangent;
    let _e26 = _entryPointOutput_PosP;
    let _e27 = _entryPointOutput_Color;
    return VertexOutput(_e22, _e23, _e24, _e25, _e26, _e27);
}
