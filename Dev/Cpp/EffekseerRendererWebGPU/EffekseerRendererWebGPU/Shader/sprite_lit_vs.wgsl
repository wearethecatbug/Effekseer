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
    Color: vec4<f32>,
    UV: vec2<f32>,
    WorldN: vec3<f32>,
    WorldB: vec3<f32>,
    WorldT: vec3<f32>,
    PosP: vec4<f32>,
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
    @location(0) member: vec4<f32>,
    @location(1) member_1: vec2<f32>,
    @location(2) member_2: vec3<f32>,
    @location(3) member_3: vec3<f32>,
    @location(4) member_4: vec3<f32>,
    @location(5) member_5: vec4<f32>,
}

@group(0) @binding(0) 
var<uniform> _73_: VS_ConstantBuffer;
var<private> Input_Pos_1: vec3<f32>;
var<private> Input_Color_1: vec4<f32>;
var<private> Input_Normal_1: vec4<f32>;
var<private> Input_Tangent_1: vec4<f32>;
var<private> Input_UV1_1: vec2<f32>;
var<private> Input_UV2_1: vec2<f32>;
var<private> unnamed: gl_PerVertex = gl_PerVertex(vec4<f32>(0f, 0f, 0f, 1f), 1f, array<f32, 1>());
var<private> _entryPointOutput_Color: vec4<f32>;
var<private> _entryPointOutput_UV: vec2<f32>;
var<private> _entryPointOutput_WorldN: vec3<f32>;
var<private> _entryPointOutput_WorldB: vec3<f32>;
var<private> _entryPointOutput_WorldT: vec3<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf21_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var Output: VS_Output;
    var worldNormal: vec4<f32>;
    var worldTangent: vec4<f32>;
    var worldBinormal: vec4<f32>;
    var worldPos: vec4<f32>;
    var uv1_: vec2<f32>;

    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec2<f32>(0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e41 = (*Input).Normal;
    let _e44 = ((_e41.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldNormal = vec4<f32>(_e44.x, _e44.y, _e44.z, 0f);
    let _e50 = (*Input).Tangent;
    let _e53 = ((_e50.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldTangent = vec4<f32>(_e53.x, _e53.y, _e53.z, 0f);
    let _e58 = worldNormal;
    let _e60 = worldTangent;
    let _e62 = cross(_e58.xyz, _e60.xyz);
    worldBinormal = vec4<f32>(_e62.x, _e62.y, _e62.z, 0f);
    let _e69 = (*Input).Pos[0u];
    let _e72 = (*Input).Pos[1u];
    let _e75 = (*Input).Pos[2u];
    worldPos = vec4<f32>(_e69, _e72, _e75, 1f);
    let _e77 = worldPos;
    let _e79 = _73_.mCameraProj;
    Output.PosVS = (_e77 * transpose(_e79));
    let _e84 = (*Input).Color;
    Output.Color = _e84;
    let _e87 = (*Input).UV1_;
    uv1_ = _e87;
    let _e90 = _73_.mUVInversed[0u];
    let _e93 = _73_.mUVInversed[1u];
    let _e95 = uv1_[1u];
    uv1_[1u] = (_e90 + (_e93 * _e95));
    let _e99 = uv1_;
    Output.UV = _e99;
    let _e101 = worldNormal;
    Output.WorldN = _e101.xyz;
    let _e104 = worldBinormal;
    Output.WorldB = _e104.xyz;
    let _e107 = worldTangent;
    Output.WorldT = _e107.xyz;
    let _e111 = Output.PosVS;
    Output.PosP = _e111;
    let _e113 = Output;
    return _e113;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param: VS_Input;
    var _position: vec4<f32>;

    let _e37 = Input_Pos_1;
    Input_1.Pos = _e37;
    let _e39 = Input_Color_1;
    Input_1.Color = _e39;
    let _e41 = Input_Normal_1;
    Input_1.Normal = _e41;
    let _e43 = Input_Tangent_1;
    Input_1.Tangent = _e43;
    let _e45 = Input_UV1_1;
    Input_1.UV1_ = _e45;
    let _e47 = Input_UV2_1;
    Input_1.UV2_ = _e47;
    let _e49 = Input_1;
    param = _e49;
    let _e50 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf21_u003b((&param));
    flattenTemp = _e50;
    let _e52 = flattenTemp.PosVS;
    _position = _e52;
    let _e54 = _position[1u];
    _position[1u] = -(_e54);
    let _e57 = _position;
    unnamed.gl_Position = _e57;
    let _e60 = flattenTemp.Color;
    _entryPointOutput_Color = _e60;
    let _e62 = flattenTemp.UV;
    _entryPointOutput_UV = _e62;
    let _e64 = flattenTemp.WorldN;
    _entryPointOutput_WorldN = _e64;
    let _e66 = flattenTemp.WorldB;
    _entryPointOutput_WorldB = _e66;
    let _e68 = flattenTemp.WorldT;
    _entryPointOutput_WorldT = _e68;
    let _e70 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e70;
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
    let _e21 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e21);
    let _e23 = unnamed.gl_Position;
    let _e24 = _entryPointOutput_Color;
    let _e25 = _entryPointOutput_UV;
    let _e26 = _entryPointOutput_WorldN;
    let _e27 = _entryPointOutput_WorldB;
    let _e28 = _entryPointOutput_WorldT;
    let _e29 = _entryPointOutput_PosP;
    return VertexOutput(_e23, _e24, _e25, _e26, _e27, _e28, _e29);
}
