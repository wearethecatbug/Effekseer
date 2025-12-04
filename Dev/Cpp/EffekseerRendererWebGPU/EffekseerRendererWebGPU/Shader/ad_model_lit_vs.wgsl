struct VS_Output {
    PosVS: vec4<f32>,
    Color: vec4<f32>,
    UV_Others: vec4<f32>,
    WorldN: vec3<f32>,
    WorldB: vec3<f32>,
    WorldT: vec3<f32>,
    Alpha_Dist_UV: vec4<f32>,
    Blend_Alpha_Dist_UV: vec4<f32>,
    Blend_FBNextIndex_UV: vec4<f32>,
    PosP: vec4<f32>,
}

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

struct VS_ConstantBuffer {
    mCameraProj: mat4x4<f32>,
    mModel_Inst: array<mat4x4<f32>, 40>,
    fUV: array<vec4<f32>, 40>,
    fAlphaUV: array<vec4<f32>, 40>,
    fUVDistortionUV: array<vec4<f32>, 40>,
    fBlendUV: array<vec4<f32>, 40>,
    fBlendAlphaUV: array<vec4<f32>, 40>,
    fBlendUVDistortionUV: array<vec4<f32>, 40>,
    flipbookParameter1_: vec4<f32>,
    flipbookParameter2_: vec4<f32>,
    fFlipbookIndexAndNextRate: array<vec4<f32>, 40>,
    fModelAlphaThreshold: array<vec4<f32>, 40>,
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
    @location(1) member_1: vec4<f32>,
    @location(2) member_2: vec3<f32>,
    @location(3) member_3: vec3<f32>,
    @location(4) member_4: vec3<f32>,
    @location(5) member_5: vec4<f32>,
    @location(6) member_6: vec4<f32>,
    @location(7) member_7: vec4<f32>,
    @location(8) member_8: vec4<f32>,
}

@group(0) @binding(0) 
var<uniform> _372_: VS_ConstantBuffer;
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
var<private> _entryPointOutput_UV_Others: vec4<f32>;
var<private> _entryPointOutput_WorldN: vec3<f32>;
var<private> _entryPointOutput_WorldB: vec3<f32>;
var<private> _entryPointOutput_WorldT: vec3<f32>;
var<private> _entryPointOutput_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_FBNextIndex_UV: vec4<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;

fn GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(OriginUV: ptr<function, vec2<f32>>, Index: ptr<function, f32>, DivideX: ptr<function, f32>, flipbookOneSize: ptr<function, vec2<f32>>, flipbookOffset: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex: vec2<f32>;

    let _e51 = (*Index);
    let _e52 = i32(_e51);
    let _e53 = (*DivideX);
    let _e54 = i32(_e53);
    DivideIndex[0u] = f32((_e52 - (i32(floor((f32(_e52) / f32(_e54)))) * _e54)));
    let _e64 = (*Index);
    let _e66 = (*DivideX);
    DivideIndex[1u] = f32((i32(_e64) / i32(_e66)));
    let _e71 = (*OriginUV);
    let _e72 = DivideIndex;
    let _e73 = (*flipbookOneSize);
    let _e76 = (*flipbookOffset);
    return ((_e71 + (_e72 * _e73)) + _e76);
}

fn GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(FlipbookUV: ptr<function, vec2<f32>>, FlipbookIndex: ptr<function, f32>, DivideX_1: ptr<function, f32>, flipbookOneSize_1: ptr<function, vec2<f32>>, flipbookOffset_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex_1: vec2<f32>;
    var UVOffset: vec2<f32>;

    let _e52 = (*FlipbookIndex);
    let _e53 = i32(_e52);
    let _e54 = (*DivideX_1);
    let _e55 = i32(_e54);
    DivideIndex_1[0u] = f32((_e53 - (i32(floor((f32(_e53) / f32(_e55)))) * _e55)));
    let _e65 = (*FlipbookIndex);
    let _e67 = (*DivideX_1);
    DivideIndex_1[1u] = f32((i32(_e65) / i32(_e67)));
    let _e72 = DivideIndex_1;
    let _e73 = (*flipbookOneSize_1);
    let _e75 = (*flipbookOffset_1);
    UVOffset = ((_e72 * _e73) + _e75);
    let _e77 = (*FlipbookUV);
    let _e78 = UVOffset;
    return (_e77 - _e78);
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

    let _e86 = (*flipbookParameter1_)[0u];
    flipbookEnabled = _e86;
    let _e88 = (*flipbookParameter1_)[1u];
    flipbookLoopType = _e88;
    let _e90 = (*flipbookParameter1_)[2u];
    divideX = _e90;
    let _e92 = (*flipbookParameter1_)[3u];
    divideY = _e92;
    let _e93 = (*flipbookParameter2_);
    flipbookOneSize_2 = _e93.xy;
    let _e95 = (*flipbookParameter2_);
    flipbookOffset_2 = _e95.zw;
    let _e97 = flipbookEnabled;
    if (_e97 > 0f) {
        let _e99 = (*flipbookIndex);
        (*flipbookRate) = fract(_e99);
        let _e101 = (*flipbookIndex);
        Index_1 = floor(_e101);
        IndexOffset = 1f;
        let _e103 = Index_1;
        let _e104 = IndexOffset;
        NextIndex = (_e103 + _e104);
        let _e106 = divideX;
        let _e107 = divideY;
        FlipbookMaxCount = (_e106 * _e107);
        let _e109 = flipbookLoopType;
        if (_e109 == 0f) {
            let _e111 = NextIndex;
            let _e112 = FlipbookMaxCount;
            if (_e111 >= _e112) {
                let _e114 = FlipbookMaxCount;
                NextIndex = (_e114 - 1f);
                let _e116 = FlipbookMaxCount;
                Index_1 = (_e116 - 1f);
            }
        } else {
            let _e118 = flipbookLoopType;
            if (_e118 == 1f) {
                let _e120 = Index_1;
                let _e121 = FlipbookMaxCount;
                Index_1 = (_e120 - (floor((_e120 / _e121)) * _e121));
                let _e126 = NextIndex;
                let _e127 = FlipbookMaxCount;
                NextIndex = (_e126 - (floor((_e126 / _e127)) * _e127));
            } else {
                let _e132 = flipbookLoopType;
                if (_e132 == 2f) {
                    let _e134 = Index_1;
                    let _e135 = FlipbookMaxCount;
                    let _e137 = floor((_e134 / _e135));
                    Reverse = ((_e137 - (floor((_e137 / 2f)) * 2f)) == 1f);
                    let _e143 = Index_1;
                    let _e144 = FlipbookMaxCount;
                    Index_1 = (_e143 - (floor((_e143 / _e144)) * _e144));
                    let _e149 = Reverse;
                    if _e149 {
                        let _e150 = FlipbookMaxCount;
                        let _e152 = Index_1;
                        Index_1 = ((_e150 - 1f) - floor(_e152));
                    }
                    let _e155 = NextIndex;
                    let _e156 = FlipbookMaxCount;
                    let _e158 = floor((_e155 / _e156));
                    Reverse = ((_e158 - (floor((_e158 / 2f)) * 2f)) == 1f);
                    let _e164 = NextIndex;
                    let _e165 = FlipbookMaxCount;
                    NextIndex = (_e164 - (floor((_e164 / _e165)) * _e165));
                    let _e170 = Reverse;
                    if _e170 {
                        let _e171 = FlipbookMaxCount;
                        let _e173 = NextIndex;
                        NextIndex = ((_e171 - 1f) - floor(_e173));
                    }
                }
            }
        }
        let _e176 = (*uv);
        notInversedUV = _e176;
        let _e178 = (*uvInversed)[0u];
        let _e180 = (*uvInversed)[1u];
        let _e182 = notInversedUV[1u];
        notInversedUV[1u] = (_e178 + (_e180 * _e182));
        let _e186 = notInversedUV;
        param = _e186;
        let _e187 = Index_1;
        param_1_ = _e187;
        let _e188 = divideX;
        param_2_ = _e188;
        let _e189 = flipbookOneSize_2;
        param_3_ = _e189;
        let _e190 = flipbookOffset_2;
        param_4_ = _e190;
        let _e191 = param;
        param_1 = _e191;
        let _e192 = param_1_;
        param_2 = _e192;
        let _e193 = param_2_;
        param_3 = _e193;
        let _e194 = param_3_;
        param_4 = _e194;
        let _e195 = param_4_;
        param_5 = _e195;
        let _e196 = GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_1), (&param_2), (&param_3), (&param_4), (&param_5));
        OriginUV_1 = _e196;
        let _e197 = OriginUV_1;
        param_5_ = _e197;
        let _e198 = NextIndex;
        param_6_ = _e198;
        let _e199 = divideX;
        param_7_ = _e199;
        let _e200 = flipbookOneSize_2;
        param_8_ = _e200;
        let _e201 = flipbookOffset_2;
        param_9_ = _e201;
        let _e202 = param_5_;
        param_6 = _e202;
        let _e203 = param_6_;
        param_7 = _e203;
        let _e204 = param_7_;
        param_8 = _e204;
        let _e205 = param_8_;
        param_9 = _e205;
        let _e206 = param_9_;
        param_10 = _e206;
        let _e207 = GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_6), (&param_7), (&param_8), (&param_9), (&param_10));
        (*flipbookUV) = _e207;
        let _e209 = (*uvInversed)[0u];
        let _e211 = (*uvInversed)[1u];
        let _e213 = (*flipbookUV)[1u];
        (*flipbookUV)[1u] = (_e209 + (_e211 * _e213));
    }
    return;
}

fn CalculateAndStoreAdvancedParameter_u0028_vf2_u003b_vf2_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_f1_u003b_f1_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b(uv_1: ptr<function, vec2<f32>>, uv1_: ptr<function, vec2<f32>>, alphaUV: ptr<function, vec4<f32>>, uvDistortionUV: ptr<function, vec4<f32>>, blendUV: ptr<function, vec4<f32>>, blendAlphaUV: ptr<function, vec4<f32>>, blendUVDistortionUV: ptr<function, vec4<f32>>, flipbookIndexAndNextRate: ptr<function, f32>, modelAlphaThreshold: ptr<function, f32>, vsoutput: ptr<function, VS_Output>) {
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

    let _e72 = (*uv_1)[0u];
    let _e74 = (*alphaUV)[2u];
    let _e77 = (*alphaUV)[0u];
    (*vsoutput).Alpha_Dist_UV[0u] = ((_e72 * _e74) + _e77);
    let _e82 = (*uv_1)[1u];
    let _e84 = (*alphaUV)[3u];
    let _e87 = (*alphaUV)[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = ((_e82 * _e84) + _e87);
    let _e92 = (*uv_1)[0u];
    let _e94 = (*uvDistortionUV)[2u];
    let _e97 = (*uvDistortionUV)[0u];
    (*vsoutput).Alpha_Dist_UV[2u] = ((_e92 * _e94) + _e97);
    let _e102 = (*uv_1)[1u];
    let _e104 = (*uvDistortionUV)[3u];
    let _e107 = (*uvDistortionUV)[1u];
    (*vsoutput).Alpha_Dist_UV[3u] = ((_e102 * _e104) + _e107);
    let _e112 = (*uv_1)[0u];
    let _e114 = (*blendUV)[2u];
    let _e117 = (*blendUV)[0u];
    (*vsoutput).Blend_FBNextIndex_UV[0u] = ((_e112 * _e114) + _e117);
    let _e122 = (*uv_1)[1u];
    let _e124 = (*blendUV)[3u];
    let _e127 = (*blendUV)[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = ((_e122 * _e124) + _e127);
    let _e132 = (*uv_1)[0u];
    let _e134 = (*blendAlphaUV)[2u];
    let _e137 = (*blendAlphaUV)[0u];
    (*vsoutput).Blend_Alpha_Dist_UV[0u] = ((_e132 * _e134) + _e137);
    let _e142 = (*uv_1)[1u];
    let _e144 = (*blendAlphaUV)[3u];
    let _e147 = (*blendAlphaUV)[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = ((_e142 * _e144) + _e147);
    let _e152 = (*uv_1)[0u];
    let _e154 = (*blendUVDistortionUV)[2u];
    let _e157 = (*blendUVDistortionUV)[0u];
    (*vsoutput).Blend_Alpha_Dist_UV[2u] = ((_e152 * _e154) + _e157);
    let _e162 = (*uv_1)[1u];
    let _e164 = (*blendUVDistortionUV)[3u];
    let _e167 = (*blendUVDistortionUV)[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = ((_e162 * _e164) + _e167);
    flipbookRate_1 = 0f;
    flipbookNextIndexUV = vec2<f32>(0f, 0f);
    let _e171 = flipbookRate_1;
    param_11 = _e171;
    let _e172 = flipbookNextIndexUV;
    param_1_1 = _e172;
    let _e174 = _372_.flipbookParameter1_;
    param_2_1 = _e174;
    let _e176 = _372_.flipbookParameter2_;
    param_3_1 = _e176;
    let _e177 = (*flipbookIndexAndNextRate);
    param_4_1 = _e177;
    let _e178 = (*uv1_);
    param_5_1 = _e178;
    let _e180 = _372_.mUVInversed;
    let _e181 = _e180.xy;
    param_6_1 = vec2<f32>(_e181.x, _e181.y);
    let _e185 = param_11;
    param_12 = _e185;
    let _e186 = param_1_1;
    param_13 = _e186;
    let _e187 = param_2_1;
    param_14 = _e187;
    let _e188 = param_3_1;
    param_15 = _e188;
    let _e189 = param_4_1;
    param_16 = _e189;
    let _e190 = param_5_1;
    param_17 = _e190;
    let _e191 = param_6_1;
    param_18 = _e191;
    ApplyFlipbookVS_u0028_f1_u003b_vf2_u003b_vf4_u003b_vf4_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_12), (&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    let _e192 = param_12;
    param_11 = _e192;
    let _e193 = param_13;
    param_1_1 = _e193;
    let _e194 = param_11;
    flipbookRate_1 = _e194;
    let _e195 = param_1_1;
    flipbookNextIndexUV = _e195;
    let _e197 = flipbookNextIndexUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[2u] = _e197;
    let _e201 = flipbookNextIndexUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[3u] = _e201;
    let _e204 = flipbookRate_1;
    (*vsoutput).UV_Others[2u] = _e204;
    let _e207 = (*modelAlphaThreshold);
    (*vsoutput).UV_Others[3u] = _e207;
    let _e212 = _372_.mUVInversed[0u];
    let _e215 = _372_.mUVInversed[1u];
    let _e218 = (*vsoutput).Alpha_Dist_UV[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = (_e212 + (_e215 * _e218));
    let _e225 = _372_.mUVInversed[0u];
    let _e228 = _372_.mUVInversed[1u];
    let _e231 = (*vsoutput).Alpha_Dist_UV[3u];
    (*vsoutput).Alpha_Dist_UV[3u] = (_e225 + (_e228 * _e231));
    let _e238 = _372_.mUVInversed[0u];
    let _e241 = _372_.mUVInversed[1u];
    let _e244 = (*vsoutput).Blend_FBNextIndex_UV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = (_e238 + (_e241 * _e244));
    let _e251 = _372_.mUVInversed[0u];
    let _e254 = _372_.mUVInversed[1u];
    let _e257 = (*vsoutput).Blend_Alpha_Dist_UV[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = (_e251 + (_e254 * _e257));
    let _e264 = _372_.mUVInversed[0u];
    let _e267 = _372_.mUVInversed[1u];
    let _e270 = (*vsoutput).Blend_Alpha_Dist_UV[3u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = (_e264 + (_e267 * _e270));
    return;
}

fn _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b(Input: ptr<function, VS_Input>) -> VS_Output {
    var index: u32;
    var mModel: mat4x4<f32>;
    var uv_2: vec4<f32>;
    var alphaUV_1: vec4<f32>;
    var uvDistortionUV_1: vec4<f32>;
    var blendUV_1: vec4<f32>;
    var blendAlphaUV_1: vec4<f32>;
    var blendUVDistortionUV_1: vec4<f32>;
    var modelColor: vec4<f32>;
    var flipbookIndexAndNextRate_1: f32;
    var modelAlphaThreshold_1: f32;
    var Output: VS_Output;
    var localPosition: vec4<f32>;
    var worldPos: vec4<f32>;
    var outputUV: vec2<f32>;
    var localNormal: vec4<f32>;
    var localBinormal: vec4<f32>;
    var localTangent: vec4<f32>;
    var worldNormal: vec4<f32>;
    var worldBinormal: vec4<f32>;
    var worldTangent: vec4<f32>;
    var param_19: vec2<f32>;
    var param_1_2: vec2<f32>;
    var param_2_2: vec4<f32>;
    var param_3_2: vec4<f32>;
    var param_4_2: vec4<f32>;
    var param_5_2: vec4<f32>;
    var param_6_2: vec4<f32>;
    var param_7_1: f32;
    var param_8_1: f32;
    var param_9_1: VS_Output;
    var param_20: vec2<f32>;
    var param_21: vec2<f32>;
    var param_22: vec4<f32>;
    var param_23: vec4<f32>;
    var param_24: vec4<f32>;
    var param_25: vec4<f32>;
    var param_26: vec4<f32>;
    var param_27: f32;
    var param_28: f32;
    var param_29: VS_Output;

    let _e88 = (*Input).Index;
    index = _e88;
    let _e89 = index;
    let _e92 = _372_.mModel_Inst[_e89];
    mModel = transpose(_e92);
    let _e94 = index;
    let _e97 = _372_.fUV[_e94];
    uv_2 = _e97;
    let _e98 = index;
    let _e101 = _372_.fAlphaUV[_e98];
    alphaUV_1 = _e101;
    let _e102 = index;
    let _e105 = _372_.fUVDistortionUV[_e102];
    uvDistortionUV_1 = _e105;
    let _e106 = index;
    let _e109 = _372_.fBlendUV[_e106];
    blendUV_1 = _e109;
    let _e110 = index;
    let _e113 = _372_.fBlendAlphaUV[_e110];
    blendAlphaUV_1 = _e113;
    let _e114 = index;
    let _e117 = _372_.fBlendUVDistortionUV[_e114];
    blendUVDistortionUV_1 = _e117;
    let _e118 = index;
    let _e121 = _372_.fModelColor[_e118];
    let _e123 = (*Input).Color;
    modelColor = (_e121 * _e123);
    let _e125 = index;
    let _e129 = _372_.fFlipbookIndexAndNextRate[_e125][0u];
    flipbookIndexAndNextRate_1 = _e129;
    let _e130 = index;
    let _e134 = _372_.fModelAlphaThreshold[_e130][0u];
    modelAlphaThreshold_1 = _e134;
    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e137 = (*Input).Pos[0u];
    let _e140 = (*Input).Pos[1u];
    let _e143 = (*Input).Pos[2u];
    localPosition = vec4<f32>(_e137, _e140, _e143, 1f);
    let _e145 = localPosition;
    let _e146 = mModel;
    worldPos = (_e145 * _e146);
    let _e148 = worldPos;
    let _e150 = _372_.mCameraProj;
    Output.PosVS = (_e148 * transpose(_e150));
    let _e155 = (*Input).UV1_;
    outputUV = _e155;
    let _e157 = outputUV[0u];
    let _e159 = uv_2[2u];
    let _e162 = uv_2[0u];
    outputUV[0u] = ((_e157 * _e159) + _e162);
    let _e166 = outputUV[1u];
    let _e168 = uv_2[3u];
    let _e171 = uv_2[1u];
    outputUV[1u] = ((_e166 * _e168) + _e171);
    let _e176 = _372_.mUVInversed[0u];
    let _e179 = _372_.mUVInversed[1u];
    let _e181 = outputUV[1u];
    outputUV[1u] = (_e176 + (_e179 * _e181));
    let _e186 = outputUV[0u];
    Output.UV_Others[0u] = _e186;
    let _e190 = outputUV[1u];
    Output.UV_Others[1u] = _e190;
    let _e195 = (*Input).Normal[0u];
    let _e198 = (*Input).Normal[1u];
    let _e201 = (*Input).Normal[2u];
    localNormal = vec4<f32>(_e195, _e198, _e201, 0f);
    let _e205 = (*Input).Binormal[0u];
    let _e208 = (*Input).Binormal[1u];
    let _e211 = (*Input).Binormal[2u];
    localBinormal = vec4<f32>(_e205, _e208, _e211, 0f);
    let _e215 = (*Input).Tangent[0u];
    let _e218 = (*Input).Tangent[1u];
    let _e221 = (*Input).Tangent[2u];
    localTangent = vec4<f32>(_e215, _e218, _e221, 0f);
    let _e223 = localNormal;
    let _e224 = mModel;
    worldNormal = (_e223 * _e224);
    let _e226 = localBinormal;
    let _e227 = mModel;
    worldBinormal = (_e226 * _e227);
    let _e229 = localTangent;
    let _e230 = mModel;
    worldTangent = (_e229 * _e230);
    let _e232 = worldNormal;
    worldNormal = normalize(_e232);
    let _e234 = worldBinormal;
    worldBinormal = normalize(_e234);
    let _e236 = worldTangent;
    worldTangent = normalize(_e236);
    let _e238 = worldNormal;
    Output.WorldN = _e238.xyz;
    let _e241 = worldBinormal;
    Output.WorldB = _e241.xyz;
    let _e244 = worldTangent;
    Output.WorldT = _e244.xyz;
    let _e247 = modelColor;
    Output.Color = _e247;
    let _e250 = (*Input).UV1_;
    param_19 = _e250;
    let _e252 = Output.UV_Others;
    param_1_2 = _e252.xy;
    let _e254 = alphaUV_1;
    param_2_2 = _e254;
    let _e255 = uvDistortionUV_1;
    param_3_2 = _e255;
    let _e256 = blendUV_1;
    param_4_2 = _e256;
    let _e257 = blendAlphaUV_1;
    param_5_2 = _e257;
    let _e258 = blendUVDistortionUV_1;
    param_6_2 = _e258;
    let _e259 = flipbookIndexAndNextRate_1;
    param_7_1 = _e259;
    let _e260 = modelAlphaThreshold_1;
    param_8_1 = _e260;
    let _e261 = Output;
    param_9_1 = _e261;
    let _e262 = param_19;
    param_20 = _e262;
    let _e263 = param_1_2;
    param_21 = _e263;
    let _e264 = param_2_2;
    param_22 = _e264;
    let _e265 = param_3_2;
    param_23 = _e265;
    let _e266 = param_4_2;
    param_24 = _e266;
    let _e267 = param_5_2;
    param_25 = _e267;
    let _e268 = param_6_2;
    param_26 = _e268;
    let _e269 = param_7_1;
    param_27 = _e269;
    let _e270 = param_8_1;
    param_28 = _e270;
    let _e271 = param_9_1;
    param_29 = _e271;
    CalculateAndStoreAdvancedParameter_u0028_vf2_u003b_vf2_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_f1_u003b_f1_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b((&param_20), (&param_21), (&param_22), (&param_23), (&param_24), (&param_25), (&param_26), (&param_27), (&param_28), (&param_29));
    let _e272 = param_29;
    param_9_1 = _e272;
    let _e273 = param_9_1;
    Output = _e273;
    let _e275 = Output.PosVS;
    Output.PosP = _e275;
    let _e277 = Output;
    return _e277;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param_30: VS_Input;
    var _position: vec4<f32>;

    let _e49 = Input_Pos_1;
    Input_1.Pos = _e49;
    let _e51 = Input_Normal_1;
    Input_1.Normal = _e51;
    let _e53 = Input_Binormal_1;
    Input_1.Binormal = _e53;
    let _e55 = Input_Tangent_1;
    Input_1.Tangent = _e55;
    let _e57 = Input_UV1_1;
    Input_1.UV1_ = _e57;
    let _e59 = Input_UV2_1;
    Input_1.UV2_ = _e59;
    let _e61 = Input_Color_1;
    Input_1.Color = _e61;
    let _e63 = gl_InstanceIndex_1;
    Input_1.Index = bitcast<u32>(_e63);
    let _e66 = Input_1;
    param_30 = _e66;
    let _e67 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b((&param_30));
    flattenTemp = _e67;
    let _e69 = flattenTemp.PosVS;
    _position = _e69;
    let _e71 = _position[1u];
    _position[1u] = -(_e71);
    let _e74 = _position;
    unnamed.gl_Position = _e74;
    let _e77 = flattenTemp.Color;
    _entryPointOutput_Color = _e77;
    let _e79 = flattenTemp.UV_Others;
    _entryPointOutput_UV_Others = _e79;
    let _e81 = flattenTemp.WorldN;
    _entryPointOutput_WorldN = _e81;
    let _e83 = flattenTemp.WorldB;
    _entryPointOutput_WorldB = _e83;
    let _e85 = flattenTemp.WorldT;
    _entryPointOutput_WorldT = _e85;
    let _e87 = flattenTemp.Alpha_Dist_UV;
    _entryPointOutput_Alpha_Dist_UV = _e87;
    let _e89 = flattenTemp.Blend_Alpha_Dist_UV;
    _entryPointOutput_Blend_Alpha_Dist_UV = _e89;
    let _e91 = flattenTemp.Blend_FBNextIndex_UV;
    _entryPointOutput_Blend_FBNextIndex_UV = _e91;
    let _e93 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e93;
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
    let _e29 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e29);
    let _e31 = unnamed.gl_Position;
    let _e32 = _entryPointOutput_Color;
    let _e33 = _entryPointOutput_UV_Others;
    let _e34 = _entryPointOutput_WorldN;
    let _e35 = _entryPointOutput_WorldB;
    let _e36 = _entryPointOutput_WorldT;
    let _e37 = _entryPointOutput_Alpha_Dist_UV;
    let _e38 = _entryPointOutput_Blend_Alpha_Dist_UV;
    let _e39 = _entryPointOutput_Blend_FBNextIndex_UV;
    let _e40 = _entryPointOutput_PosP;
    return VertexOutput(_e31, _e32, _e33, _e34, _e35, _e36, _e37, _e38, _e39, _e40);
}
