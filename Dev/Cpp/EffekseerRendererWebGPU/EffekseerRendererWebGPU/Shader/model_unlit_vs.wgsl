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
    @location(2) member_2: vec4<f32>,
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

    let _e41 = (*Input).Index;
    index = _e41;
    let _e42 = index;
    let _e45 = _31_.mModel_Inst[_e42];
    mModel = transpose(_e45);
    let _e47 = index;
    let _e50 = _31_.fUV[_e47];
    uv = _e50;
    let _e51 = index;
    let _e54 = _31_.fModelColor[_e51];
    let _e56 = (*Input).Color;
    modelColor = (_e54 * _e56);
    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec2<f32>(0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e60 = (*Input).Pos[0u];
    let _e63 = (*Input).Pos[1u];
    let _e66 = (*Input).Pos[2u];
    localPos = vec4<f32>(_e60, _e63, _e66, 1f);
    let _e68 = localPos;
    let _e69 = mModel;
    worldPos = (_e68 * _e69);
    let _e71 = worldPos;
    let _e73 = _31_.mCameraProj;
    Output.PosVS = (_e71 * transpose(_e73));
    let _e77 = modelColor;
    Output.Color = _e77;
    let _e80 = (*Input).UV1_;
    outputUV = _e80;
    let _e82 = outputUV[0u];
    let _e84 = uv[2u];
    let _e87 = uv[0u];
    outputUV[0u] = ((_e82 * _e84) + _e87);
    let _e91 = outputUV[1u];
    let _e93 = uv[3u];
    let _e96 = uv[1u];
    outputUV[1u] = ((_e91 * _e93) + _e96);
    let _e101 = _31_.mUVInversed[0u];
    let _e104 = _31_.mUVInversed[1u];
    let _e106 = outputUV[1u];
    outputUV[1u] = (_e101 + (_e104 * _e106));
    let _e110 = outputUV;
    Output.UV = _e110;
    let _e113 = Output.PosVS;
    Output.PosP = _e113;
    let _e115 = Output;
    return _e115;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param: VS_Input;
    var _position: vec4<f32>;

    let _e35 = Input_Pos_1;
    Input_1.Pos = _e35;
    let _e37 = Input_Normal_1;
    Input_1.Normal = _e37;
    let _e39 = Input_Binormal_1;
    Input_1.Binormal = _e39;
    let _e41 = Input_Tangent_1;
    Input_1.Tangent = _e41;
    let _e43 = Input_UV1_1;
    Input_1.UV1_ = _e43;
    let _e45 = Input_UV2_1;
    Input_1.UV2_ = _e45;
    let _e47 = Input_Color_1;
    Input_1.Color = _e47;
    let _e49 = gl_InstanceIndex_1;
    Input_1.Index = bitcast<u32>(_e49);
    let _e52 = Input_1;
    param = _e52;
    let _e53 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b((&param));
    flattenTemp = _e53;
    let _e55 = flattenTemp.PosVS;
    _position = _e55;
    let _e57 = _position[1u];
    _position[1u] = -(_e57);
    let _e60 = _position;
    unnamed.gl_Position = _e60;
    let _e63 = flattenTemp.Color;
    _entryPointOutput_Color = _e63;
    let _e65 = flattenTemp.UV;
    _entryPointOutput_UV = _e65;
    let _e67 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e67;
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
    let _e23 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e23);
    let _e25 = unnamed.gl_Position;
    let _e26 = _entryPointOutput_Color;
    let _e27 = _entryPointOutput_UV;
    let _e28 = _entryPointOutput_PosP;
    return VertexOutput(_e25, _e26, _e27, _e28);
}
