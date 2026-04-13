¡ÊShader "Hidden/TerrainEngine/Details/BillboardWavingDoublePass" {
Properties {
 _WavingTint ("Fade Color", Color) = (0.7,0.6,0.5,0)
 _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
 _WaveAndDistance ("Wave and distance", Vector) = (12,3.6,1,1)
 _Cutoff ("Cutoff", Float) = 0.5
}
SubShader { 
 LOD 200
 Tags { "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
  Cull Off
  ColorMask RGB
Program "vp" {
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 pos_4;
  pos_4 = _glesVertex;
  highp vec2 offset_5;
  offset_5 = _glesTANGENT.xy;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_6, tmpvar_6);
  if ((tmpvar_7 > _WaveAndDistance.w)) {
    offset_5 = vec2(0.000000, 0.000000);
  };
  pos_4.xyz = (_glesVertex.xyz + (offset_5.x * _CameraRight));
  pos_4.xyz = (pos_4.xyz + (offset_5.y * _CameraUp));
  highp vec4 vertex_8;
  vertex_8.yw = pos_4.yw;
  lowp vec4 color_9;
  color_9.xyz = _glesColor.xyz;
  lowp vec3 waveColor_10;
  highp vec3 waveMove_11;
  waveMove_11.y = 0.000000;
  highp vec4 tmpvar_12;
  tmpvar_12 = ((fract((((pos_4.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_4.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_13);
  highp vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_12 + (tmpvar_14 * -0.161616)) + (tmpvar_15 * 0.00833330)) + ((tmpvar_15 * tmpvar_13) * -0.000198410));
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * _glesTANGENT.y);
  waveMove_11.x = dot (tmpvar_19, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_11.z = dot (tmpvar_19, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_8.xz = (pos_4.xz - (waveMove_11.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_20;
  tmpvar_20 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_18, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_10 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (vertex_8.xyz - _CameraPosition.xyz);
  highp float tmpvar_22;
  tmpvar_22 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_21, tmpvar_21))) * _CameraPosition.w), 0.000000, 1.00000);
  color_9.w = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23.xyz = ((2.00000 * waveColor_10) * _glesColor.xyz);
  tmpvar_23.w = color_9.w;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (_glesNormal * unity_Scale.w));
  tmpvar_2 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.00000;
  tmpvar_26.xyz = tmpvar_25;
  mediump vec3 tmpvar_27;
  mediump vec4 normal_28;
  normal_28 = tmpvar_26;
  mediump vec3 x3_29;
  highp float vC_30;
  mediump vec3 x2_31;
  mediump vec3 x1_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHAr, normal_28);
  x1_32.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHAg, normal_28);
  x1_32.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHAb, normal_28);
  x1_32.z = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36 = (normal_28.xyzz * normal_28.yzzx);
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHBr, tmpvar_36);
  x2_31.x = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHBg, tmpvar_36);
  x2_31.y = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHBb, tmpvar_36);
  x2_31.z = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = ((normal_28.x * normal_28.x) - (normal_28.y * normal_28.y));
  vC_30 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (unity_SHC.xyz * vC_30);
  x3_29 = tmpvar_41;
  tmpvar_27 = ((x1_32 + x2_31) + x3_29);
  shlight_1 = tmpvar_27;
  tmpvar_3 = shlight_1;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_8);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_23;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  lowp vec4 c_4;
  c_4.xyz = ((tmpvar_2.xyz * _LightColor0.xyz) * (max (0.000000, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.00000));
  c_4.w = (tmpvar_2.w * xlv_COLOR0.w);
  c_1.w = c_4.w;
  c_1.xyz = (c_4.xyz + (tmpvar_2.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1 = _glesVertex;
  highp vec2 offset_2;
  offset_2 = _glesTANGENT.xy;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_4;
  tmpvar_4 = dot (tmpvar_3, tmpvar_3);
  if ((tmpvar_4 > _WaveAndDistance.w)) {
    offset_2 = vec2(0.000000, 0.000000);
  };
  pos_1.xyz = (_glesVertex.xyz + (offset_2.x * _CameraRight));
  pos_1.xyz = (pos_1.xyz + (offset_2.y * _CameraUp));
  highp vec4 vertex_5;
  vertex_5.yw = pos_1.yw;
  lowp vec4 color_6;
  color_6.xyz = _glesColor.xyz;
  lowp vec3 waveColor_7;
  highp vec3 waveMove_8;
  waveMove_8.y = 0.000000;
  highp vec4 tmpvar_9;
  tmpvar_9 = ((fract((((pos_1.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_1.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_9 + (tmpvar_11 * -0.161616)) + (tmpvar_12 * 0.00833330)) + ((tmpvar_12 * tmpvar_10) * -0.000198410));
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * _glesTANGENT.y);
  waveMove_8.x = dot (tmpvar_16, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_8.z = dot (tmpvar_16, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_5.xz = (pos_1.xz - (waveMove_8.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_17;
  tmpvar_17 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_15, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_7 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (vertex_5.xyz - _CameraPosition.xyz);
  highp float tmpvar_19;
  tmpvar_19 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_18, tmpvar_18))) * _CameraPosition.w), 0.000000, 1.00000);
  color_6.w = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20.xyz = ((2.00000 * waveColor_7) * _glesColor.xyz);
  tmpvar_20.w = color_6.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_5);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_20;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  c_1.xyz = (tmpvar_2.xyz * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz));
  c_1.w = (tmpvar_2.w * xlv_COLOR0.w);
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1 = _glesVertex;
  highp vec2 offset_2;
  offset_2 = _glesTANGENT.xy;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_4;
  tmpvar_4 = dot (tmpvar_3, tmpvar_3);
  if ((tmpvar_4 > _WaveAndDistance.w)) {
    offset_2 = vec2(0.000000, 0.000000);
  };
  pos_1.xyz = (_glesVertex.xyz + (offset_2.x * _CameraRight));
  pos_1.xyz = (pos_1.xyz + (offset_2.y * _CameraUp));
  highp vec4 vertex_5;
  vertex_5.yw = pos_1.yw;
  lowp vec4 color_6;
  color_6.xyz = _glesColor.xyz;
  lowp vec3 waveColor_7;
  highp vec3 waveMove_8;
  waveMove_8.y = 0.000000;
  highp vec4 tmpvar_9;
  tmpvar_9 = ((fract((((pos_1.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_1.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_9 + (tmpvar_11 * -0.161616)) + (tmpvar_12 * 0.00833330)) + ((tmpvar_12 * tmpvar_10) * -0.000198410));
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * _glesTANGENT.y);
  waveMove_8.x = dot (tmpvar_16, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_8.z = dot (tmpvar_16, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_5.xz = (pos_1.xz - (waveMove_8.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_17;
  tmpvar_17 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_15, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_7 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (vertex_5.xyz - _CameraPosition.xyz);
  highp float tmpvar_19;
  tmpvar_19 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_18, tmpvar_18))) * _CameraPosition.w), 0.000000, 1.00000);
  color_6.w = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20.xyz = ((2.00000 * waveColor_7) * _glesColor.xyz);
  tmpvar_20.w = color_6.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_5);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_20;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  mediump vec3 lm_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_4 = tmpvar_5;
  mediump vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_2.xyz * lm_4);
  c_1.xyz = tmpvar_6;
  c_1.w = (tmpvar_2.w * xlv_COLOR0.w);
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 pos_4;
  pos_4 = _glesVertex;
  highp vec2 offset_5;
  offset_5 = _glesTANGENT.xy;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_6, tmpvar_6);
  if ((tmpvar_7 > _WaveAndDistance.w)) {
    offset_5 = vec2(0.000000, 0.000000);
  };
  pos_4.xyz = (_glesVertex.xyz + (offset_5.x * _CameraRight));
  pos_4.xyz = (pos_4.xyz + (offset_5.y * _CameraUp));
  highp vec4 vertex_8;
  vertex_8.yw = pos_4.yw;
  lowp vec4 color_9;
  color_9.xyz = _glesColor.xyz;
  lowp vec3 waveColor_10;
  highp vec3 waveMove_11;
  waveMove_11.y = 0.000000;
  highp vec4 tmpvar_12;
  tmpvar_12 = ((fract((((pos_4.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_4.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_13);
  highp vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_12 + (tmpvar_14 * -0.161616)) + (tmpvar_15 * 0.00833330)) + ((tmpvar_15 * tmpvar_13) * -0.000198410));
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * _glesTANGENT.y);
  waveMove_11.x = dot (tmpvar_19, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_11.z = dot (tmpvar_19, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_8.xz = (pos_4.xz - (waveMove_11.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_20;
  tmpvar_20 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_18, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_10 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (vertex_8.xyz - _CameraPosition.xyz);
  highp float tmpvar_22;
  tmpvar_22 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_21, tmpvar_21))) * _CameraPosition.w), 0.000000, 1.00000);
  color_9.w = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23.xyz = ((2.00000 * waveColor_10) * _glesColor.xyz);
  tmpvar_23.w = color_9.w;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (_glesNormal * unity_Scale.w));
  tmpvar_2 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.00000;
  tmpvar_26.xyz = tmpvar_25;
  mediump vec3 tmpvar_27;
  mediump vec4 normal_28;
  normal_28 = tmpvar_26;
  mediump vec3 x3_29;
  highp float vC_30;
  mediump vec3 x2_31;
  mediump vec3 x1_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHAr, normal_28);
  x1_32.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHAg, normal_28);
  x1_32.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHAb, normal_28);
  x1_32.z = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36 = (normal_28.xyzz * normal_28.yzzx);
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHBr, tmpvar_36);
  x2_31.x = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHBg, tmpvar_36);
  x2_31.y = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHBb, tmpvar_36);
  x2_31.z = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = ((normal_28.x * normal_28.x) - (normal_28.y * normal_28.y));
  vC_30 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (unity_SHC.xyz * vC_30);
  x3_29 = tmpvar_41;
  tmpvar_27 = ((x1_32 + x2_31) + x3_29);
  shlight_1 = tmpvar_27;
  tmpvar_3 = shlight_1;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_8);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_23;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * vertex_8));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  lowp float tmpvar_4;
  mediump float lightShadowDataX_5;
  highp float dist_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_6 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = _LightShadowData.x;
  lightShadowDataX_5 = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = max (float((dist_6 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_5);
  tmpvar_4 = tmpvar_9;
  lowp vec4 c_10;
  c_10.xyz = ((tmpvar_2.xyz * _LightColor0.xyz) * ((max (0.000000, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * tmpvar_4) * 2.00000));
  c_10.w = (tmpvar_2.w * xlv_COLOR0.w);
  c_1.w = c_10.w;
  c_1.xyz = (c_10.xyz + (tmpvar_2.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_LightmapST;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1 = _glesVertex;
  highp vec2 offset_2;
  offset_2 = _glesTANGENT.xy;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_4;
  tmpvar_4 = dot (tmpvar_3, tmpvar_3);
  if ((tmpvar_4 > _WaveAndDistance.w)) {
    offset_2 = vec2(0.000000, 0.000000);
  };
  pos_1.xyz = (_glesVertex.xyz + (offset_2.x * _CameraRight));
  pos_1.xyz = (pos_1.xyz + (offset_2.y * _CameraUp));
  highp vec4 vertex_5;
  vertex_5.yw = pos_1.yw;
  lowp vec4 color_6;
  color_6.xyz = _glesColor.xyz;
  lowp vec3 waveColor_7;
  highp vec3 waveMove_8;
  waveMove_8.y = 0.000000;
  highp vec4 tmpvar_9;
  tmpvar_9 = ((fract((((pos_1.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_1.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_9 + (tmpvar_11 * -0.161616)) + (tmpvar_12 * 0.00833330)) + ((tmpvar_12 * tmpvar_10) * -0.000198410));
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * _glesTANGENT.y);
  waveMove_8.x = dot (tmpvar_16, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_8.z = dot (tmpvar_16, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_5.xz = (pos_1.xz - (waveMove_8.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_17;
  tmpvar_17 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_15, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_7 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (vertex_5.xyz - _CameraPosition.xyz);
  highp float tmpvar_19;
  tmpvar_19 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_18, tmpvar_18))) * _CameraPosition.w), 0.000000, 1.00000);
  color_6.w = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20.xyz = ((2.00000 * waveColor_7) * _glesColor.xyz);
  tmpvar_20.w = color_6.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_5);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_20;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * vertex_5));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  lowp float tmpvar_4;
  mediump float lightShadowDataX_5;
  highp float dist_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x;
  dist_6 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = _LightShadowData.x;
  lightShadowDataX_5 = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = max (float((dist_6 > (xlv_TEXCOORD2.z / xlv_TEXCOORD2.w))), lightShadowDataX_5);
  tmpvar_4 = tmpvar_9;
  c_1.xyz = (tmpvar_2.xyz * min ((2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((tmpvar_4 * 2.00000))));
  c_1.w = (tmpvar_2.w * xlv_COLOR0.w);
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_LightmapST;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1 = _glesVertex;
  highp vec2 offset_2;
  offset_2 = _glesTANGENT.xy;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_4;
  tmpvar_4 = dot (tmpvar_3, tmpvar_3);
  if ((tmpvar_4 > _WaveAndDistance.w)) {
    offset_2 = vec2(0.000000, 0.000000);
  };
  pos_1.xyz = (_glesVertex.xyz + (offset_2.x * _CameraRight));
  pos_1.xyz = (pos_1.xyz + (offset_2.y * _CameraUp));
  highp vec4 vertex_5;
  vertex_5.yw = pos_1.yw;
  lowp vec4 color_6;
  color_6.xyz = _glesColor.xyz;
  lowp vec3 waveColor_7;
  highp vec3 waveMove_8;
  waveMove_8.y = 0.000000;
  highp vec4 tmpvar_9;
  tmpvar_9 = ((fract((((pos_1.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_1.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_9 + (tmpvar_11 * -0.161616)) + (tmpvar_12 * 0.00833330)) + ((tmpvar_12 * tmpvar_10) * -0.000198410));
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * _glesTANGENT.y);
  waveMove_8.x = dot (tmpvar_16, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_8.z = dot (tmpvar_16, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_5.xz = (pos_1.xz - (waveMove_8.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_17;
  tmpvar_17 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_15, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_7 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (vertex_5.xyz - _CameraPosition.xyz);
  highp float tmpvar_19;
  tmpvar_19 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_18, tmpvar_18))) * _CameraPosition.w), 0.000000, 1.00000);
  color_6.w = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20.xyz = ((2.00000 * waveColor_7) * _glesColor.xyz);
  tmpvar_20.w = color_6.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_5);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_20;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * vertex_5));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  lowp float tmpvar_4;
  mediump float lightShadowDataX_5;
  highp float dist_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x;
  dist_6 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = _LightShadowData.x;
  lightShadowDataX_5 = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = max (float((dist_6 > (xlv_TEXCOORD2.z / xlv_TEXCOORD2.w))), lightShadowDataX_5);
  tmpvar_4 = tmpvar_9;
  mediump vec3 lm_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  lm_10 = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = vec3((tmpvar_4 * 2.00000));
  mediump vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_2.xyz * min (lm_10, tmpvar_12));
  c_1.xyz = tmpvar_13;
  c_1.w = (tmpvar_2.w * xlv_COLOR0.w);
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 pos_4;
  pos_4 = _glesVertex;
  highp vec2 offset_5;
  offset_5 = _glesTANGENT.xy;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_6, tmpvar_6);
  if ((tmpvar_7 > _WaveAndDistance.w)) {
    offset_5 = vec2(0.000000, 0.000000);
  };
  pos_4.xyz = (_glesVertex.xyz + (offset_5.x * _CameraRight));
  pos_4.xyz = (pos_4.xyz + (offset_5.y * _CameraUp));
  highp vec4 vertex_8;
  vertex_8.yw = pos_4.yw;
  lowp vec4 color_9;
  color_9.xyz = _glesColor.xyz;
  lowp vec3 waveColor_10;
  highp vec3 waveMove_11;
  waveMove_11.y = 0.000000;
  highp vec4 tmpvar_12;
  tmpvar_12 = ((fract((((pos_4.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_4.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_13);
  highp vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_12 + (tmpvar_14 * -0.161616)) + (tmpvar_15 * 0.00833330)) + ((tmpvar_15 * tmpvar_13) * -0.000198410));
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * _glesTANGENT.y);
  waveMove_11.x = dot (tmpvar_19, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_11.z = dot (tmpvar_19, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_8.xz = (pos_4.xz - (waveMove_11.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_20;
  tmpvar_20 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_18, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_10 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (vertex_8.xyz - _CameraPosition.xyz);
  highp float tmpvar_22;
  tmpvar_22 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_21, tmpvar_21))) * _CameraPosition.w), 0.000000, 1.00000);
  color_9.w = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23.xyz = ((2.00000 * waveColor_10) * _glesColor.xyz);
  tmpvar_23.w = color_9.w;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (_glesNormal * unity_Scale.w));
  tmpvar_2 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.00000;
  tmpvar_26.xyz = tmpvar_25;
  mediump vec3 tmpvar_27;
  mediump vec4 normal_28;
  normal_28 = tmpvar_26;
  mediump vec3 x3_29;
  highp float vC_30;
  mediump vec3 x2_31;
  mediump vec3 x1_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHAr, normal_28);
  x1_32.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHAg, normal_28);
  x1_32.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHAb, normal_28);
  x1_32.z = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36 = (normal_28.xyzz * normal_28.yzzx);
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHBr, tmpvar_36);
  x2_31.x = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHBg, tmpvar_36);
  x2_31.y = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHBb, tmpvar_36);
  x2_31.z = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = ((normal_28.x * normal_28.x) - (normal_28.y * normal_28.y));
  vC_30 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (unity_SHC.xyz * vC_30);
  x3_29 = tmpvar_41;
  tmpvar_27 = ((x1_32 + x2_31) + x3_29);
  shlight_1 = tmpvar_27;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_Object2World * vertex_8).xyz;
  highp vec4 tmpvar_43;
  tmpvar_43 = (unity_4LightPosX0 - tmpvar_42.x);
  highp vec4 tmpvar_44;
  tmpvar_44 = (unity_4LightPosY0 - tmpvar_42.y);
  highp vec4 tmpvar_45;
  tmpvar_45 = (unity_4LightPosZ0 - tmpvar_42.z);
  highp vec4 tmpvar_46;
  tmpvar_46 = (((tmpvar_43 * tmpvar_43) + (tmpvar_44 * tmpvar_44)) + (tmpvar_45 * tmpvar_45));
  highp vec4 tmpvar_47;
  tmpvar_47 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_43 * tmpvar_25.x) + (tmpvar_44 * tmpvar_25.y)) + (tmpvar_45 * tmpvar_25.z)) * inversesqrt(tmpvar_46))) * (1.0/((1.00000 + (tmpvar_46 * unity_4LightAtten0)))));
  highp vec3 tmpvar_48;
  tmpvar_48 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_47.x) + (unity_LightColor[1].xyz * tmpvar_47.y)) + (unity_LightColor[2].xyz * tmpvar_47.z)) + (unity_LightColor[3].xyz * tmpvar_47.w)));
  tmpvar_3 = tmpvar_48;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_8);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_23;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  lowp vec4 c_4;
  c_4.xyz = ((tmpvar_2.xyz * _LightColor0.xyz) * (max (0.000000, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * 2.00000));
  c_4.w = (tmpvar_2.w * xlv_COLOR0.w);
  c_1.w = c_4.w;
  c_1.xyz = (c_4.xyz + (tmpvar_2.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 pos_4;
  pos_4 = _glesVertex;
  highp vec2 offset_5;
  offset_5 = _glesTANGENT.xy;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_6, tmpvar_6);
  if ((tmpvar_7 > _WaveAndDistance.w)) {
    offset_5 = vec2(0.000000, 0.000000);
  };
  pos_4.xyz = (_glesVertex.xyz + (offset_5.x * _CameraRight));
  pos_4.xyz = (pos_4.xyz + (offset_5.y * _CameraUp));
  highp vec4 vertex_8;
  vertex_8.yw = pos_4.yw;
  lowp vec4 color_9;
  color_9.xyz = _glesColor.xyz;
  lowp vec3 waveColor_10;
  highp vec3 waveMove_11;
  waveMove_11.y = 0.000000;
  highp vec4 tmpvar_12;
  tmpvar_12 = ((fract((((pos_4.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_4.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_13);
  highp vec4 tmpvar_16;
  tmpvar_16 = (((tmpvar_12 + (tmpvar_14 * -0.161616)) + (tmpvar_15 * 0.00833330)) + ((tmpvar_15 * tmpvar_13) * -0.000198410));
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  highp vec4 tmpvar_19;
  tmpvar_19 = (tmpvar_18 * _glesTANGENT.y);
  waveMove_11.x = dot (tmpvar_19, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_11.z = dot (tmpvar_19, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_8.xz = (pos_4.xz - (waveMove_11.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_20;
  tmpvar_20 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_18, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_10 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (vertex_8.xyz - _CameraPosition.xyz);
  highp float tmpvar_22;
  tmpvar_22 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_21, tmpvar_21))) * _CameraPosition.w), 0.000000, 1.00000);
  color_9.w = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23.xyz = ((2.00000 * waveColor_10) * _glesColor.xyz);
  tmpvar_23.w = color_9.w;
  mat3 tmpvar_24;
  tmpvar_24[0] = _Object2World[0].xyz;
  tmpvar_24[1] = _Object2World[1].xyz;
  tmpvar_24[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_24 * (_glesNormal * unity_Scale.w));
  tmpvar_2 = tmpvar_25;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.00000;
  tmpvar_26.xyz = tmpvar_25;
  mediump vec3 tmpvar_27;
  mediump vec4 normal_28;
  normal_28 = tmpvar_26;
  mediump vec3 x3_29;
  highp float vC_30;
  mediump vec3 x2_31;
  mediump vec3 x1_32;
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHAr, normal_28);
  x1_32.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHAg, normal_28);
  x1_32.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHAb, normal_28);
  x1_32.z = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36 = (normal_28.xyzz * normal_28.yzzx);
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHBr, tmpvar_36);
  x2_31.x = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHBg, tmpvar_36);
  x2_31.y = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHBb, tmpvar_36);
  x2_31.z = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = ((normal_28.x * normal_28.x) - (normal_28.y * normal_28.y));
  vC_30 = tmpvar_40;
  highp vec3 tmpvar_41;
  tmpvar_41 = (unity_SHC.xyz * vC_30);
  x3_29 = tmpvar_41;
  tmpvar_27 = ((x1_32 + x2_31) + x3_29);
  shlight_1 = tmpvar_27;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_42;
  tmpvar_42 = (_Object2World * vertex_8).xyz;
  highp vec4 tmpvar_43;
  tmpvar_43 = (unity_4LightPosX0 - tmpvar_42.x);
  highp vec4 tmpvar_44;
  tmpvar_44 = (unity_4LightPosY0 - tmpvar_42.y);
  highp vec4 tmpvar_45;
  tmpvar_45 = (unity_4LightPosZ0 - tmpvar_42.z);
  highp vec4 tmpvar_46;
  tmpvar_46 = (((tmpvar_43 * tmpvar_43) + (tmpvar_44 * tmpvar_44)) + (tmpvar_45 * tmpvar_45));
  highp vec4 tmpvar_47;
  tmpvar_47 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_43 * tmpvar_25.x) + (tmpvar_44 * tmpvar_25.y)) + (tmpvar_45 * tmpvar_25.z)) * inversesqrt(tmpvar_46))) * (1.0/((1.00000 + (tmpvar_46 * unity_4LightAtten0)))));
  highp vec3 tmpvar_48;
  tmpvar_48 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_47.x) + (unity_LightColor[1].xyz * tmpvar_47.y)) + (unity_LightColor[2].xyz * tmpvar_47.z)) + (unity_LightColor[3].xyz * tmpvar_47.w)));
  tmpvar_3 = tmpvar_48;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_8);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_23;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * vertex_8));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_3;
  x_3 = (tmpvar_2.w - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  lowp float tmpvar_4;
  mediump float lightShadowDataX_5;
  highp float dist_6;
  lowp float tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_6 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = _LightShadowData.x;
  lightShadowDataX_5 = tmpvar_8;
  highp float tmpvar_9;
  tmpvar_9 = max (float((dist_6 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_5);
  tmpvar_4 = tmpvar_9;
  lowp vec4 c_10;
  c_10.xyz = ((tmpvar_2.xyz * _LightColor0.xyz) * ((max (0.000000, dot (xlv_TEXCOORD1, _WorldSpaceLightPos0.xyz)) * tmpvar_4) * 2.00000));
  c_10.w = (tmpvar_2.w * xlv_COLOR0.w);
  c_1.w = c_10.w;
  c_1.xyz = (c_10.xyz + (tmpvar_2.xyz * xlv_TEXCOORD2));
  gl_FragData[0] = c_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}
}
 }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
  ZWrite Off
  Cull Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
  ColorMask RGB
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 pos_3;
  pos_3 = _glesVertex;
  highp vec2 offset_4;
  offset_4 = _glesTANGENT.xy;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_5, tmpvar_5);
  if ((tmpvar_6 > _WaveAndDistance.w)) {
    offset_4 = vec2(0.000000, 0.000000);
  };
  pos_3.xyz = (_glesVertex.xyz + (offset_4.x * _CameraRight));
  pos_3.xyz = (pos_3.xyz + (offset_4.y * _CameraUp));
  highp vec4 vertex_7;
  vertex_7.yw = pos_3.yw;
  lowp vec4 color_8;
  color_8.xyz = _glesColor.xyz;
  lowp vec3 waveColor_9;
  highp vec3 waveMove_10;
  waveMove_10.y = 0.000000;
  highp vec4 tmpvar_11;
  tmpvar_11 = ((fract((((pos_3.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_3.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_11 + (tmpvar_13 * -0.161616)) + (tmpvar_14 * 0.00833330)) + ((tmpvar_14 * tmpvar_12) * -0.000198410));
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _glesTANGENT.y);
  waveMove_10.x = dot (tmpvar_18, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_10.z = dot (tmpvar_18, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_7.xz = (pos_3.xz - (waveMove_10.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_19;
  tmpvar_19 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_17, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_9 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (vertex_7.xyz - _CameraPosition.xyz);
  highp float tmpvar_21;
  tmpvar_21 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_20, tmpvar_20))) * _CameraPosition.w), 0.000000, 1.00000);
  color_8.w = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.xyz = ((2.00000 * waveColor_9) * _glesColor.xyz);
  tmpvar_22.w = color_8.w;
  mat3 tmpvar_23;
  tmpvar_23[0] = _Object2World[0].xyz;
  tmpvar_23[1] = _Object2World[1].xyz;
  tmpvar_23[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * (_glesNormal * unity_Scale.w));
  tmpvar_1 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_WorldSpaceLightPos0.xyz - (_Object2World * vertex_7).xyz);
  tmpvar_2 = tmpvar_25;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_7);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_22;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_7)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_4;
  x_4 = (tmpvar_3.w - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_7;
  c_7.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.000000, dot (xlv_TEXCOORD1, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_6)).w) * 2.00000));
  c_7.w = (tmpvar_3.w * xlv_COLOR0.w);
  c_1.xyz = c_7.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 pos_3;
  pos_3 = _glesVertex;
  highp vec2 offset_4;
  offset_4 = _glesTANGENT.xy;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_5, tmpvar_5);
  if ((tmpvar_6 > _WaveAndDistance.w)) {
    offset_4 = vec2(0.000000, 0.000000);
  };
  pos_3.xyz = (_glesVertex.xyz + (offset_4.x * _CameraRight));
  pos_3.xyz = (pos_3.xyz + (offset_4.y * _CameraUp));
  highp vec4 vertex_7;
  vertex_7.yw = pos_3.yw;
  lowp vec4 color_8;
  color_8.xyz = _glesColor.xyz;
  lowp vec3 waveColor_9;
  highp vec3 waveMove_10;
  waveMove_10.y = 0.000000;
  highp vec4 tmpvar_11;
  tmpvar_11 = ((fract((((pos_3.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_3.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_11 + (tmpvar_13 * -0.161616)) + (tmpvar_14 * 0.00833330)) + ((tmpvar_14 * tmpvar_12) * -0.000198410));
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _glesTANGENT.y);
  waveMove_10.x = dot (tmpvar_18, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_10.z = dot (tmpvar_18, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_7.xz = (pos_3.xz - (waveMove_10.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_19;
  tmpvar_19 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_17, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_9 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (vertex_7.xyz - _CameraPosition.xyz);
  highp float tmpvar_21;
  tmpvar_21 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_20, tmpvar_20))) * _CameraPosition.w), 0.000000, 1.00000);
  color_8.w = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.xyz = ((2.00000 * waveColor_9) * _glesColor.xyz);
  tmpvar_22.w = color_8.w;
  mat3 tmpvar_23;
  tmpvar_23[0] = _Object2World[0].xyz;
  tmpvar_23[1] = _Object2World[1].xyz;
  tmpvar_23[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * (_glesNormal * unity_Scale.w));
  tmpvar_1 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_25;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_7);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_22;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_4;
  x_4 = (tmpvar_3.w - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_5;
  c_5.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * (max (0.000000, dot (xlv_TEXCOORD1, lightDir_2)) * 2.00000));
  c_5.w = (tmpvar_3.w * xlv_COLOR0.w);
  c_1.xyz = c_5.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 pos_3;
  pos_3 = _glesVertex;
  highp vec2 offset_4;
  offset_4 = _glesTANGENT.xy;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_5, tmpvar_5);
  if ((tmpvar_6 > _WaveAndDistance.w)) {
    offset_4 = vec2(0.000000, 0.000000);
  };
  pos_3.xyz = (_glesVertex.xyz + (offset_4.x * _CameraRight));
  pos_3.xyz = (pos_3.xyz + (offset_4.y * _CameraUp));
  highp vec4 vertex_7;
  vertex_7.yw = pos_3.yw;
  lowp vec4 color_8;
  color_8.xyz = _glesColor.xyz;
  lowp vec3 waveColor_9;
  highp vec3 waveMove_10;
  waveMove_10.y = 0.000000;
  highp vec4 tmpvar_11;
  tmpvar_11 = ((fract((((pos_3.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_3.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_11 + (tmpvar_13 * -0.161616)) + (tmpvar_14 * 0.00833330)) + ((tmpvar_14 * tmpvar_12) * -0.000198410));
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _glesTANGENT.y);
  waveMove_10.x = dot (tmpvar_18, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_10.z = dot (tmpvar_18, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_7.xz = (pos_3.xz - (waveMove_10.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_19;
  tmpvar_19 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_17, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_9 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (vertex_7.xyz - _CameraPosition.xyz);
  highp float tmpvar_21;
  tmpvar_21 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_20, tmpvar_20))) * _CameraPosition.w), 0.000000, 1.00000);
  color_8.w = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.xyz = ((2.00000 * waveColor_9) * _glesColor.xyz);
  tmpvar_22.w = color_8.w;
  mat3 tmpvar_23;
  tmpvar_23[0] = _Object2World[0].xyz;
  tmpvar_23[1] = _Object2World[1].xyz;
  tmpvar_23[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * (_glesNormal * unity_Scale.w));
  tmpvar_1 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_WorldSpaceLightPos0.xyz - (_Object2World * vertex_7).xyz);
  tmpvar_2 = tmpvar_25;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_7);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_22;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_7));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_4;
  x_4 = (tmpvar_3.w - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_5;
  highp vec2 P_6;
  P_6 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.500000);
  highp float tmpvar_7;
  tmpvar_7 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp float atten_8;
  atten_8 = ((float((xlv_TEXCOORD3.z > 0.000000)) * texture2D (_LightTexture0, P_6).w) * texture2D (_LightTextureB0, vec2(tmpvar_7)).w);
  lowp vec4 c_9;
  c_9.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.000000, dot (xlv_TEXCOORD1, lightDir_2)) * atten_8) * 2.00000));
  c_9.w = (tmpvar_3.w * xlv_COLOR0.w);
  c_1.xyz = c_9.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 pos_3;
  pos_3 = _glesVertex;
  highp vec2 offset_4;
  offset_4 = _glesTANGENT.xy;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_5, tmpvar_5);
  if ((tmpvar_6 > _WaveAndDistance.w)) {
    offset_4 = vec2(0.000000, 0.000000);
  };
  pos_3.xyz = (_glesVertex.xyz + (offset_4.x * _CameraRight));
  pos_3.xyz = (pos_3.xyz + (offset_4.y * _CameraUp));
  highp vec4 vertex_7;
  vertex_7.yw = pos_3.yw;
  lowp vec4 color_8;
  color_8.xyz = _glesColor.xyz;
  lowp vec3 waveColor_9;
  highp vec3 waveMove_10;
  waveMove_10.y = 0.000000;
  highp vec4 tmpvar_11;
  tmpvar_11 = ((fract((((pos_3.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_3.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_11 + (tmpvar_13 * -0.161616)) + (tmpvar_14 * 0.00833330)) + ((tmpvar_14 * tmpvar_12) * -0.000198410));
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _glesTANGENT.y);
  waveMove_10.x = dot (tmpvar_18, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_10.z = dot (tmpvar_18, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_7.xz = (pos_3.xz - (waveMove_10.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_19;
  tmpvar_19 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_17, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_9 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (vertex_7.xyz - _CameraPosition.xyz);
  highp float tmpvar_21;
  tmpvar_21 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_20, tmpvar_20))) * _CameraPosition.w), 0.000000, 1.00000);
  color_8.w = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.xyz = ((2.00000 * waveColor_9) * _glesColor.xyz);
  tmpvar_22.w = color_8.w;
  mat3 tmpvar_23;
  tmpvar_23[0] = _Object2World[0].xyz;
  tmpvar_23[1] = _Object2World[1].xyz;
  tmpvar_23[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * (_glesNormal * unity_Scale.w));
  tmpvar_1 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_WorldSpaceLightPos0.xyz - (_Object2World * vertex_7).xyz);
  tmpvar_2 = tmpvar_25;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_7);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_22;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_7)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_4;
  x_4 = (tmpvar_3.w - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  mediump vec3 tmpvar_5;
  tmpvar_5 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_7;
  c_7.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.000000, dot (xlv_TEXCOORD1, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_6)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.00000));
  c_7.w = (tmpvar_3.w * xlv_COLOR0.w);
  c_1.xyz = c_7.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 pos_3;
  pos_3 = _glesVertex;
  highp vec2 offset_4;
  offset_4 = _glesTANGENT.xy;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_5, tmpvar_5);
  if ((tmpvar_6 > _WaveAndDistance.w)) {
    offset_4 = vec2(0.000000, 0.000000);
  };
  pos_3.xyz = (_glesVertex.xyz + (offset_4.x * _CameraRight));
  pos_3.xyz = (pos_3.xyz + (offset_4.y * _CameraUp));
  highp vec4 vertex_7;
  vertex_7.yw = pos_3.yw;
  lowp vec4 color_8;
  color_8.xyz = _glesColor.xyz;
  lowp vec3 waveColor_9;
  highp vec3 waveMove_10;
  waveMove_10.y = 0.000000;
  highp vec4 tmpvar_11;
  tmpvar_11 = ((fract((((pos_3.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_3.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_12);
  highp vec4 tmpvar_15;
  tmpvar_15 = (((tmpvar_11 + (tmpvar_13 * -0.161616)) + (tmpvar_14 * 0.00833330)) + ((tmpvar_14 * tmpvar_12) * -0.000198410));
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * _glesTANGENT.y);
  waveMove_10.x = dot (tmpvar_18, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_10.z = dot (tmpvar_18, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_7.xz = (pos_3.xz - (waveMove_10.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_19;
  tmpvar_19 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_17, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_9 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (vertex_7.xyz - _CameraPosition.xyz);
  highp float tmpvar_21;
  tmpvar_21 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_20, tmpvar_20))) * _CameraPosition.w), 0.000000, 1.00000);
  color_8.w = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.xyz = ((2.00000 * waveColor_9) * _glesColor.xyz);
  tmpvar_22.w = color_8.w;
  mat3 tmpvar_23;
  tmpvar_23[0] = _Object2World[0].xyz;
  tmpvar_23[1] = _Object2World[1].xyz;
  tmpvar_23[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * (_glesNormal * unity_Scale.w));
  tmpvar_1 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_25;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_7);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_22;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_7)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR0);
  lowp float x_4;
  x_4 = (tmpvar_3.w - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_5;
  c_5.xyz = ((tmpvar_3.xyz * _LightColor0.xyz) * ((max (0.000000, dot (xlv_TEXCOORD1, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.00000));
  c_5.w = (tmpvar_3.w * xlv_COLOR0.w);
  c_1.xyz = c_5.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}
}
 }
 Pass {
  Name "SHADOWCASTER"
  Tags { "LIGHTMODE"="SHADOWCASTER" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
  Cull Off
  Fog { Mode Off }
  ColorMask RGB
  Offset 1, 1
Program "vp" {
SubProgram "gles " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD1;
uniform highp vec4 unity_LightShadowBias;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 pos_2;
  pos_2 = _glesVertex;
  highp vec2 offset_3;
  offset_3 = _glesTANGENT.xy;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_5;
  tmpvar_5 = dot (tmpvar_4, tmpvar_4);
  if ((tmpvar_5 > _WaveAndDistance.w)) {
    offset_3 = vec2(0.000000, 0.000000);
  };
  pos_2.xyz = (_glesVertex.xyz + (offset_3.x * _CameraRight));
  pos_2.xyz = (pos_2.xyz + (offset_3.y * _CameraUp));
  highp vec4 vertex_6;
  vertex_6.yw = pos_2.yw;
  lowp vec4 color_7;
  color_7.xyz = _glesColor.xyz;
  lowp vec3 waveColor_8;
  highp vec3 waveMove_9;
  waveMove_9.y = 0.000000;
  highp vec4 tmpvar_10;
  tmpvar_10 = ((fract((((pos_2.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_2.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (((tmpvar_10 + (tmpvar_12 * -0.161616)) + (tmpvar_13 * 0.00833330)) + ((tmpvar_13 * tmpvar_11) * -0.000198410));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _glesTANGENT.y);
  waveMove_9.x = dot (tmpvar_17, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_9.z = dot (tmpvar_17, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_6.xz = (pos_2.xz - (waveMove_9.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_18;
  tmpvar_18 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_16, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_8 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (vertex_6.xyz - _CameraPosition.xyz);
  highp float tmpvar_20;
  tmpvar_20 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_19, tmpvar_19))) * _CameraPosition.w), 0.000000, 1.00000);
  color_7.w = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21.xyz = ((2.00000 * waveColor_8) * _glesColor.xyz);
  tmpvar_21.w = color_7.w;
  highp vec4 tmpvar_22;
  tmpvar_22 = (gl_ModelViewProjectionMatrix * vertex_6);
  tmpvar_1.xyw = tmpvar_22.xyw;
  tmpvar_1.z = (tmpvar_22.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_22.w * -1.00000)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_21;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD1;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp float x_1;
  x_1 = ((texture2D (_MainTex, xlv_TEXCOORD1) * xlv_COLOR0).w - _Cutoff);
  if ((x_1 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _LightPositionRange;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1 = _glesVertex;
  highp vec2 offset_2;
  offset_2 = _glesTANGENT.xy;
  highp vec3 tmpvar_3;
  tmpvar_3 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_4;
  tmpvar_4 = dot (tmpvar_3, tmpvar_3);
  if ((tmpvar_4 > _WaveAndDistance.w)) {
    offset_2 = vec2(0.000000, 0.000000);
  };
  pos_1.xyz = (_glesVertex.xyz + (offset_2.x * _CameraRight));
  pos_1.xyz = (pos_1.xyz + (offset_2.y * _CameraUp));
  highp vec4 vertex_5;
  vertex_5.yw = pos_1.yw;
  lowp vec4 color_6;
  color_6.xyz = _glesColor.xyz;
  lowp vec3 waveColor_7;
  highp vec3 waveMove_8;
  waveMove_8.y = 0.000000;
  highp vec4 tmpvar_9;
  tmpvar_9 = ((fract((((pos_1.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_1.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (((tmpvar_9 + (tmpvar_11 * -0.161616)) + (tmpvar_12 * 0.00833330)) + ((tmpvar_12 * tmpvar_10) * -0.000198410));
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * _glesTANGENT.y);
  waveMove_8.x = dot (tmpvar_16, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_8.z = dot (tmpvar_16, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_5.xz = (pos_1.xz - (waveMove_8.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_17;
  tmpvar_17 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_15, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_7 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (vertex_5.xyz - _CameraPosition.xyz);
  highp float tmpvar_19;
  tmpvar_19 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_18, tmpvar_18))) * _CameraPosition.w), 0.000000, 1.00000);
  color_6.w = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20.xyz = ((2.00000 * waveColor_7) * _glesColor.xyz);
  tmpvar_20.w = color_6.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_5);
  xlv_TEXCOORD0 = ((_Object2World * vertex_5).xyz - _LightPositionRange.xyz);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_20;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform highp vec4 _LightPositionRange;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp float x_2;
  x_2 = ((texture2D (_MainTex, xlv_TEXCOORD1) * xlv_COLOR0).w - _Cutoff);
  if ((x_2 < 0.000000)) {
    discard;
  };
  highp vec4 tmpvar_3;
  tmpvar_3 = fract((vec4(1.00000, 255.000, 65025.0, 1.60581e+008) * (sqrt(dot (xlv_TEXCOORD0, xlv_TEXCOORD0)) * _LightPositionRange.w)));
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_3 - (tmpvar_3.yzww * 0.00392157));
  tmpvar_1 = tmpvar_4;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_CUBE" }
"!!GLES"
}
}
 }
 Pass {
  Name "SHADOWCOLLECTOR"
  Tags { "LIGHTMODE"="SHADOWCOLLECTOR" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
  Cull Off
  Fog { Mode Off }
  ColorMask RGB
Program "vp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];


uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 pos_2;
  pos_2 = _glesVertex;
  highp vec2 offset_3;
  offset_3 = _glesTANGENT.xy;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_5;
  tmpvar_5 = dot (tmpvar_4, tmpvar_4);
  if ((tmpvar_5 > _WaveAndDistance.w)) {
    offset_3 = vec2(0.000000, 0.000000);
  };
  pos_2.xyz = (_glesVertex.xyz + (offset_3.x * _CameraRight));
  pos_2.xyz = (pos_2.xyz + (offset_3.y * _CameraUp));
  highp vec4 vertex_6;
  vertex_6.yw = pos_2.yw;
  lowp vec4 color_7;
  color_7.xyz = _glesColor.xyz;
  lowp vec3 waveColor_8;
  highp vec3 waveMove_9;
  waveMove_9.y = 0.000000;
  highp vec4 tmpvar_10;
  tmpvar_10 = ((fract((((pos_2.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_2.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (((tmpvar_10 + (tmpvar_12 * -0.161616)) + (tmpvar_13 * 0.00833330)) + ((tmpvar_13 * tmpvar_11) * -0.000198410));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _glesTANGENT.y);
  waveMove_9.x = dot (tmpvar_17, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_9.z = dot (tmpvar_17, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_6.xz = (pos_2.xz - (waveMove_9.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_18;
  tmpvar_18 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_16, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_8 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (vertex_6.xyz - _CameraPosition.xyz);
  highp float tmpvar_20;
  tmpvar_20 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_19, tmpvar_19))) * _CameraPosition.w), 0.000000, 1.00000);
  color_7.w = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21.xyz = ((2.00000 * waveColor_8) * _glesColor.xyz);
  tmpvar_21.w = color_7.w;
  highp vec4 tmpvar_22;
  tmpvar_22 = (_Object2World * vertex_6);
  tmpvar_1.xyz = tmpvar_22.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * vertex_6).z);
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_6);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_22).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_22).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_22).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_22).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_21;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _MainTex;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp vec4 _LightShadowData;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp vec4 zFar_3;
  highp vec4 zNear_4;
  lowp float x_5;
  x_5 = ((texture2D (_MainTex, xlv_TEXCOORD5) * xlv_COLOR0).w - _Cutoff);
  if ((x_5 < 0.000000)) {
    discard;
  };
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (xlv_TEXCOORD4.wwww, _LightSplitsNear);
  lowp vec4 tmpvar_7;
  tmpvar_7 = vec4(tmpvar_6);
  zNear_4 = tmpvar_7;
  bvec4 tmpvar_8;
  tmpvar_8 = lessThan (xlv_TEXCOORD4.wwww, _LightSplitsFar);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4(tmpvar_8);
  zFar_3 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (zNear_4 * zFar_3);
  highp float tmpvar_11;
  tmpvar_11 = clamp (((xlv_TEXCOORD4.w * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = ((((xlv_TEXCOORD0 * tmpvar_10.x) + (xlv_TEXCOORD1 * tmpvar_10.y)) + (xlv_TEXCOORD2 * tmpvar_10.z)) + (xlv_TEXCOORD3 * tmpvar_10.w));
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_12.xy);
  highp float tmpvar_14;
  if ((tmpvar_13.x < tmpvar_12.z)) {
    tmpvar_14 = _LightShadowData.x;
  } else {
    tmpvar_14 = 1.00000;
  };
  res_2.x = clamp ((tmpvar_14 + tmpvar_11), 0.000000, 1.00000);
  res_2.y = 1.00000;
  highp vec2 enc_15;
  highp vec2 tmpvar_16;
  tmpvar_16 = fract((vec2(1.00000, 255.000) * (1.00000 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_15.y = tmpvar_16.y;
  enc_15.x = (tmpvar_16.x - (tmpvar_16.y * 0.00392157));
  res_2.zw = enc_15;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];


uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec3 _CameraUp;
uniform highp vec3 _CameraRight;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 pos_2;
  pos_2 = _glesVertex;
  highp vec2 offset_3;
  offset_3 = _glesTANGENT.xy;
  highp vec3 tmpvar_4;
  tmpvar_4 = (_glesVertex.xyz - _CameraPosition.xyz);
  highp float tmpvar_5;
  tmpvar_5 = dot (tmpvar_4, tmpvar_4);
  if ((tmpvar_5 > _WaveAndDistance.w)) {
    offset_3 = vec2(0.000000, 0.000000);
  };
  pos_2.xyz = (_glesVertex.xyz + (offset_3.x * _CameraRight));
  pos_2.xyz = (pos_2.xyz + (offset_3.y * _CameraUp));
  highp vec4 vertex_6;
  vertex_6.yw = pos_2.yw;
  lowp vec4 color_7;
  color_7.xyz = _glesColor.xyz;
  lowp vec3 waveColor_8;
  highp vec3 waveMove_9;
  waveMove_9.y = 0.000000;
  highp vec4 tmpvar_10;
  tmpvar_10 = ((fract((((pos_2.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (pos_2.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_10);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_11);
  highp vec4 tmpvar_14;
  tmpvar_14 = (((tmpvar_10 + (tmpvar_12 * -0.161616)) + (tmpvar_13 * 0.00833330)) + ((tmpvar_13 * tmpvar_11) * -0.000198410));
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_16 * _glesTANGENT.y);
  waveMove_9.x = dot (tmpvar_17, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_9.z = dot (tmpvar_17, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_6.xz = (pos_2.xz - (waveMove_9.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_18;
  tmpvar_18 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_16, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_8 = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (vertex_6.xyz - _CameraPosition.xyz);
  highp float tmpvar_20;
  tmpvar_20 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_19, tmpvar_19))) * _CameraPosition.w), 0.000000, 1.00000);
  color_7.w = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21.xyz = ((2.00000 * waveColor_8) * _glesColor.xyz);
  tmpvar_21.w = color_7.w;
  highp vec4 tmpvar_22;
  tmpvar_22 = (_Object2World * vertex_6);
  tmpvar_1.xyz = tmpvar_22.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * vertex_6).z);
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_6);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_22).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_22).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_22).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_22).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_21;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp vec4 cascadeWeights_3;
  lowp float x_4;
  x_4 = ((texture2D (_MainTex, xlv_TEXCOORD5) * xlv_COLOR0).w - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_9;
  tmpvar_9.x = dot (tmpvar_5, tmpvar_5);
  tmpvar_9.y = dot (tmpvar_6, tmpvar_6);
  tmpvar_9.z = dot (tmpvar_7, tmpvar_7);
  tmpvar_9.w = dot (tmpvar_8, tmpvar_8);
  bvec4 tmpvar_10;
  tmpvar_10 = lessThan (tmpvar_9, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(tmpvar_10);
  cascadeWeights_3 = tmpvar_11;
  cascadeWeights_3.yzw = clamp ((cascadeWeights_3.yzw - cascadeWeights_3.xyz), 0.000000, 1.00000);
  highp vec3 p_12;
  p_12 = (xlv_TEXCOORD4.xyz - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_13;
  tmpvar_13 = clamp (((sqrt(dot (p_12, p_12)) * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((((xlv_TEXCOORD0 * cascadeWeights_3.x) + (xlv_TEXCOORD1 * cascadeWeights_3.y)) + (xlv_TEXCOORD2 * cascadeWeights_3.z)) + (xlv_TEXCOORD3 * cascadeWeights_3.w));
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_14.z)) {
    tmpvar_16 = _LightShadowData.x;
  } else {
    tmpvar_16 = 1.00000;
  };
  res_2.x = clamp ((tmpvar_16 + tmpvar_13), 0.000000, 1.00000);
  res_2.y = 1.00000;
  highp vec2 enc_17;
  highp vec2 tmpvar_18;
  tmpvar_18 = fract((vec2(1.00000, 255.000) * (1.00000 - (xlv_TEXCOORD4.w * _ProjectionParams.w))));
  enc_17.y = tmpvar_18.y;
  enc_17.x = (tmpvar_18.x - (tmpvar_18.y * 0.00392157));
  res_2.zw = enc_17;
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_NONATIVE" }
"!!GLES"
}
}
 }
}
SubShader { 
 Tags { "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
 Pass {
  Tags { "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="GrassBillboard" }
  Lighting On
  Cull Off
  AlphaTest Greater [_Cutoff]
  ColorMask RGB
Program "vp" {
}
  SetTexture [_MainTex] { combine texture * primary double, texture alpha * primary alpha }
 }
}
Fallback Off
}