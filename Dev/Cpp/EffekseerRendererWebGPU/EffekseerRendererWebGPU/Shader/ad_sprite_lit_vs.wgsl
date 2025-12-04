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
    @location(3) member_3: vec3<f32>,
    @location(4) member_4: vec3<f32>,
    @location(5) member_5: vec4<f32>,
    @location(6) member_6: vec4<f32>,
    @location(7) member_7: vec4<f32>,
    @location(8) member_8: vec4<f32>,
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

    let _e52 = (*Index);
    let _e53 = i32(_e52);
    let _e54 = (*DivideX);
    let _e55 = i32(_e54);
    DivideIndex[0u] = f32((_e53 - (i32(floor((f32(_e53) / f32(_e55)))) * _e55)));
    let _e65 = (*Index);
    let _e67 = (*DivideX);
    DivideIndex[1u] = f32((i32(_e65) / i32(_e67)));
    let _e72 = (*OriginUV);
    let _e73 = DivideIndex;
    let _e74 = (*flipbookOneSize);
    let _e77 = (*flipbookOffset);
    return ((_e72 + (_e73 * _e74)) + _e77);
}

fn GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b(FlipbookUV: ptr<function, vec2<f32>>, FlipbookIndex: ptr<function, f32>, DivideX_1: ptr<function, f32>, flipbookOneSize_1: ptr<function, vec2<f32>>, flipbookOffset_1: ptr<function, vec2<f32>>) -> vec2<f32> {
    var DivideIndex_1: vec2<f32>;
    var UVOffset: vec2<f32>;

    let _e53 = (*FlipbookIndex);
    let _e54 = i32(_e53);
    let _e55 = (*DivideX_1);
    let _e56 = i32(_e55);
    DivideIndex_1[0u] = f32((_e54 - (i32(floor((f32(_e54) / f32(_e56)))) * _e56)));
    let _e66 = (*FlipbookIndex);
    let _e68 = (*DivideX_1);
    DivideIndex_1[1u] = f32((i32(_e66) / i32(_e68)));
    let _e73 = DivideIndex_1;
    let _e74 = (*flipbookOneSize_1);
    let _e76 = (*flipbookOffset_1);
    UVOffset = ((_e73 * _e74) + _e76);
    let _e78 = (*FlipbookUV);
    let _e79 = UVOffset;
    return (_e78 - _e79);
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

    let _e87 = (*flipbookParameter1_)[0u];
    flipbookEnabled = _e87;
    let _e89 = (*flipbookParameter1_)[1u];
    flipbookLoopType = _e89;
    let _e91 = (*flipbookParameter1_)[2u];
    divideX = _e91;
    let _e93 = (*flipbookParameter1_)[3u];
    divideY = _e93;
    let _e94 = (*flipbookParameter2_);
    flipbookOneSize_2 = _e94.xy;
    let _e96 = (*flipbookParameter2_);
    flipbookOffset_2 = _e96.zw;
    let _e98 = flipbookEnabled;
    if (_e98 > 0f) {
        let _e100 = (*flipbookIndex);
        (*flipbookRate) = fract(_e100);
        let _e102 = (*flipbookIndex);
        Index_1 = floor(_e102);
        IndexOffset = 1f;
        let _e104 = Index_1;
        let _e105 = IndexOffset;
        NextIndex = (_e104 + _e105);
        let _e107 = divideX;
        let _e108 = divideY;
        FlipbookMaxCount = (_e107 * _e108);
        let _e110 = flipbookLoopType;
        if (_e110 == 0f) {
            let _e112 = NextIndex;
            let _e113 = FlipbookMaxCount;
            if (_e112 >= _e113) {
                let _e115 = FlipbookMaxCount;
                NextIndex = (_e115 - 1f);
                let _e117 = FlipbookMaxCount;
                Index_1 = (_e117 - 1f);
            }
        } else {
            let _e119 = flipbookLoopType;
            if (_e119 == 1f) {
                let _e121 = Index_1;
                let _e122 = FlipbookMaxCount;
                Index_1 = (_e121 - (floor((_e121 / _e122)) * _e122));
                let _e127 = NextIndex;
                let _e128 = FlipbookMaxCount;
                NextIndex = (_e127 - (floor((_e127 / _e128)) * _e128));
            } else {
                let _e133 = flipbookLoopType;
                if (_e133 == 2f) {
                    let _e135 = Index_1;
                    let _e136 = FlipbookMaxCount;
                    let _e138 = floor((_e135 / _e136));
                    Reverse = ((_e138 - (floor((_e138 / 2f)) * 2f)) == 1f);
                    let _e144 = Index_1;
                    let _e145 = FlipbookMaxCount;
                    Index_1 = (_e144 - (floor((_e144 / _e145)) * _e145));
                    let _e150 = Reverse;
                    if _e150 {
                        let _e151 = FlipbookMaxCount;
                        let _e153 = Index_1;
                        Index_1 = ((_e151 - 1f) - floor(_e153));
                    }
                    let _e156 = NextIndex;
                    let _e157 = FlipbookMaxCount;
                    let _e159 = floor((_e156 / _e157));
                    Reverse = ((_e159 - (floor((_e159 / 2f)) * 2f)) == 1f);
                    let _e165 = NextIndex;
                    let _e166 = FlipbookMaxCount;
                    NextIndex = (_e165 - (floor((_e165 / _e166)) * _e166));
                    let _e171 = Reverse;
                    if _e171 {
                        let _e172 = FlipbookMaxCount;
                        let _e174 = NextIndex;
                        NextIndex = ((_e172 - 1f) - floor(_e174));
                    }
                }
            }
        }
        let _e177 = (*uv);
        notInversedUV = _e177;
        let _e179 = (*uvInversed)[0u];
        let _e181 = (*uvInversed)[1u];
        let _e183 = notInversedUV[1u];
        notInversedUV[1u] = (_e179 + (_e181 * _e183));
        let _e187 = notInversedUV;
        param = _e187;
        let _e188 = Index_1;
        param_1_ = _e188;
        let _e189 = divideX;
        param_2_ = _e189;
        let _e190 = flipbookOneSize_2;
        param_3_ = _e190;
        let _e191 = flipbookOffset_2;
        param_4_ = _e191;
        let _e192 = param;
        param_1 = _e192;
        let _e193 = param_1_;
        param_2 = _e193;
        let _e194 = param_2_;
        param_3 = _e194;
        let _e195 = param_3_;
        param_4 = _e195;
        let _e196 = param_4_;
        param_5 = _e196;
        let _e197 = GetFlipbookOriginUV_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_1), (&param_2), (&param_3), (&param_4), (&param_5));
        OriginUV_1 = _e197;
        let _e198 = OriginUV_1;
        param_5_ = _e198;
        let _e199 = NextIndex;
        param_6_ = _e199;
        let _e200 = divideX;
        param_7_ = _e200;
        let _e201 = flipbookOneSize_2;
        param_8_ = _e201;
        let _e202 = flipbookOffset_2;
        param_9_ = _e202;
        let _e203 = param_5_;
        param_6 = _e203;
        let _e204 = param_6_;
        param_7 = _e204;
        let _e205 = param_7_;
        param_8 = _e205;
        let _e206 = param_8_;
        param_9 = _e206;
        let _e207 = param_9_;
        param_10 = _e207;
        let _e208 = GetFlipbookUVForIndex_u0028_vf2_u003b_f1_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_6), (&param_7), (&param_8), (&param_9), (&param_10));
        (*flipbookUV) = _e208;
        let _e210 = (*uvInversed)[0u];
        let _e212 = (*uvInversed)[1u];
        let _e214 = (*flipbookUV)[1u];
        (*flipbookUV)[1u] = (_e210 + (_e212 * _e214));
    }
    return;
}

fn CalculateAndStoreAdvancedParameter_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b(vsinput: ptr<function, VS_Input>, vsoutput: ptr<function, VS_Output>) {
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

    let _e65 = (*vsinput).Alpha_Dist_UV;
    (*vsoutput).Alpha_Dist_UV = _e65;
    let _e69 = _262_.mUVInversed[0u];
    let _e72 = _262_.mUVInversed[1u];
    let _e75 = (*vsinput).Alpha_Dist_UV[1u];
    (*vsoutput).Alpha_Dist_UV[1u] = (_e69 + (_e72 * _e75));
    let _e82 = _262_.mUVInversed[0u];
    let _e85 = _262_.mUVInversed[1u];
    let _e88 = (*vsinput).Alpha_Dist_UV[3u];
    (*vsoutput).Alpha_Dist_UV[3u] = (_e82 + (_e85 * _e88));
    let _e95 = (*vsinput).BlendUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[0u] = _e95;
    let _e100 = (*vsinput).BlendUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = _e100;
    let _e105 = _262_.mUVInversed[0u];
    let _e108 = _262_.mUVInversed[1u];
    let _e111 = (*vsinput).BlendUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[1u] = (_e105 + (_e108 * _e111));
    let _e117 = (*vsinput).Blend_Alpha_Dist_UV;
    (*vsoutput).Blend_Alpha_Dist_UV = _e117;
    let _e121 = _262_.mUVInversed[0u];
    let _e124 = _262_.mUVInversed[1u];
    let _e127 = (*vsinput).Blend_Alpha_Dist_UV[1u];
    (*vsoutput).Blend_Alpha_Dist_UV[1u] = (_e121 + (_e124 * _e127));
    let _e134 = _262_.mUVInversed[0u];
    let _e137 = _262_.mUVInversed[1u];
    let _e140 = (*vsinput).Blend_Alpha_Dist_UV[3u];
    (*vsoutput).Blend_Alpha_Dist_UV[3u] = (_e134 + (_e137 * _e140));
    flipbookRate_1 = 0f;
    flipbookNextIndexUV = vec2<f32>(0f, 0f);
    let _e145 = flipbookRate_1;
    param_11 = _e145;
    let _e146 = flipbookNextIndexUV;
    param_1_1 = _e146;
    let _e148 = _262_.flipbookParameter1_;
    param_2_1 = _e148;
    let _e150 = _262_.flipbookParameter2_;
    param_3_1 = _e150;
    let _e152 = (*vsinput).FlipbookIndex;
    param_4_1 = _e152;
    let _e154 = (*vsoutput).UV_Others;
    param_5_1 = _e154.xy;
    let _e157 = _262_.mUVInversed;
    let _e158 = _e157.xy;
    param_6_1 = vec2<f32>(_e158.x, _e158.y);
    let _e162 = param_11;
    param_12 = _e162;
    let _e163 = param_1_1;
    param_13 = _e163;
    let _e164 = param_2_1;
    param_14 = _e164;
    let _e165 = param_3_1;
    param_15 = _e165;
    let _e166 = param_4_1;
    param_16 = _e166;
    let _e167 = param_5_1;
    param_17 = _e167;
    let _e168 = param_6_1;
    param_18 = _e168;
    ApplyFlipbookVS_u0028_f1_u003b_vf2_u003b_vf4_u003b_vf4_u003b_f1_u003b_vf2_u003b_vf2_u003b((&param_12), (&param_13), (&param_14), (&param_15), (&param_16), (&param_17), (&param_18));
    let _e169 = param_12;
    param_11 = _e169;
    let _e170 = param_13;
    param_1_1 = _e170;
    let _e171 = param_11;
    flipbookRate_1 = _e171;
    let _e172 = param_1_1;
    flipbookNextIndexUV = _e172;
    let _e174 = flipbookNextIndexUV[0u];
    (*vsoutput).Blend_FBNextIndex_UV[2u] = _e174;
    let _e178 = flipbookNextIndexUV[1u];
    (*vsoutput).Blend_FBNextIndex_UV[3u] = _e178;
    let _e181 = flipbookRate_1;
    (*vsoutput).UV_Others[2u] = _e181;
    let _e185 = (*vsinput).AlphaThreshold;
    (*vsoutput).UV_Others[3u] = _e185;
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

    Output = VS_Output(vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec3<f32>(0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f), vec4<f32>(0f, 0f, 0f, 0f));
    let _e58 = (*Input).Normal;
    let _e61 = ((_e58.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldNormal = vec4<f32>(_e61.x, _e61.y, _e61.z, 0f);
    let _e67 = (*Input).Tangent;
    let _e70 = ((_e67.xyz - vec3<f32>(0.5f, 0.5f, 0.5f)) * 2f);
    worldTangent = vec4<f32>(_e70.x, _e70.y, _e70.z, 0f);
    let _e75 = worldNormal;
    let _e77 = worldTangent;
    let _e79 = cross(_e75.xyz, _e77.xyz);
    worldBinormal = vec4<f32>(_e79.x, _e79.y, _e79.z, 0f);
    let _e85 = (*Input).UV1_;
    uv1_ = _e85;
    let _e88 = _262_.mUVInversed[0u];
    let _e91 = _262_.mUVInversed[1u];
    let _e93 = uv1_[1u];
    uv1_[1u] = (_e88 + (_e91 * _e93));
    let _e98 = uv1_[0u];
    Output.UV_Others[0u] = _e98;
    let _e102 = uv1_[1u];
    Output.UV_Others[1u] = _e102;
    let _e107 = (*Input).Pos[0u];
    let _e110 = (*Input).Pos[1u];
    let _e113 = (*Input).Pos[2u];
    worldPos = vec4<f32>(_e107, _e110, _e113, 1f);
    let _e115 = worldPos;
    let _e117 = _262_.mCameraProj;
    Output.PosVS = (_e115 * transpose(_e117));
    let _e121 = worldNormal;
    Output.WorldN = _e121.xyz;
    let _e124 = worldBinormal;
    Output.WorldB = _e124.xyz;
    let _e127 = worldTangent;
    Output.WorldT = _e127.xyz;
    let _e131 = (*Input).Color;
    Output.Color = _e131;
    let _e133 = (*Input);
    param_19 = _e133;
    let _e134 = Output;
    param_1_2 = _e134;
    let _e135 = param_19;
    param_20 = _e135;
    let _e136 = param_1_2;
    param_21 = _e136;
    CalculateAndStoreAdvancedParameter_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b_struct_u002d_VS_Output_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf3_u002d_vf3_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf41_u003b((&param_20), (&param_21));
    let _e137 = param_21;
    param_1_2 = _e137;
    let _e138 = param_1_2;
    Output = _e138;
    let _e140 = Output.PosVS;
    Output.PosP = _e140;
    let _e142 = Output;
    return _e142;
}

fn main_1() {
    var Input_1: VS_Input;
    var flattenTemp: VS_Output;
    var param_22: VS_Input;
    var _position: vec4<f32>;

    let _e50 = Input_Pos_1;
    Input_1.Pos = _e50;
    let _e52 = Input_Color_1;
    Input_1.Color = _e52;
    let _e54 = Input_Normal_1;
    Input_1.Normal = _e54;
    let _e56 = Input_Tangent_1;
    Input_1.Tangent = _e56;
    let _e58 = Input_UV1_1;
    Input_1.UV1_ = _e58;
    let _e60 = Input_UV2_1;
    Input_1.UV2_ = _e60;
    let _e62 = Input_Alpha_Dist_UV_1;
    Input_1.Alpha_Dist_UV = _e62;
    let _e64 = Input_BlendUV_1;
    Input_1.BlendUV = _e64;
    let _e66 = Input_Blend_Alpha_Dist_UV_1;
    Input_1.Blend_Alpha_Dist_UV = _e66;
    let _e68 = Input_FlipbookIndex_1;
    Input_1.FlipbookIndex = _e68;
    let _e70 = Input_AlphaThreshold_1;
    Input_1.AlphaThreshold = _e70;
    let _e72 = Input_1;
    param_22 = _e72;
    let _e73 = _main_u0028_struct_u002d_VS_Input_u002d_vf3_u002d_vf4_u002d_vf4_u002d_vf4_u002d_vf2_u002d_vf2_u002d_vf4_u002d_vf2_u002d_vf4_u002d_f1_u002d_f11_u003b((&param_22));
    flattenTemp = _e73;
    let _e75 = flattenTemp.PosVS;
    _position = _e75;
    let _e77 = _position[1u];
    _position[1u] = -(_e77);
    let _e80 = _position;
    unnamed.gl_Position = _e80;
    let _e83 = flattenTemp.Color;
    _entryPointOutput_Color = _e83;
    let _e85 = flattenTemp.UV_Others;
    _entryPointOutput_UV_Others = _e85;
    let _e87 = flattenTemp.WorldN;
    _entryPointOutput_WorldN = _e87;
    let _e89 = flattenTemp.WorldB;
    _entryPointOutput_WorldB = _e89;
    let _e91 = flattenTemp.WorldT;
    _entryPointOutput_WorldT = _e91;
    let _e93 = flattenTemp.Alpha_Dist_UV;
    _entryPointOutput_Alpha_Dist_UV = _e93;
    let _e95 = flattenTemp.Blend_Alpha_Dist_UV;
    _entryPointOutput_Blend_Alpha_Dist_UV = _e95;
    let _e97 = flattenTemp.Blend_FBNextIndex_UV;
    _entryPointOutput_Blend_FBNextIndex_UV = _e97;
    let _e99 = flattenTemp.PosP;
    _entryPointOutput_PosP = _e99;
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
    let _e34 = unnamed.gl_Position.y;
    unnamed.gl_Position.y = -(_e34);
    let _e36 = unnamed.gl_Position;
    let _e37 = _entryPointOutput_Color;
    let _e38 = _entryPointOutput_UV_Others;
    let _e39 = _entryPointOutput_WorldN;
    let _e40 = _entryPointOutput_WorldB;
    let _e41 = _entryPointOutput_WorldT;
    let _e42 = _entryPointOutput_Alpha_Dist_UV;
    let _e43 = _entryPointOutput_Blend_Alpha_Dist_UV;
    let _e44 = _entryPointOutput_Blend_FBNextIndex_UV;
    let _e45 = _entryPointOutput_PosP;
    return VertexOutput(_e36, _e37, _e38, _e39, _e40, _e41, _e42, _e43, _e44, _e45);
}
