struct VS_Input {
    Pos: vec3<f32>,
    Color: vec4<f32>,
    Normal: vec4<f32>,
    Tangent: vec4<f32>,
    UV1_: vec2<f32>,
    UV2_: vec2<f32>,
    Alpha_Dist_UV: vec4<f32>,
    BlendUV: vec2<f32>,
    Blend_Alpha_Dist_UV: vec4<f32>,
    FlipbookIndex: f32,
    AlphaThreshold: f32,
}

struct VS_Output {
    PosVS: vec4<f32>,
    UV_Others: vec4<f32>,
    ProjBinormal: vec4<f32>,
    ProjTangent: vec4<f32>,
    PosP: vec4<f32>,
    Color: vec4<f32>,
    Alpha_Dist_UV: vec4<f32>,
    Blend_Alpha_Dist_UV: vec4<f32>,
    Blend_FBNextIndex_UV: vec4<f32>,
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
    @location(2) member_2: vec4<f32>,
    @location(3) member_3: vec4<f32>,
    @location(4) member_4: vec4<f32>,
    @location(5) member_5: vec4<f32>,
    @location(6) member_6: vec4<f32>,
    @location(7) member_7: vec4<f32>,
}

@group(0) @binding(0) 
var<uniform> _262_: VS_ConstantBuffer;
var<private> Input_Pos_1: vec3<f32>;
var<private> Input_Color_1: vec4<f32>;
var<private> Input_Normal_1: vec4<f32>;
var<private> Input_Tangent_1: vec4<f32>;
var<private> Input_UV1_1: vec2<f32>;
var<private> Input_UV2_1: vec2<f32>;
var<private> Input_Alpha_Dist_UV_1: vec4<f32>;
var<private> Input_BlendUV_1: vec2<f32>;
var<private> Input_Blend_Alpha_Dist_UV_1: vec4<f32>;
var<private> Input_FlipbookIndex_1: f32;
var<private> Input_AlphaThreshold_1: f32;
var<private> unnamed: gl_PerVertex = gl_PerVertex(vec4<f32>(0f, 0f, 0f, 1f), 1f, array<f32, 1>());
var<private> _entryPointOutput_UV_Others: vec4<f32>;
var<private> _entryPointOutput_ProjBinormal: vec4<f32>;
var<private> _entryPointOutput_ProjTangent: vec4<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;
var<private> _entryPointOutput_Color: vec4<f32>;
var<private> _entryPointOutput_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_FBNextIndex_UV: vec4<f32>;

fn GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(OriginUV: ptr<function, vec2<f32>>, Index: ptr<function, f32>, DivideX: ptr<function, f32>, flipbookOneSize: ptr<function, vec2<f32>>, flipbookOffset: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex: vec2<f32>;

    let _e50 = (*Index);
    let _e51 = i32(_e50);
    let _e52 = (*DivideX);
    let _e53 = i32(_e52);
    DivideIndex[0u] = f32((_e51 - (i32(floor((f32(_e51) / f32(_e53)))) * _e53)));
    let _e63 = (*Index);
    let _e65 = (*DivideX);
    DivideIndex[1u] = f32((i32(_e63) / i32(_e65)));
    let _e70 = (*OriginUV);
    let _e71 = DivideIndex;
    let _e72 = (*flipbookOneSize);
    let _e75 = (*flipbookOffset);
    return ((_e70 + (_e71 * _e72)) + _e75);
}

fn GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(FlipbookUV: ptr<function, vec2<f32>>, FlipbookIndex: ptr<function, f32>, DivideX_1: ptr<function, f32>, flipbookOneSize_1: ptr<function, vec2<f32>>, flipbookOffset_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex_1: vec2<f32>;
    var UVOffset: vec2<f32>;

    let _e51 = (*FlipbookIndex);
    let _e52 = i32(_e51);
    let _e53 = (*DivideX_1);
    let _e54 = i32(_e53);
    DivideIndex_1[0u] = f32((_e52 - (i32(floor((f32(_e52) / f32(_e54)))) * _e54)));
    let _e64 = (*FlipbookIndex);
    let _e66 = (*DivideX_1);
    DivideIndex_1[1u] = f32((i32(_e64) / i32(_e66)));
    let _e71 = DivideIndex_1;
    let _e72 = (*flipbookOneSize_1);
    let _e74 = (*flipbookOffset_1);
    UVOffset = ((_e71 * _e72) + _e74);
    let _e76 = (*FlipbookUV);
    let _e77 = UVOffset;
    return (_e76 - _e77);
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

    let _e85 = (*flipbookParameter1_)[0u];
    flipbookEnabled = _e85;
    let _e87 = (*flipbookParameter1_)[1u];
    flipbookLoopType = _e87;
    let _e89 = (*flipbookParameter1_)[2u];
    divideX = _e89;
    let _e91 = (*flipbookParameter1_)[3u];
    divideY = _e91;
    let _e92 = (*flipbookParameter2_);
    flipbookOneSize_2 = _e92.xy;
    let _e94 = (*flipbookParameter2_);
    flipbookOffset_2 = _e94.zw;
    let _e96 = flipbookEnabled;
    if (_e96 > 0f) {
        let _e98 = (*flipbookIndex);
        (*flipbookRate) = fract(_e98);
        let _e100 = (*flipbookIndex);
        Index_1 = floor(_e100);
        IndexOffset = 1f;
        let _e102 = Index_1;
        let _e103 = IndexOffset;
        NextIndex = (_e102 + _e103);
        let _e105 = divideX;
        let _e106 = divideY;
        FlipbookMaxCount = (_e105 * _e106);
        let _e108 = flipbookLoopType;
        if (_e108 == 0f) {
            let _e110 = NextIndex;
            let _e111 = FlipbookMaxCount;
            if (_e110 >= _e111) {
                let _e113 = FlipbookMaxCount;
                NextIndex = (_e113 - 1f);
                let _e115 = FlipbookMaxCount;
                Index_1 = (_e115 - 1f);
            }
        } else {
            let _e117 = flipbookLoopType;
            if (_e117 == 1f) {
                let _e119 = Index_1;
                let _e120 = FlipbookMaxCount;
                Index_1 = (_e119 - (floor((_e119 / _e120)) * _e120));
                let _e125 = NextIndex;
                let _e126 = FlipbookMaxCount;
                NextIndex = (_e125 - (floor((_e125 / _e126)) * _e126));
            } else {
                let _e131 = flipbookLoopType;
                if (_e131 == 2f) {
                    let _e133 = Index_1;
                    let _e134 = FlipbookMaxCount;
                    let _e136 = floor((_e133 / _e134));
                    Reverse = ((_e136 - (floor((_e136 / 2f)) * 2f)) == 1f);
                    let _e142 = Index_1;
                    let _e143 = FlipbookMaxCount;
                    Index_1 = (_e142 - (floor((_e142 / _e143)) * _e143));
                    let _e148 = Reverse;
                    if _e148 {
                        let _e149 = FlipbookMaxCount;
                        let _e151 = Index_1;
                        Index_1 = ((_e149 - 1f) - floor(_e151));
                    }
                    let _e154 = NextIndex;
                    let _e155 = FlipbookMaxCount;
                    let _e157 = floor((_e154 / _e155));
                    Reverse = ((_e157 - (floor((_e157 / 2f)) * 2f)) == 1f);
                    let _e163 = NextIndex;
                    let _e164 = FlipbookMaxCount;
                    NextIndex = (_e163 - (floor((_e163 / _e164)) * _e164));
                    let _e169 = Reverse;
                    if _e169 {
                        let _e170 = FlipbookMaxCount;
                        let _e172 = NextIndex;
                        NextIndex = ((_e170 - 1f) - floor(_e172));
                    }
                }
            }
        }
        let _e175 = (*uv);
        notInversedUV = _e175;
        let _e177 = (*uvInversed)[0u];
        let _e179 = (*uvInversed)[1u];
        let _e181 = notInversedUV[1u];
        notInversedUV[1u] = (_e177 + (_e179 * _e181));
        let _e185 = notInversedUV;
        param = _e185;
        let _e186 = Index_1;
        param_1_ = _e186;
        let _e187 = divideX;
        param_2_ = _e187;
        let _e188 = flipbookOneSize_2;
        param_3_ = _e188;
        let _e189 = flipbookOffset_2;
        param_4_ = _e189;
        let _e190 = param;
        param_1 = _e190;
        let _e191 = param_1_;
        param_2 = _e191;
        let _e192 = param_2_;
        param_3 = _e192;
        let _e193 = param_3_;
        param_4 = _e193;
        let _e194 = param_4_;
        param_5 = _e194;
        let _e195 = GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_1), (&param_2), (&param_3), (&param_4), (&param_5));
        OriginUV_1 = _e195;
        let _e196 = OriginUV_1;
        param_5_ = _e196;
        let _e197 = NextIndex;
        param_6_ = _e197;
        let _e198 = divideX;
        param_7_ = _e198;
        let _e199 = flipbookOneSize_2;
        param_8_ = _e199;
        let _e200 = flipbookOffset_2;
        param_9_ = _e200;
        let _e201 = param_5_;
        param_6 = _e201;
        let _e202 = param_6_;
        param_7 = _e202;
        let _e203 = param_7_;
        param_8 = _e203;
        let _e204 = param_8_;
        param_9 = _e204;
        let _e205 = param_9_;
        param_10 = _e205;
        let _e206 = GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_6), (&param_7), (&param_8), (&param_9), (&param_10));
        (*flipbookUV) = _e206;
        let _e208 = (*uvInversed)[0u];
        let _e210 = (*uvInversed)[1u];
        let _e212 = (*flipbookUV)[1u];
        (*flipbookUV)[1u] = (_e208 + (_e210 * _e212));
    }
    return;
}

fn CalculateAndStoreAdvancedParameter_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b(vsinput: ptr<function, VS_Input>, vsoutput: ptr<function, VS_Output>) {
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

    let _e63 = (*vsinput).Alpha_Dist_UV;
    (*vsoutput).Alpha_Dist_UV = _e63;
    let _e67 = _262_.mUVInversed[0u];
    let _e70 = _262_.mUVInversed[1u];
    let _e73 = (*vsinput).Alpha_Dist_UV[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = (_e67 + (_e70 * _e73));
    let _e80 = _262_.mUVInversed[0u];
    let _e83 = _262_.mUVInversed[1u];
    let _e86 = (*vsinput).Alpha_Dist_UV[3u];
    (*vsoutput).Alpha_Dist_UV[3u] = (_e80 + (_e83 * _e86));
    let _e93 = (*vsinput).BlendUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[0u] = _e93;
    let _e98 = (*vsinput).BlendUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = _e98;
    let _e103 = _262_.mUVInversed[0u];
    let _e106 = _262_.mUVInversed[1u];
    let _e109 = (*vsinput).BlendUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = (_e103 + (_e106 * _e109));
    let _e115 = (*vsinput).Blend_Alpha_Dist_UV;
    (*vsoutput).Blend_Alpha_Dist_UV = _e115;
    let _e119 = _262_.mUVInversed[0u];
    let _e122 = _262_.mUVInversed[1u];
    let _e125 = (*vsinput).Blend_Alpha_Dist_UV[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = (_e119 + (_e122 * _e125));
    let _e132 = _262_.mUVInversed[0u];
    let _e135 = _262_.mUVInversed[1u];
    let _e138 = (*vsinput).Blend_Alpha_Dist_UV[3u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = (_e132 + (_e135 * _e138));
    flipbookRate_1 = 0f;
    flipbookNextIndexUV = vec2<f32>(0f, 0f);
    let _e143 = flipbookRate_1;
    param_11 = _e143;
    let _e144 = flipbookNextIndexUV;
    param_1_1 = _e144;
    let _e146 = _262_.flipbookParameter1_;
    param_2_1 = _e146;
    let _e148 = _262_.flipbookParameter2_;
    param_3_1 = _e148;
    let _e150 = (*vsinput).FlipbookIndex;
    param_4_1 = _e150;
    let _e152 = (*vsoutput).UV_Others;
    param_5_1 = _e152.xy;
    let _e155 = _262_.mUVInversed;
    let _e156 = _e155.xy;
    param_6_1 = vec2<f32>(_e156.x, _e156.y);
    let _e160 = param_11;
    param_12 = _e160;
    let _e161 = param_1_1;
    param_13 = _e161;
    let _e162 = param_2_1;
    param_14 = _e162;
    let _e163 = param_3_1;
    param_15 = _e163;
    let _e164 = param_4_1;
    param_16 = _e164;
    let _e165 = param_5_1;
    param_17 = _e165;
    let _e166 = param_6_1;
    param_18 = _e166;
    ApplyFlipbookVS_u0028_f1_u003b_vf2_u003b_vf4_u003b_vf4_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_12), (&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    let _e167 = param_12;
    param_11 = _e167;
    let _e168 = param_13;
    param_1_1 = _e168;
    let _e169 = param_11;
    flipbookRate_1 = _e169;
    let _e170 = param_1_1;
    flipbookNextIndexUV = _e170;
    let _e172 = flipbookNextIndexUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[2u] = _e172;
    let _e176 = flipbookNextIndexUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[3u] = _e176;
    let _e179 = flipbookRate_1;
    (*vsoutput).UV_Others[2u] = _e179;
    let _e183 = (*vsinput).AlphaThreshold;
    (*vsoutput).UV_Others[3u] = _e183;
    return;
}

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var Output: VS_Output;
    var worldNormal: vec4<f32>;
    var worldTangent: vec4<f32>;
    var worldBinormal: vec4<f32>;
    var uv1_: vec2<f32>;
    var worldPos: vec4<f32>;
    var param_19: VS_Input;
    var param_1_2: VS_Output;
    var param_20: VS_Input;
    var param_21: VS_Output;

    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e56 = (*Input).Normal;
    let _e59 = ((_e56.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldNormal = vec4<f32>(_e59.x, _e59.y, _e59.z, 0f);
    let _e65 = (*Input).Tangent;
    let _e68 = ((_e65.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldTangent = vec4<f32>(_e68.x, _e68.y, _e68.z, 0f);
    let _e73 = worldNormal;
    let _e75 = worldTangent;
    let _e77 = cross(_e73.xyz, _e75.xyz);
    worldBinormal = vec4<f32>(_e77.x, _e77.y, _e77.z, 0f);
    let _e83 = (*Input).UV1_;
    uv1_ = _e83;
    let _e86 = _262_.mUVInversed[0u];
    let _e89 = _262_.mUVInversed[1u];
    let _e91 = uv1_[1u];
    uv1_[1u] = (_e86 + (_e89 * _e91));
    let _e96 = uv1_[0u];
    Output.UV_Others[0u] = _e96;
    let _e100 = uv1_[1u];
    Output.UV_Others[1u] = _e100;
    let _e105 = (*Input).Pos[0u];
    let _e108 = (*Input).Pos[1u];
    let _e111 = (*Input).Pos[2u];
    worldPos = vec4<f32>(_e105, _e108, _e111, 1f);
    let _e113 = worldPos;
    let _e115 = _262_.mCameraProj;
    Output.PosVS = (_e113 * transpose(_e115));
    let _e119 = worldPos;
    let _e120 = worldTangent;
    let _e123 = _262_.mCameraProj;
    Output.ProjTangent = ((_e119 + _e120) * transpose(_e123));
    let _e127 = worldPos;
    let _e128 = worldBinormal;
    let _e131 = _262_.mCameraProj;
    Output.ProjBinormal = ((_e127 + _e128) * transpose(_e131));
    let _e136 = (*Input).Color;
    Output.Color = _e136;
    let _e138 = (*Input);
    param_19 = _e138;
    let _e139 = Output;
    param_1_2 = _e139;
    let _e140 = param_19;
    param_20 = _e140;
    let _e141 = param_1_2;
    param_21 = _e141;
    CalculateAndStoreAdvancedParameter_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b((&param_20), (&param_21));
    let _e142 = param_21;
    param_1_2 = _e142;
    let _e143 = param_1_2;
    Output = _e143;
    let _e145 = Output.PosVS;
    Output.PosP = _e145;
    let _e147 = Output;
    return _e147;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param_22: VS_Input;
    var _position: vec4<f32>;

    let _e48 = Input_Pos_1;
    Input_1.Pos = _e48;
    let _e50 = Input_Color_1;
    Input_1.Color = _e50;
    let _e52 = Input_Normal_1;
    Input_1.Normal = _e52;
    let _e54 = Input_Tangent_1;
    Input_1.Tangent = _e54;
    let _e56 = Input_UV1_1;
    Input_1.UV1_ = _e56;
    let _e58 = Input_UV2_1;
    Input_1.UV2_ = _e58;
    let _e60 = Input_Alpha_Dist_UV_1;
    Input_1.Alpha_Dist_UV = _e60;
    let _e62 = Input_BlendUV_1;
    Input_1.BlendUV = _e62;
    let _e64 = Input_Blend_Alpha_Dist_UV_1;
    Input_1.Blend_Alpha_Dist_UV = _e64;
    let _e66 = Input_FlipbookIndex_1;
    Input_1.FlipbookIndex = _e66;
    let _e68 = Input_AlphaThreshold_1;
    Input_1.AlphaThreshold = _e68;
    let _e70 = Input_1;
    param_22 = _e70;
    let _e71 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b((&param_22));
    flattenTemp = _e71;
    let _e73 = flattenTemp.PosVS;
    _position = _e73;
    let _e75 = _position[1u];
    _position[1u] = -(_e75);
    let _e78 = _position;
    unnamed.gl_Position = _e78;
    let _e81 = flattenTemp.UV_Others;
    _entryPointOutput_UV_Others = _e81;
    let _e83 = flattenTemp.ProjBinormal;
    _entryPointOutput_ProjBinormal = _e83;
    let _e85 = flattenTemp.ProjTangent;
    _entryPointOutput_ProjTangent = _e85;
    let _e87 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e87;
    let _e89 = flattenTemp.Color;
    _entryPointOutput_Color = _e89;
    let _e91 = flattenTemp.Alpha_Dist_UV;
    _entryPointOutput_Alpha_Dist_UV = _e91;
    let _e93 = flattenTemp.Blend_Alpha_Dist_UV;
    _entryPointOutput_Blend_Alpha_Dist_UV = _e93;
    let _e95 = flattenTemp.Blend_FBNextIndex_UV;
    _entryPointOutput_Blend_FBNextIndex_UV = _e95;
    return;
}

@vertex 
fn main(@location(0) Input_Pos: vec3<f32>, @location(1) Input_Color: vec4<f32>, @location(2) Input_Normal: vec4<f32>, @location(3) Input_Tangent: vec4<f32>, @location(4) Input_UV1_: vec2<f32>, @location(5) Input_UV2_: vec2<f32>, @location(6) Input_Alpha_Dist_UV: vec4<f32>, @location(7) Input_BlendUV: vec2<f32>, @location(8) Input_Blend_Alpha_Dist_UV: vec4<f32>, @location(9) Input_FlipbookIndex: f32, @location(10) Input_AlphaThreshold: f32) -> VertexOutput {
    Input_Pos_1 = Input_Pos;
    Input_Color_1 = Input_Color;
    Input_Normal_1 = Input_Normal;
    Input_Tangent_1 = Input_Tangent;
    Input_UV1_1 = Input_UV1_;
    Input_UV2_1 = Input_UV2_;
    Input_Alpha_Dist_UV_1 = Input_Alpha_Dist_UV;
    Input_BlendUV_1 = Input_BlendUV;
    Input_Blend_Alpha_Dist_UV_1 = Input_Blend_Alpha_Dist_UV;
    Input_FlipbookIndex_1 = Input_FlipbookIndex;
    Input_AlphaThreshold_1 = Input_AlphaThreshold;
    main_1();
    let _e33 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e33);
    let _e35 = unnamed.gl_Position;
    let _e36 = _entryPointOutput_UV_Others;
    let _e37 = _entryPointOutput_ProjBinormal;
    let _e38 = _entryPointOutput_ProjTangent;
    let _e39 = _entryPointOutput_PosP;
    let _e40 = _entryPointOutput_Color;
    let _e41 = _entryPointOutput_Alpha_Dist_UV;
    let _e42 = _entryPointOutput_Blend_Alpha_Dist_UV;
    let _e43 = _entryPointOutput_Blend_FBNextIndex_UV;
    return VertexOutput(_e35, _e36, _e37, _e38, _e39, _e40, _e41, _e42, _e43);
}
