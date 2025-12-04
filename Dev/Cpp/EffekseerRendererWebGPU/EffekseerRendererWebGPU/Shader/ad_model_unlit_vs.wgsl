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
    @location(3) member_3: vec4<f32>,
    @location(4) member_4: vec4<f32>,
    @location(5) member_5: vec4<f32>,
    @location(6) member_6: vec4<f32>,
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
var<private> _entryPointOutput_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_Alpha_Dist_UV: vec4<f32>;
var<private> _entryPointOutput_Blend_FBNextIndex_UV: vec4<f32>;
var<private> _entryPointOutput_PosP: vec4<f32>;

fn GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(OriginUV: ptr<function, vec2<f32>>, Index: ptr<function, f32>, DivideX: ptr<function, f32>, flipbookOneSize: ptr<function, vec2<f32>>, flipbookOffset: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex: vec2<f32>;

    let _e49 = (*Index);
    let _e50 = i32(_e49);
    let _e51 = (*DivideX);
    let _e52 = i32(_e51);
    DivideIndex[0u] = f32((_e50 - (i32(floor((f32(_e50) / f32(_e52)))) * _e52)));
    let _e62 = (*Index);
    let _e64 = (*DivideX);
    DivideIndex[1u] = f32((i32(_e62) / i32(_e64)));
    let _e69 = (*OriginUV);
    let _e70 = DivideIndex;
    let _e71 = (*flipbookOneSize);
    let _e74 = (*flipbookOffset);
    return ((_e69 + (_e70 * _e71)) + _e74);
}

fn GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(FlipbookUV: ptr<function, vec2<f32>>, FlipbookIndex: ptr<function, f32>, DivideX_1: ptr<function, f32>, flipbookOneSize_1: ptr<function, vec2<f32>>, flipbookOffset_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex_1: vec2<f32>;
    var UVOffset: vec2<f32>;

    let _e50 = (*FlipbookIndex);
    let _e51 = i32(_e50);
    let _e52 = (*DivideX_1);
    let _e53 = i32(_e52);
    DivideIndex_1[0u] = f32((_e51 - (i32(floor((f32(_e51) / f32(_e53)))) * _e53)));
    let _e63 = (*FlipbookIndex);
    let _e65 = (*DivideX_1);
    DivideIndex_1[1u] = f32((i32(_e63) / i32(_e65)));
    let _e70 = DivideIndex_1;
    let _e71 = (*flipbookOneSize_1);
    let _e73 = (*flipbookOffset_1);
    UVOffset = ((_e70 * _e71) + _e73);
    let _e75 = (*FlipbookUV);
    let _e76 = UVOffset;
    return (_e75 - _e76);
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

    let _e84 = (*flipbookParameter1_)[0u];
    flipbookEnabled = _e84;
    let _e86 = (*flipbookParameter1_)[1u];
    flipbookLoopType = _e86;
    let _e88 = (*flipbookParameter1_)[2u];
    divideX = _e88;
    let _e90 = (*flipbookParameter1_)[3u];
    divideY = _e90;
    let _e91 = (*flipbookParameter2_);
    flipbookOneSize_2 = _e91.xy;
    let _e93 = (*flipbookParameter2_);
    flipbookOffset_2 = _e93.zw;
    let _e95 = flipbookEnabled;
    if (_e95 > 0f) {
        let _e97 = (*flipbookIndex);
        (*flipbookRate) = fract(_e97);
        let _e99 = (*flipbookIndex);
        Index_1 = floor(_e99);
        IndexOffset = 1f;
        let _e101 = Index_1;
        let _e102 = IndexOffset;
        NextIndex = (_e101 + _e102);
        let _e104 = divideX;
        let _e105 = divideY;
        FlipbookMaxCount = (_e104 * _e105);
        let _e107 = flipbookLoopType;
        if (_e107 == 0f) {
            let _e109 = NextIndex;
            let _e110 = FlipbookMaxCount;
            if (_e109 >= _e110) {
                let _e112 = FlipbookMaxCount;
                NextIndex = (_e112 - 1f);
                let _e114 = FlipbookMaxCount;
                Index_1 = (_e114 - 1f);
            }
        } else {
            let _e116 = flipbookLoopType;
            if (_e116 == 1f) {
                let _e118 = Index_1;
                let _e119 = FlipbookMaxCount;
                Index_1 = (_e118 - (floor((_e118 / _e119)) * _e119));
                let _e124 = NextIndex;
                let _e125 = FlipbookMaxCount;
                NextIndex = (_e124 - (floor((_e124 / _e125)) * _e125));
            } else {
                let _e130 = flipbookLoopType;
                if (_e130 == 2f) {
                    let _e132 = Index_1;
                    let _e133 = FlipbookMaxCount;
                    let _e135 = floor((_e132 / _e133));
                    Reverse = ((_e135 - (floor((_e135 / 2f)) * 2f)) == 1f);
                    let _e141 = Index_1;
                    let _e142 = FlipbookMaxCount;
                    Index_1 = (_e141 - (floor((_e141 / _e142)) * _e142));
                    let _e147 = Reverse;
                    if _e147 {
                        let _e148 = FlipbookMaxCount;
                        let _e150 = Index_1;
                        Index_1 = ((_e148 - 1f) - floor(_e150));
                    }
                    let _e153 = NextIndex;
                    let _e154 = FlipbookMaxCount;
                    let _e156 = floor((_e153 / _e154));
                    Reverse = ((_e156 - (floor((_e156 / 2f)) * 2f)) == 1f);
                    let _e162 = NextIndex;
                    let _e163 = FlipbookMaxCount;
                    NextIndex = (_e162 - (floor((_e162 / _e163)) * _e163));
                    let _e168 = Reverse;
                    if _e168 {
                        let _e169 = FlipbookMaxCount;
                        let _e171 = NextIndex;
                        NextIndex = ((_e169 - 1f) - floor(_e171));
                    }
                }
            }
        }
        let _e174 = (*uv);
        notInversedUV = _e174;
        let _e176 = (*uvInversed)[0u];
        let _e178 = (*uvInversed)[1u];
        let _e180 = notInversedUV[1u];
        notInversedUV[1u] = (_e176 + (_e178 * _e180));
        let _e184 = notInversedUV;
        param = _e184;
        let _e185 = Index_1;
        param_1_ = _e185;
        let _e186 = divideX;
        param_2_ = _e186;
        let _e187 = flipbookOneSize_2;
        param_3_ = _e187;
        let _e188 = flipbookOffset_2;
        param_4_ = _e188;
        let _e189 = param;
        param_1 = _e189;
        let _e190 = param_1_;
        param_2 = _e190;
        let _e191 = param_2_;
        param_3 = _e191;
        let _e192 = param_3_;
        param_4 = _e192;
        let _e193 = param_4_;
        param_5 = _e193;
        let _e194 = GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_1), (&param_2), (&param_3), (&param_4), (&param_5));
        OriginUV_1 = _e194;
        let _e195 = OriginUV_1;
        param_5_ = _e195;
        let _e196 = NextIndex;
        param_6_ = _e196;
        let _e197 = divideX;
        param_7_ = _e197;
        let _e198 = flipbookOneSize_2;
        param_8_ = _e198;
        let _e199 = flipbookOffset_2;
        param_9_ = _e199;
        let _e200 = param_5_;
        param_6 = _e200;
        let _e201 = param_6_;
        param_7 = _e201;
        let _e202 = param_7_;
        param_8 = _e202;
        let _e203 = param_8_;
        param_9 = _e203;
        let _e204 = param_9_;
        param_10 = _e204;
        let _e205 = GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_6), (&param_7), (&param_8), (&param_9), (&param_10));
        (*flipbookUV) = _e205;
        let _e207 = (*uvInversed)[0u];
        let _e209 = (*uvInversed)[1u];
        let _e211 = (*flipbookUV)[1u];
        (*flipbookUV)[1u] = (_e207 + (_e209 * _e211));
    }
    return;
}

fn CalculateAndStoreAdvancedParameter_u0028_vf2_u003b_vf2_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_f1_u003b_f1_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b(uv_1: ptr<function, vec2<f32>>, uv1_: ptr<function, vec2<f32>>, alphaUV: ptr<function, vec4<f32>>, uvDistortionUV: ptr<function, vec4<f32>>, blendUV: ptr<function, vec4<f32>>, blendAlphaUV: ptr<function, vec4<f32>>, blendUVDistortionUV: ptr<function, vec4<f32>>, flipbookIndexAndNextRate: ptr<function, f32>, modelAlphaThreshold: ptr<function, f32>, vsoutput: ptr<function, VS_Output>) {
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

    let _e70 = (*uv_1)[0u];
    let _e72 = (*alphaUV)[2u];
    let _e75 = (*alphaUV)[0u];
    (*vsoutput).Alpha_Dist_UV[0u] = ((_e70 * _e72) + _e75);
    let _e80 = (*uv_1)[1u];
    let _e82 = (*alphaUV)[3u];
    let _e85 = (*alphaUV)[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = ((_e80 * _e82) + _e85);
    let _e90 = (*uv_1)[0u];
    let _e92 = (*uvDistortionUV)[2u];
    let _e95 = (*uvDistortionUV)[0u];
    (*vsoutput).Alpha_Dist_UV[2u] = ((_e90 * _e92) + _e95);
    let _e100 = (*uv_1)[1u];
    let _e102 = (*uvDistortionUV)[3u];
    let _e105 = (*uvDistortionUV)[1u];
    (*vsoutput).Alpha_Dist_UV[3u] = ((_e100 * _e102) + _e105);
    let _e110 = (*uv_1)[0u];
    let _e112 = (*blendUV)[2u];
    let _e115 = (*blendUV)[0u];
    (*vsoutput).Blend_FBNextIndex_UV[0u] = ((_e110 * _e112) + _e115);
    let _e120 = (*uv_1)[1u];
    let _e122 = (*blendUV)[3u];
    let _e125 = (*blendUV)[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = ((_e120 * _e122) + _e125);
    let _e130 = (*uv_1)[0u];
    let _e132 = (*blendAlphaUV)[2u];
    let _e135 = (*blendAlphaUV)[0u];
    (*vsoutput).Blend_Alpha_Dist_UV[0u] = ((_e130 * _e132) + _e135);
    let _e140 = (*uv_1)[1u];
    let _e142 = (*blendAlphaUV)[3u];
    let _e145 = (*blendAlphaUV)[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = ((_e140 * _e142) + _e145);
    let _e150 = (*uv_1)[0u];
    let _e152 = (*blendUVDistortionUV)[2u];
    let _e155 = (*blendUVDistortionUV)[0u];
    (*vsoutput).Blend_Alpha_Dist_UV[2u] = ((_e150 * _e152) + _e155);
    let _e160 = (*uv_1)[1u];
    let _e162 = (*blendUVDistortionUV)[3u];
    let _e165 = (*blendUVDistortionUV)[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = ((_e160 * _e162) + _e165);
    flipbookRate_1 = 0f;
    flipbookNextIndexUV = vec2<f32>(0f, 0f);
    let _e169 = flipbookRate_1;
    param_11 = _e169;
    let _e170 = flipbookNextIndexUV;
    param_1_1 = _e170;
    let _e172 = _372_.flipbookParameter1_;
    param_2_1 = _e172;
    let _e174 = _372_.flipbookParameter2_;
    param_3_1 = _e174;
    let _e175 = (*flipbookIndexAndNextRate);
    param_4_1 = _e175;
    let _e176 = (*uv1_);
    param_5_1 = _e176;
    let _e178 = _372_.mUVInversed;
    let _e179 = _e178.xy;
    param_6_1 = vec2<f32>(_e179.x, _e179.y);
    let _e183 = param_11;
    param_12 = _e183;
    let _e184 = param_1_1;
    param_13 = _e184;
    let _e185 = param_2_1;
    param_14 = _e185;
    let _e186 = param_3_1;
    param_15 = _e186;
    let _e187 = param_4_1;
    param_16 = _e187;
    let _e188 = param_5_1;
    param_17 = _e188;
    let _e189 = param_6_1;
    param_18 = _e189;
    ApplyFlipbookVS_u0028_f1_u003b_vf2_u003b_vf4_u003b_vf4_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_12), (&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    let _e190 = param_12;
    param_11 = _e190;
    let _e191 = param_13;
    param_1_1 = _e191;
    let _e192 = param_11;
    flipbookRate_1 = _e192;
    let _e193 = param_1_1;
    flipbookNextIndexUV = _e193;
    let _e195 = flipbookNextIndexUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[2u] = _e195;
    let _e199 = flipbookNextIndexUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[3u] = _e199;
    let _e202 = flipbookRate_1;
    (*vsoutput).UV_Others[2u] = _e202;
    let _e205 = (*modelAlphaThreshold);
    (*vsoutput).UV_Others[3u] = _e205;
    let _e210 = _372_.mUVInversed[0u];
    let _e213 = _372_.mUVInversed[1u];
    let _e216 = (*vsoutput).Alpha_Dist_UV[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = (_e210 + (_e213 * _e216));
    let _e223 = _372_.mUVInversed[0u];
    let _e226 = _372_.mUVInversed[1u];
    let _e229 = (*vsoutput).Alpha_Dist_UV[3u];
    (*vsoutput).Alpha_Dist_UV[3u] = (_e223 + (_e226 * _e229));
    let _e236 = _372_.mUVInversed[0u];
    let _e239 = _372_.mUVInversed[1u];
    let _e242 = (*vsoutput).Blend_FBNextIndex_UV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = (_e236 + (_e239 * _e242));
    let _e249 = _372_.mUVInversed[0u];
    let _e252 = _372_.mUVInversed[1u];
    let _e255 = (*vsoutput).Blend_Alpha_Dist_UV[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = (_e249 + (_e252 * _e255));
    let _e262 = _372_.mUVInversed[0u];
    let _e265 = _372_.mUVInversed[1u];
    let _e268 = (*vsoutput).Blend_Alpha_Dist_UV[3u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = (_e262 + (_e265 * _e268));
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

    let _e81 = (*Input).Index;
    index = _e81;
    let _e82 = index;
    let _e85 = _372_.mModel_Inst[_e82];
    mModel = transpose(_e85);
    let _e87 = index;
    let _e90 = _372_.fUV[_e87];
    uv_2 = _e90;
    let _e91 = index;
    let _e94 = _372_.fAlphaUV[_e91];
    alphaUV_1 = _e94;
    let _e95 = index;
    let _e98 = _372_.fUVDistortionUV[_e95];
    uvDistortionUV_1 = _e98;
    let _e99 = index;
    let _e102 = _372_.fBlendUV[_e99];
    blendUV_1 = _e102;
    let _e103 = index;
    let _e106 = _372_.fBlendAlphaUV[_e103];
    blendAlphaUV_1 = _e106;
    let _e107 = index;
    let _e110 = _372_.fBlendUVDistortionUV[_e107];
    blendUVDistortionUV_1 = _e110;
    let _e111 = index;
    let _e114 = _372_.fModelColor[_e111];
    let _e116 = (*Input).Color;
    modelColor = (_e114 * _e116);
    let _e118 = index;
    let _e122 = _372_.fFlipbookIndexAndNextRate[_e118][0u];
    flipbookIndexAndNextRate_1 = _e122;
    let _e123 = index;
    let _e127 = _372_.fModelAlphaThreshold[_e123][0u];
    modelAlphaThreshold_1 = _e127;
    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e130 = (*Input).Pos[0u];
    let _e133 = (*Input).Pos[1u];
    let _e136 = (*Input).Pos[2u];
    localPosition = vec4<f32>(_e130, _e133, _e136, 1f);
    let _e138 = localPosition;
    let _e139 = mModel;
    worldPos = (_e138 * _e139);
    let _e141 = worldPos;
    let _e143 = _372_.mCameraProj;
    Output.PosVS = (_e141 * transpose(_e143));
    let _e148 = (*Input).UV1_;
    outputUV = _e148;
    let _e150 = outputUV[0u];
    let _e152 = uv_2[2u];
    let _e155 = uv_2[0u];
    outputUV[0u] = ((_e150 * _e152) + _e155);
    let _e159 = outputUV[1u];
    let _e161 = uv_2[3u];
    let _e164 = uv_2[1u];
    outputUV[1u] = ((_e159 * _e161) + _e164);
    let _e169 = _372_.mUVInversed[0u];
    let _e172 = _372_.mUVInversed[1u];
    let _e174 = outputUV[1u];
    outputUV[1u] = (_e169 + (_e172 * _e174));
    let _e179 = outputUV[0u];
    Output.UV_Others[0u] = _e179;
    let _e183 = outputUV[1u];
    Output.UV_Others[1u] = _e183;
    let _e188 = (*Input).Normal[0u];
    let _e191 = (*Input).Normal[1u];
    let _e194 = (*Input).Normal[2u];
    localNormal = vec4<f32>(_e188, _e191, _e194, 0f);
    let _e196 = localNormal;
    let _e197 = mModel;
    localNormal = normalize((_e196 * _e197));
    let _e200 = localNormal;
    Output.WorldN = _e200.xyz;
    let _e203 = modelColor;
    Output.Color = _e203;
    let _e206 = (*Input).UV1_;
    param_19 = _e206;
    let _e208 = Output.UV_Others;
    param_1_2 = _e208.xy;
    let _e210 = alphaUV_1;
    param_2_2 = _e210;
    let _e211 = uvDistortionUV_1;
    param_3_2 = _e211;
    let _e212 = blendUV_1;
    param_4_2 = _e212;
    let _e213 = blendAlphaUV_1;
    param_5_2 = _e213;
    let _e214 = blendUVDistortionUV_1;
    param_6_2 = _e214;
    let _e215 = flipbookIndexAndNextRate_1;
    param_7_1 = _e215;
    let _e216 = modelAlphaThreshold_1;
    param_8_1 = _e216;
    let _e217 = Output;
    param_9_1 = _e217;
    let _e218 = param_19;
    param_20 = _e218;
    let _e219 = param_1_2;
    param_21 = _e219;
    let _e220 = param_2_2;
    param_22 = _e220;
    let _e221 = param_3_2;
    param_23 = _e221;
    let _e222 = param_4_2;
    param_24 = _e222;
    let _e223 = param_5_2;
    param_25 = _e223;
    let _e224 = param_6_2;
    param_26 = _e224;
    let _e225 = param_7_1;
    param_27 = _e225;
    let _e226 = param_8_1;
    param_28 = _e226;
    let _e227 = param_9_1;
    param_29 = _e227;
    CalculateAndStoreAdvancedParameter_u0028_vf2_u003b_vf2_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_vf4_u003b_f1_u003b_f1_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b((&param_20), (&param_21), (&param_22), (&param_23), (&param_24), (&param_25), (&param_26), (&param_27), (&param_28), (&param_29));
    let _e228 = param_29;
    param_9_1 = _e228;
    let _e229 = param_9_1;
    Output = _e229;
    let _e231 = Output.PosVS;
    Output.PosP = _e231;
    let _e233 = Output;
    return _e233;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param_30: VS_Input;
    var _position: vec4<f32>;

    let _e47 = Input_Pos_1;
    Input_1.Pos = _e47;
    let _e49 = Input_Normal_1;
    Input_1.Normal = _e49;
    let _e51 = Input_Binormal_1;
    Input_1.Binormal = _e51;
    let _e53 = Input_Tangent_1;
    Input_1.Tangent = _e53;
    let _e55 = Input_UV1_1;
    Input_1.UV1_ = _e55;
    let _e57 = Input_UV2_1;
    Input_1.UV2_ = _e57;
    let _e59 = Input_Color_1;
    Input_1.Color = _e59;
    let _e61 = gl_InstanceIndex_1;
    Input_1.Index = bitcast<u32>(_e61);
    let _e64 = Input_1;
    param_30 = _e64;
    let _e65 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf2_u002d_vf2_u002d_vf4_u002d_u11_u003b((&param_30));
    flattenTemp = _e65;
    let _e67 = flattenTemp.PosVS;
    _position = _e67;
    let _e69 = _position[1u];
    _position[1u] = -(_e69);
    let _e72 = _position;
    unnamed.gl_Position = _e72;
    let _e75 = flattenTemp.Color;
    _entryPointOutput_Color = _e75;
    let _e77 = flattenTemp.UV_Others;
    _entryPointOutput_UV_Others = _e77;
    let _e79 = flattenTemp.WorldN;
    _entryPointOutput_WorldN = _e79;
    let _e81 = flattenTemp.Alpha_Dist_UV;
    _entryPointOutput_Alpha_Dist_UV = _e81;
    let _e83 = flattenTemp.Blend_Alpha_Dist_UV;
    _entryPointOutput_Blend_Alpha_Dist_UV = _e83;
    let _e85 = flattenTemp.Blend_FBNextIndex_UV;
    _entryPointOutput_Blend_FBNextIndex_UV = _e85;
    let _e87 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e87;
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
    let _e27 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e27);
    let _e29 = unnamed.gl_Position;
    let _e30 = _entryPointOutput_Color;
    let _e31 = _entryPointOutput_UV_Others;
    let _e32 = _entryPointOutput_WorldN;
    let _e33 = _entryPointOutput_Alpha_Dist_UV;
    let _e34 = _entryPointOutput_Blend_Alpha_Dist_UV;
    let _e35 = _entryPointOutput_Blend_FBNextIndex_UV;
    let _e36 = _entryPointOutput_PosP;
    return VertexOutput(_e29, _e30, _e31, _e32, _e33, _e34, _e35, _e36);
}
