struct VS_Input {
    Pos: vec3<f32>,
    Color: vec4<f32>,
    UV: vec2<f32>,
    Alpha_Dist_UV: vec4<f32>,
    BlendUV: vec2<f32>,
    Blend_Alpha_Dist_UV: vec4<f32>,
    FlipbookIndex: f32,
    AlphaThreshold: f32,
}

struct VS_Output {
    PosVS: vec4<f32>,
    Color: vec4<f32>,
    UV_Others: vec4<f32>,
    WorldN: vec3<f32>,
    Alpha_Dist_UV: vec4<f32>,
    Blend_Alpha_Dist_UV: vec4<f32>,
    Blend_FBNextIndex_UV: vec4<f32>,
    PosP: vec4<f32>,
}

struct VS_ConstantBuffer {
    mCamera: mat4x4<f32>,
    mCameraProj: mat4x4<f32>,
    mUVInversed: vec4<f32>,
    flipbookParameter1_: vec4<f32>,
    flipbookParameter2_: vec4<f32>,
}

struct gl_PerVertex {
    @builtin(position) gl_Position: vec4<f32>,
    gl_PointSize: f32,
    gl_ClipDistance: array<f32, 1>,
}

struct VertexOutput {
    @builtin(position) gl_Position: vec4<f32>,
    @location(0) member: vec4<f32>,
    @location(1) member_1: vec4<f32>,
    @location(2) member_2: vec3<f32>,
    @location(3) member_3: vec4<f32>,
    @location(4) member_4: vec4<f32>,
    @location(5) member_5: vec4<f32>,
    @location(6) member_6: vec4<f32>,
}

@group(0) @binding(0) 
var<uniform> _263_: VS_ConstantBuffer;
var<private> Input_Pos_1: vec3<f32>;
var<private> Input_Color_1: vec4<f32>;
var<private> Input_UV_1: vec2<f32>;
var<private> Input_Alpha_Dist_UV_1: vec4<f32>;
var<private> Input_BlendUV_1: vec2<f32>;
var<private> Input_Blend_Alpha_Dist_UV_1: vec4<f32>;
var<private> Input_FlipbookIndex_1: f32;
var<private> Input_AlphaThreshold_1: f32;
var<private> unnamed: gl_PerVertex = gl_PerVertex(vec4<f32>(0f, 0f, 0f, 1f), 1f, array<f32, 1>());
var<private> _entryPointOutput_Color: vec4<f32>;
var<private> _entryPointOutput_UV_Others: vec4<f32>;
var<private> _entryPointOutput_WorldN: vec3<f32>;
var<private> _entryPointOutput_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_FBNextIndex_UV: vec4<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;

fn GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(OriginUV: ptr<function, vec2<f32>>, Index: ptr<function, f32>, DivideX: ptr<function, f32>, flipbookOneSize: ptr<function, vec2<f32>>, flipbookOffset: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex: vec2<f32>;

    let _e42 = (*Index);
    let _e43 = i32(_e42);
    let _e44 = (*DivideX);
    let _e45 = i32(_e44);
    DivideIndex[0u] = f32((_e43 - (i32(floor((f32(_e43) / f32(_e45)))) * _e45)));
    let _e55 = (*Index);
    let _e57 = (*DivideX);
    DivideIndex[1u] = f32((i32(_e55) / i32(_e57)));
    let _e62 = (*OriginUV);
    let _e63 = DivideIndex;
    let _e64 = (*flipbookOneSize);
    let _e67 = (*flipbookOffset);
    return ((_e62 + (_e63 * _e64)) + _e67);
}

fn GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(FlipbookUV: ptr<function, vec2<f32>>, FlipbookIndex: ptr<function, f32>, DivideX_1: ptr<function, f32>, flipbookOneSize_1: ptr<function, vec2<f32>>, flipbookOffset_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex_1: vec2<f32>;
    var UVOffset: vec2<f32>;

    let _e43 = (*FlipbookIndex);
    let _e44 = i32(_e43);
    let _e45 = (*DivideX_1);
    let _e46 = i32(_e45);
    DivideIndex_1[0u] = f32((_e44 - (i32(floor((f32(_e44) / f32(_e46)))) * _e46)));
    let _e56 = (*FlipbookIndex);
    let _e58 = (*DivideX_1);
    DivideIndex_1[1u] = f32((i32(_e56) / i32(_e58)));
    let _e63 = DivideIndex_1;
    let _e64 = (*flipbookOneSize_1);
    let _e66 = (*flipbookOffset_1);
    UVOffset = ((_e63 * _e64) + _e66);
    let _e68 = (*FlipbookUV);
    let _e69 = UVOffset;
    return (_e68 - _e69);
}

fn ApplyFlipbookVS_u0028_f1_u003b_vf2_u003b_vf4_u003b_vf4_u003b_f1_u003b_vf2_u003b_vf2_u003b(flipbookRate: ptr<function, f32>, flipbookUV: ptr<function, vec2<f32>>, flipbookParameter1_: ptr<function, vec4<f32>>, flipbookParameter2_: ptr<function, vec4<f32>>, flipbookIndex: ptr<function, f32>, uv: ptr<function, vec2<f32>>, uvInversed: ptr<function, vec2<f32>>) {
    var flipbookEnabled: f32;
    var flipbookLoopType: f32;
    var divideX: f32;
    var divideY: f32;
    var flipbookOneSize_2: vec2<f32>;
    var flipbookOffset_2: vec2<f32>;
    var Index_1: f32;
    var IndexOffset: f32;
    var NextIndex: f32;
    var FlipbookMaxCount: f32;
    var Reverse: bool;
    var notInversedUV: vec2<f32>;
    var param: vec2<f32>;
    var param_1_: f32;
    var param_2_: f32;
    var param_3_: vec2<f32>;
    var param_4_: vec2<f32>;
    var OriginUV_1: vec2<f32>;
    var param_1: vec2<f32>;
    var param_2: f32;
    var param_3: f32;
    var param_4: vec2<f32>;
    var param_5: vec2<f32>;
    var param_5_: vec2<f32>;
    var param_6_: f32;
    var param_7_: f32;
    var param_8_: vec2<f32>;
    var param_9_: vec2<f32>;
    var param_6: vec2<f32>;
    var param_7: f32;
    var param_8: f32;
    var param_9: vec2<f32>;
    var param_10: vec2<f32>;

    let _e77 = (*flipbookParameter1_)[0u];
    flipbookEnabled = _e77;
    let _e79 = (*flipbookParameter1_)[1u];
    flipbookLoopType = _e79;
    let _e81 = (*flipbookParameter1_)[2u];
    divideX = _e81;
    let _e83 = (*flipbookParameter1_)[3u];
    divideY = _e83;
    let _e84 = (*flipbookParameter2_);
    flipbookOneSize_2 = _e84.xy;
    let _e86 = (*flipbookParameter2_);
    flipbookOffset_2 = _e86.zw;
    let _e88 = flipbookEnabled;
    if (_e88 > 0f) {
        let _e90 = (*flipbookIndex);
        (*flipbookRate) = fract(_e90);
        let _e92 = (*flipbookIndex);
        Index_1 = floor(_e92);
        IndexOffset = 1f;
        let _e94 = Index_1;
        let _e95 = IndexOffset;
        NextIndex = (_e94 + _e95);
        let _e97 = divideX;
        let _e98 = divideY;
        FlipbookMaxCount = (_e97 * _e98);
        let _e100 = flipbookLoopType;
        if (_e100 == 0f) {
            let _e102 = NextIndex;
            let _e103 = FlipbookMaxCount;
            if (_e102 >= _e103) {
                let _e105 = FlipbookMaxCount;
                NextIndex = (_e105 - 1f);
                let _e107 = FlipbookMaxCount;
                Index_1 = (_e107 - 1f);
            }
        } else {
            let _e109 = flipbookLoopType;
            if (_e109 == 1f) {
                let _e111 = Index_1;
                let _e112 = FlipbookMaxCount;
                Index_1 = (_e111 - (floor((_e111 / _e112)) * _e112));
                let _e117 = NextIndex;
                let _e118 = FlipbookMaxCount;
                NextIndex = (_e117 - (floor((_e117 / _e118)) * _e118));
            } else {
                let _e123 = flipbookLoopType;
                if (_e123 == 2f) {
                    let _e125 = Index_1;
                    let _e126 = FlipbookMaxCount;
                    let _e128 = floor((_e125 / _e126));
                    Reverse = ((_e128 - (floor((_e128 / 2f)) * 2f)) == 1f);
                    let _e134 = Index_1;
                    let _e135 = FlipbookMaxCount;
                    Index_1 = (_e134 - (floor((_e134 / _e135)) * _e135));
                    let _e140 = Reverse;
                    if _e140 {
                        let _e141 = FlipbookMaxCount;
                        let _e143 = Index_1;
                        Index_1 = ((_e141 - 1f) - floor(_e143));
                    }
                    let _e146 = NextIndex;
                    let _e147 = FlipbookMaxCount;
                    let _e149 = floor((_e146 / _e147));
                    Reverse = ((_e149 - (floor((_e149 / 2f)) * 2f)) == 1f);
                    let _e155 = NextIndex;
                    let _e156 = FlipbookMaxCount;
                    NextIndex = (_e155 - (floor((_e155 / _e156)) * _e156));
                    let _e161 = Reverse;
                    if _e161 {
                        let _e162 = FlipbookMaxCount;
                        let _e164 = NextIndex;
                        NextIndex = ((_e162 - 1f) - floor(_e164));
                    }
                }
            }
        }
        let _e167 = (*uv);
        notInversedUV = _e167;
        let _e169 = (*uvInversed)[0u];
        let _e171 = (*uvInversed)[1u];
        let _e173 = notInversedUV[1u];
        notInversedUV[1u] = (_e169 + (_e171 * _e173));
        let _e177 = notInversedUV;
        param = _e177;
        let _e178 = Index_1;
        param_1_ = _e178;
        let _e179 = divideX;
        param_2_ = _e179;
        let _e180 = flipbookOneSize_2;
        param_3_ = _e180;
        let _e181 = flipbookOffset_2;
        param_4_ = _e181;
        let _e182 = param;
        param_1 = _e182;
        let _e183 = param_1_;
        param_2 = _e183;
        let _e184 = param_2_;
        param_3 = _e184;
        let _e185 = param_3_;
        param_4 = _e185;
        let _e186 = param_4_;
        param_5 = _e186;
        let _e187 = GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_1), (&param_2), (&param_3), (&param_4), (&param_5));
        OriginUV_1 = _e187;
        let _e188 = OriginUV_1;
        param_5_ = _e188;
        let _e189 = NextIndex;
        param_6_ = _e189;
        let _e190 = divideX;
        param_7_ = _e190;
        let _e191 = flipbookOneSize_2;
        param_8_ = _e191;
        let _e192 = flipbookOffset_2;
        param_9_ = _e192;
        let _e193 = param_5_;
        param_6 = _e193;
        let _e194 = param_6_;
        param_7 = _e194;
        let _e195 = param_7_;
        param_8 = _e195;
        let _e196 = param_8_;
        param_9 = _e196;
        let _e197 = param_9_;
        param_10 = _e197;
        let _e198 = GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_6), (&param_7), (&param_8), (&param_9), (&param_10));
        (*flipbookUV) = _e198;
        let _e200 = (*uvInversed)[0u];
        let _e202 = (*uvInversed)[1u];
        let _e204 = (*flipbookUV)[1u];
        (*flipbookUV)[1u] = (_e200 + (_e202 * _e204));
    }
    return;
}

fn CalculateAndStoreAdvancedParameter_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b(vsinput: ptr<function, VS_Input>, vsoutput: ptr<function, VS_Output>) {
    var flipbookRate_1: f32;
    var flipbookNextIndexUV: vec2<f32>;
    var param_11: f32;
    var param_1_1: vec2<f32>;
    var param_2_1: vec4<f32>;
    var param_3_1: vec4<f32>;
    var param_4_1: f32;
    var param_5_1: vec2<f32>;
    var param_6_1: vec2<f32>;
    var param_12: f32;
    var param_13: vec2<f32>;
    var param_14: vec4<f32>;
    var param_15: vec4<f32>;
    var param_16: f32;
    var param_17: vec2<f32>;
    var param_18: vec2<f32>;

    let _e55 = (*vsinput).Alpha_Dist_UV;
    (*vsoutput).Alpha_Dist_UV = _e55;
    let _e59 = _263_.mUVInversed[0u];
    let _e62 = _263_.mUVInversed[1u];
    let _e65 = (*vsinput).Alpha_Dist_UV[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = (_e59 + (_e62 * _e65));
    let _e72 = _263_.mUVInversed[0u];
    let _e75 = _263_.mUVInversed[1u];
    let _e78 = (*vsinput).Alpha_Dist_UV[3u];
    (*vsoutput).Alpha_Dist_UV[3u] = (_e72 + (_e75 * _e78));
    let _e85 = (*vsinput).BlendUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[0u] = _e85;
    let _e90 = (*vsinput).BlendUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = _e90;
    let _e95 = _263_.mUVInversed[0u];
    let _e98 = _263_.mUVInversed[1u];
    let _e101 = (*vsinput).BlendUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = (_e95 + (_e98 * _e101));
    let _e107 = (*vsinput).Blend_Alpha_Dist_UV;
    (*vsoutput).Blend_Alpha_Dist_UV = _e107;
    let _e111 = _263_.mUVInversed[0u];
    let _e114 = _263_.mUVInversed[1u];
    let _e117 = (*vsinput).Blend_Alpha_Dist_UV[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = (_e111 + (_e114 * _e117));
    let _e124 = _263_.mUVInversed[0u];
    let _e127 = _263_.mUVInversed[1u];
    let _e130 = (*vsinput).Blend_Alpha_Dist_UV[3u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = (_e124 + (_e127 * _e130));
    flipbookRate_1 = 0f;
    flipbookNextIndexUV = vec2<f32>(0f, 0f);
    let _e135 = flipbookRate_1;
    param_11 = _e135;
    let _e136 = flipbookNextIndexUV;
    param_1_1 = _e136;
    let _e138 = _263_.flipbookParameter1_;
    param_2_1 = _e138;
    let _e140 = _263_.flipbookParameter2_;
    param_3_1 = _e140;
    let _e142 = (*vsinput).FlipbookIndex;
    param_4_1 = _e142;
    let _e144 = (*vsoutput).UV_Others;
    param_5_1 = _e144.xy;
    let _e147 = _263_.mUVInversed;
    let _e148 = _e147.xy;
    param_6_1 = vec2<f32>(_e148.x, _e148.y);
    let _e152 = param_11;
    param_12 = _e152;
    let _e153 = param_1_1;
    param_13 = _e153;
    let _e154 = param_2_1;
    param_14 = _e154;
    let _e155 = param_3_1;
    param_15 = _e155;
    let _e156 = param_4_1;
    param_16 = _e156;
    let _e157 = param_5_1;
    param_17 = _e157;
    let _e158 = param_6_1;
    param_18 = _e158;
    ApplyFlipbookVS_u0028_f1_u003b_vf2_u003b_vf4_u003b_vf4_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_12), (&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    let _e159 = param_12;
    param_11 = _e159;
    let _e160 = param_13;
    param_1_1 = _e160;
    let _e161 = param_11;
    flipbookRate_1 = _e161;
    let _e162 = param_1_1;
    flipbookNextIndexUV = _e162;
    let _e164 = flipbookNextIndexUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[2u] = _e164;
    let _e168 = flipbookNextIndexUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[3u] = _e168;
    let _e171 = flipbookRate_1;
    (*vsoutput).UV_Others[2u] = _e171;
    let _e175 = (*vsinput).AlphaThreshold;
    (*vsoutput).UV_Others[3u] = _e175;
    return;
}

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var Output: VS_Output;
    var uv1_: vec2<f32>;
    var worldPos: vec4<f32>;
    var param_19: VS_Input;
    var param_1_2: VS_Output;
    var param_20: VS_Input;
    var param_21: VS_Output;

    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e45 = (*Input).UV;
    uv1_ = _e45;
    let _e48 = _263_.mUVInversed[0u];
    let _e51 = _263_.mUVInversed[1u];
    let _e53 = uv1_[1u];
    uv1_[1u] = (_e48 + (_e51 * _e53));
    let _e58 = uv1_[0u];
    Output.UV_Others[0u] = _e58;
    let _e62 = uv1_[1u];
    Output.UV_Others[1u] = _e62;
    let _e67 = (*Input).Pos[0u];
    let _e70 = (*Input).Pos[1u];
    let _e73 = (*Input).Pos[2u];
    worldPos = vec4<f32>(_e67, _e70, _e73, 1f);
    let _e75 = worldPos;
    let _e77 = _263_.mCameraProj;
    Output.PosVS = (_e75 * transpose(_e77));
    let _e82 = (*Input).Color;
    Output.Color = _e82;
    let _e84 = (*Input);
    param_19 = _e84;
    let _e85 = Output;
    param_1_2 = _e85;
    let _e86 = param_19;
    param_20 = _e86;
    let _e87 = param_1_2;
    param_21 = _e87;
    CalculateAndStoreAdvancedParameter_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b((&param_20), (&param_21));
    let _e88 = param_21;
    param_1_2 = _e88;
    let _e89 = param_1_2;
    Output = _e89;
    let _e91 = Output.PosVS;
    Output.PosP = _e91;
    let _e93 = Output;
    return _e93;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param_22: VS_Input;
    var _position: vec4<f32>;

    let _e40 = Input_Pos_1;
    Input_1.Pos = _e40;
    let _e42 = Input_Color_1;
    Input_1.Color = _e42;
    let _e44 = Input_UV_1;
    Input_1.UV = _e44;
    let _e46 = Input_Alpha_Dist_UV_1;
    Input_1.Alpha_Dist_UV = _e46;
    let _e48 = Input_BlendUV_1;
    Input_1.BlendUV = _e48;
    let _e50 = Input_Blend_Alpha_Dist_UV_1;
    Input_1.Blend_Alpha_Dist_UV = _e50;
    let _e52 = Input_FlipbookIndex_1;
    Input_1.FlipbookIndex = _e52;
    let _e54 = Input_AlphaThreshold_1;
    Input_1.AlphaThreshold = _e54;
    let _e56 = Input_1;
    param_22 = _e56;
    let _e57 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b((&param_22));
    flattenTemp = _e57;
    let _e59 = flattenTemp.PosVS;
    _position = _e59;
    let _e61 = _position[1u];
    _position[1u] = -(_e61);
    let _e64 = _position;
    unnamed.gl_Position = _e64;
    let _e67 = flattenTemp.Color;
    _entryPointOutput_Color = _e67;
    let _e69 = flattenTemp.UV_Others;
    _entryPointOutput_UV_Others = _e69;
    let _e71 = flattenTemp.WorldN;
    _entryPointOutput_WorldN = _e71;
    let _e73 = flattenTemp.Alpha_Dist_UV;
    _entryPointOutput_Alpha_Dist_UV = _e73;
    let _e75 = flattenTemp.Blend_Alpha_Dist_UV;
    _entryPointOutput_Blend_Alpha_Dist_UV = _e75;
    let _e77 = flattenTemp.Blend_FBNextIndex_UV;
    _entryPointOutput_Blend_FBNextIndex_UV = _e77;
    let _e79 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e79;
    return;
}

@vertex 
fn main(@location(0) Input_Pos: vec3<f32>, @location(1) Input_Color: vec4<f32>, @location(2) Input_UV: vec2<f32>, @location(3) Input_Alpha_Dist_UV: vec4<f32>, @location(4) Input_BlendUV: vec2<f32>, @location(5) Input_Blend_Alpha_Dist_UV: vec4<f32>, @location(6) Input_FlipbookIndex: f32, @location(7) Input_AlphaThreshold: f32) -> VertexOutput {
    Input_Pos_1 = Input_Pos;
    Input_Color_1 = Input_Color;
    Input_UV_1 = Input_UV;
    Input_Alpha_Dist_UV_1 = Input_Alpha_Dist_UV;
    Input_BlendUV_1 = Input_BlendUV;
    Input_Blend_Alpha_Dist_UV_1 = Input_Blend_Alpha_Dist_UV;
    Input_FlipbookIndex_1 = Input_FlipbookIndex;
    Input_AlphaThreshold_1 = Input_AlphaThreshold;
    main_1();
    let _e26 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e26);
    let _e28 = unnamed.gl_Position;
    let _e29 = _entryPointOutput_Color;
    let _e30 = _entryPointOutput_UV_Others;
    let _e31 = _entryPointOutput_WorldN;
    let _e32 = _entryPointOutput_Alpha_Dist_UV;
    let _e33 = _entryPointOutput_Blend_Alpha_Dist_UV;
    let _e34 = _entryPointOutput_Blend_FBNextIndex_UV;
    let _e35 = _entryPointOutput_PosP;
    return VertexOutput(_e28, _e29, _e30, _e31, _e32, _e33, _e34, _e35);
}
