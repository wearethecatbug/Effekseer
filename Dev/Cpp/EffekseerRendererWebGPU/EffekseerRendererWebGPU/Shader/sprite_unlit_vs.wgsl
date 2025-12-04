struct VS_Input {
    Pos: vec3<f32>,
    Color: vec4<f32>,
    UV: vec2<f32>,
}

struct VS_Output {
    PosVS: vec4<f32>,
    Color: vec4<f32>,
    UV: vec2<f32>,
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
    @location(2) member_2: vec4<f32>,
}

@group(0) @binding(0) 
var<uniform> _39_: VS_ConstantBuffer;
var<private> Input_Pos_1: vec3<f32>;
var<private> Input_Color_1: vec4<f32>;
var<private> Input_UV_1: vec2<f32>;
var<private> unnamed: gl_PerVertex = gl_PerVertex(vec4<f32>(0f, 0f, 0f, 1f), 1f, array<f32, 1>());
var<private> _entryPointOutput_Color: vec4<f32>;
var<private> _entryPointOutput_UV: vec2<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf21_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var Output: VS_Output;
    var worldPos: vec4<f32>;
    var uv1_: vec2<f32>;

    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec2<f32>(0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e26 = (*Input).Pos[0u];
    let _e29 = (*Input).Pos[1u];
    let _e32 = (*Input).Pos[2u];
    worldPos = vec4<f32>(_e26, _e29, _e32, 1f);
    let _e34 = worldPos;
    let _e36 = _39_.mCameraProj;
    Output.PosVS = (_e34 * transpose(_e36));
    let _e41 = (*Input).Color;
    Output.Color = _e41;
    let _e44 = (*Input).UV;
    uv1_ = _e44;
    let _e47 = _39_.mUVInversed[0u];
    let _e50 = _39_.mUVInversed[1u];
    let _e52 = uv1_[1u];
    uv1_[1u] = (_e47 + (_e50 * _e52));
    let _e56 = uv1_;
    Output.UV = _e56;
    let _e59 = Output.PosVS;
    Output.PosP = _e59;
    let _e61 = Output;
    return _e61;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param: VS_Input;
    var _position: vec4<f32>;

    let _e24 = Input_Pos_1;
    Input_1.Pos = _e24;
    let _e26 = Input_Color_1;
    Input_1.Color = _e26;
    let _e28 = Input_UV_1;
    Input_1.UV = _e28;
    let _e30 = Input_1;
    param = _e30;
    let _e31 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf21_u003b((&param));
    flattenTemp = _e31;
    let _e33 = flattenTemp.PosVS;
    _position = _e33;
    let _e35 = _position[1u];
    _position[1u] = -(_e35);
    let _e38 = _position;
    unnamed.gl_Position = _e38;
    let _e41 = flattenTemp.Color;
    _entryPointOutput_Color = _e41;
    let _e43 = flattenTemp.UV;
    _entryPointOutput_UV = _e43;
    let _e45 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e45;
    return;
}

@vertex 
fn main(@location(0) Input_Pos: vec3<f32>, @location(1) Input_Color: vec4<f32>, @location(2) Input_UV: vec2<f32>) -> VertexOutput {
    Input_Pos_1 = Input_Pos;
    Input_Color_1 = Input_Color;
    Input_UV_1 = Input_UV;
    main_1();
    let _e12 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e12);
    let _e14 = unnamed.gl_Position;
    let _e15 = _entryPointOutput_Color;
    let _e16 = _entryPointOutput_UV;
    let _e17 = _entryPointOutput_PosP;
    return VertexOutput(_e14, _e15, _e16, _e17);
}
