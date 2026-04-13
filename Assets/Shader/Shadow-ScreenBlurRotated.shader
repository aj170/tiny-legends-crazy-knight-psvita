î5Shader "Hidden/Shadow-ScreenBlurRotated" {
Properties {
 _MainTex ("Base", 2D) = "white" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix0 glstate_matrix_texture0
uniform mat4 glstate_matrix_texture0;

varying mediump vec2 xlv_TEXCOORD0;


attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  vec2 tmpvar_1;
  tmpvar_1 = _glesMultiTexCoord0.xy;
  mediump vec2 tmpvar_2;
  highp vec2 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.000000, 0.000000);
  tmpvar_4.x = tmpvar_1.x;
  tmpvar_4.y = tmpvar_1.y;
  tmpvar_3 = (gl_TextureMatrix0 * tmpvar_4).xy;
  tmpvar_2 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowBlurParams;
uniform sampler2D unity_RandomRotation16;
uniform highp vec4 _ScreenParams;
uniform sampler2D _MainTex;
uniform highp vec4 _BlurOffsets7;
uniform highp vec4 _BlurOffsets6;
uniform highp vec4 _BlurOffsets5;
uniform highp vec4 _BlurOffsets4;
uniform highp vec4 _BlurOffsets3;
uniform highp vec4 _BlurOffsets2;
uniform highp vec4 _BlurOffsets1;
uniform highp vec4 _BlurOffsets0;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 sample_7_2;
  mediump vec4 sample_6_3;
  mediump vec4 sample_5_4;
  mediump vec4 sample_4_5;
  mediump vec4 sample_3_6;
  mediump vec4 sample_2_7;
  mediump vec4 sample_1_8;
  mediump vec4 sample_9;
  mediump float diffTolerance_10;
  mediump float radius_11;
  mediump vec4 mask_12;
  mediump vec4 rotation_13;
  highp vec4 coord_14;
  mediump vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.000000, 0.000000);
  tmpvar_15.xy = xlv_TEXCOORD0;
  coord_14 = tmpvar_15;
  highp vec2 P_16;
  P_16 = ((coord_14.xy * _ScreenParams.xy) / 16.0000);
  lowp vec4 tmpvar_17;
  tmpvar_17 = ((2.00000 * texture2D (unity_RandomRotation16, P_16)) - 1.00000);
  rotation_13 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_MainTex, coord_14.xy);
  mask_12 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = (mask_12.z + (mask_12.w / 255.000));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((unity_ShadowBlurParams.y / (1.00000 - tmpvar_19)), 0.000000, 1.00000);
  radius_11 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = unity_ShadowBlurParams.x;
  diffTolerance_10 = tmpvar_21;
  mask_12.xy = (mask_12.xy * diffTolerance_10);
  highp vec4 rotation_22;
  rotation_22 = rotation_13;
  highp vec2 offset_23;
  offset_23.x = dot (_BlurOffsets0.xy, rotation_22.xy);
  offset_23.y = dot (_BlurOffsets0.xy, rotation_22.zw);
  lowp vec4 tmpvar_24;
  highp vec2 P_25;
  P_25 = (coord_14.xy + (radius_11 * offset_23));
  tmpvar_24 = texture2D (_MainTex, P_25);
  sample_9 = tmpvar_24;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_9.z + (sample_9.w / 255.000))))), 0.000000, 1.00000) * sample_9.xy));
  highp vec4 rotation_26;
  rotation_26 = rotation_13;
  highp vec2 offset_27;
  offset_27.x = dot (_BlurOffsets1.xy, rotation_26.xy);
  offset_27.y = dot (_BlurOffsets1.xy, rotation_26.zw);
  lowp vec4 tmpvar_28;
  highp vec2 P_29;
  P_29 = (coord_14.xy + (radius_11 * offset_27));
  tmpvar_28 = texture2D (_MainTex, P_29);
  sample_1_8 = tmpvar_28;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_1_8.z + (sample_1_8.w / 255.000))))), 0.000000, 1.00000) * sample_1_8.xy));
  highp vec4 rotation_30;
  rotation_30 = rotation_13;
  highp vec2 offset_31;
  offset_31.x = dot (_BlurOffsets2.xy, rotation_30.xy);
  offset_31.y = dot (_BlurOffsets2.xy, rotation_30.zw);
  lowp vec4 tmpvar_32;
  highp vec2 P_33;
  P_33 = (coord_14.xy + (radius_11 * offset_31));
  tmpvar_32 = texture2D (_MainTex, P_33);
  sample_2_7 = tmpvar_32;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_2_7.z + (sample_2_7.w / 255.000))))), 0.000000, 1.00000) * sample_2_7.xy));
  highp vec4 rotation_34;
  rotation_34 = rotation_13;
  highp vec2 offset_35;
  offset_35.x = dot (_BlurOffsets3.xy, rotation_34.xy);
  offset_35.y = dot (_BlurOffsets3.xy, rotation_34.zw);
  lowp vec4 tmpvar_36;
  highp vec2 P_37;
  P_37 = (coord_14.xy + (radius_11 * offset_35));
  tmpvar_36 = texture2D (_MainTex, P_37);
  sample_3_6 = tmpvar_36;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_3_6.z + (sample_3_6.w / 255.000))))), 0.000000, 1.00000) * sample_3_6.xy));
  highp vec4 rotation_38;
  rotation_38 = rotation_13;
  highp vec2 offset_39;
  offset_39.x = dot (_BlurOffsets4.xy, rotation_38.xy);
  offset_39.y = dot (_BlurOffsets4.xy, rotation_38.zw);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = (coord_14.xy + (radius_11 * offset_39));
  tmpvar_40 = texture2D (_MainTex, P_41);
  sample_4_5 = tmpvar_40;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_4_5.z + (sample_4_5.w / 255.000))))), 0.000000, 1.00000) * sample_4_5.xy));
  highp vec4 rotation_42;
  rotation_42 = rotation_13;
  highp vec2 offset_43;
  offset_43.x = dot (_BlurOffsets5.xy, rotation_42.xy);
  offset_43.y = dot (_BlurOffsets5.xy, rotation_42.zw);
  lowp vec4 tmpvar_44;
  highp vec2 P_45;
  P_45 = (coord_14.xy + (radius_11 * offset_43));
  tmpvar_44 = texture2D (_MainTex, P_45);
  sample_5_4 = tmpvar_44;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_5_4.z + (sample_5_4.w / 255.000))))), 0.000000, 1.00000) * sample_5_4.xy));
  highp vec4 rotation_46;
  rotation_46 = rotation_13;
  highp vec2 offset_47;
  offset_47.x = dot (_BlurOffsets6.xy, rotation_46.xy);
  offset_47.y = dot (_BlurOffsets6.xy, rotation_46.zw);
  lowp vec4 tmpvar_48;
  highp vec2 P_49;
  P_49 = (coord_14.xy + (radius_11 * offset_47));
  tmpvar_48 = texture2D (_MainTex, P_49);
  sample_6_3 = tmpvar_48;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_6_3.z + (sample_6_3.w / 255.000))))), 0.000000, 1.00000) * sample_6_3.xy));
  highp vec4 rotation_50;
  rotation_50 = rotation_13;
  highp vec2 offset_51;
  offset_51.x = dot (_BlurOffsets7.xy, rotation_50.xy);
  offset_51.y = dot (_BlurOffsets7.xy, rotation_50.zw);
  lowp vec4 tmpvar_52;
  highp vec2 P_53;
  P_53 = (coord_14.xy + (radius_11 * offset_51));
  tmpvar_52 = texture2D (_MainTex, P_53);
  sample_7_2 = tmpvar_52;
  mask_12.xy = (mask_12.xy + (clamp ((diffTolerance_10 - abs((tmpvar_19 - (sample_7_2.z + (sample_7_2.w / 255.000))))), 0.000000, 1.00000) * sample_7_2.xy));
  mediump vec4 tmpvar_54;
  tmpvar_54 = vec4((mask_12.x / mask_12.y));
  tmpvar_1 = tmpvar_54;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
"!!GLES"
}
}
 }
}
Fallback Off
}