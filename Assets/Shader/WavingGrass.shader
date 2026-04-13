͋Shader "Hidden/TerrainEngine/Details/WavingDoublePass" {
Properties {
 _WavingTint ("Fade Color", Color) = (0.7,0.6,0.5,0)
 _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
 _WaveAndDistance ("Wave and distance", Vector) = (12,3.6,1,1)
 _Cutoff ("Cutoff", Float) = 0.5
}
SubShader { 
 LOD 200
 Tags { "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 vertex_4;
  vertex_4.yw = _glesVertex.yw;
  lowp vec4 color_5;
  color_5.xyz = _glesColor.xyz;
  lowp vec3 waveColor_6;
  highp vec3 waveMove_7;
  waveMove_7.y = 0.000000;
  highp vec4 tmpvar_8;
  tmpvar_8 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_8 + (tmpvar_10 * -0.161616)) + (tmpvar_11 * 0.00833330)) + ((tmpvar_11 * tmpvar_9) * -0.000198410));
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_7.x = dot (tmpvar_15, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_7.z = dot (tmpvar_15, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_4.xz = (_glesVertex.xz - (waveMove_7.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_16;
  tmpvar_16 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_14, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_6 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (vertex_4.xyz - _CameraPosition.xyz);
  highp float tmpvar_18;
  tmpvar_18 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_17, tmpvar_17))) * _CameraPosition.w), 0.000000, 1.00000);
  color_5.w = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = ((2.00000 * waveColor_6) * _glesColor.xyz);
  tmpvar_19.w = color_5.w;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = tmpvar_21;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  mediump vec3 x3_25;
  highp float vC_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_26 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_26);
  x3_25 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_25);
  shlight_1 = tmpvar_23;
  tmpvar_3 = shlight_1;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_4);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_19;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 vertex_1;
  vertex_1.yw = _glesVertex.yw;
  lowp vec4 color_2;
  color_2.xyz = _glesColor.xyz;
  lowp vec3 waveColor_3;
  highp vec3 waveMove_4;
  waveMove_4.y = 0.000000;
  highp vec4 tmpvar_5;
  tmpvar_5 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_5);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_5 + (tmpvar_7 * -0.161616)) + (tmpvar_8 * 0.00833330)) + ((tmpvar_8 * tmpvar_6) * -0.000198410));
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_4.x = dot (tmpvar_12, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_4.z = dot (tmpvar_12, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_1.xz = (_glesVertex.xz - (waveMove_4.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_13;
  tmpvar_13 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_11, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_3 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (vertex_1.xyz - _CameraPosition.xyz);
  highp float tmpvar_15;
  tmpvar_15 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_14, tmpvar_14))) * _CameraPosition.w), 0.000000, 1.00000);
  color_2.w = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.xyz = ((2.00000 * waveColor_3) * _glesColor.xyz);
  tmpvar_16.w = color_2.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_1);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_16;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 vertex_1;
  vertex_1.yw = _glesVertex.yw;
  lowp vec4 color_2;
  color_2.xyz = _glesColor.xyz;
  lowp vec3 waveColor_3;
  highp vec3 waveMove_4;
  waveMove_4.y = 0.000000;
  highp vec4 tmpvar_5;
  tmpvar_5 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_5);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_5 + (tmpvar_7 * -0.161616)) + (tmpvar_8 * 0.00833330)) + ((tmpvar_8 * tmpvar_6) * -0.000198410));
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_4.x = dot (tmpvar_12, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_4.z = dot (tmpvar_12, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_1.xz = (_glesVertex.xz - (waveMove_4.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_13;
  tmpvar_13 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_11, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_3 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (vertex_1.xyz - _CameraPosition.xyz);
  highp float tmpvar_15;
  tmpvar_15 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_14, tmpvar_14))) * _CameraPosition.w), 0.000000, 1.00000);
  color_2.w = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.xyz = ((2.00000 * waveColor_3) * _glesColor.xyz);
  tmpvar_16.w = color_2.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_1);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_16;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 vertex_4;
  vertex_4.yw = _glesVertex.yw;
  lowp vec4 color_5;
  color_5.xyz = _glesColor.xyz;
  lowp vec3 waveColor_6;
  highp vec3 waveMove_7;
  waveMove_7.y = 0.000000;
  highp vec4 tmpvar_8;
  tmpvar_8 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_8 + (tmpvar_10 * -0.161616)) + (tmpvar_11 * 0.00833330)) + ((tmpvar_11 * tmpvar_9) * -0.000198410));
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_7.x = dot (tmpvar_15, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_7.z = dot (tmpvar_15, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_4.xz = (_glesVertex.xz - (waveMove_7.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_16;
  tmpvar_16 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_14, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_6 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (vertex_4.xyz - _CameraPosition.xyz);
  highp float tmpvar_18;
  tmpvar_18 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_17, tmpvar_17))) * _CameraPosition.w), 0.000000, 1.00000);
  color_5.w = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = ((2.00000 * waveColor_6) * _glesColor.xyz);
  tmpvar_19.w = color_5.w;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = tmpvar_21;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  mediump vec3 x3_25;
  highp float vC_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_26 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_26);
  x3_25 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_25);
  shlight_1 = tmpvar_23;
  tmpvar_3 = shlight_1;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_4);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_19;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * vertex_4));
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 vertex_1;
  vertex_1.yw = _glesVertex.yw;
  lowp vec4 color_2;
  color_2.xyz = _glesColor.xyz;
  lowp vec3 waveColor_3;
  highp vec3 waveMove_4;
  waveMove_4.y = 0.000000;
  highp vec4 tmpvar_5;
  tmpvar_5 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_5);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_5 + (tmpvar_7 * -0.161616)) + (tmpvar_8 * 0.00833330)) + ((tmpvar_8 * tmpvar_6) * -0.000198410));
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_4.x = dot (tmpvar_12, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_4.z = dot (tmpvar_12, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_1.xz = (_glesVertex.xz - (waveMove_4.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_13;
  tmpvar_13 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_11, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_3 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (vertex_1.xyz - _CameraPosition.xyz);
  highp float tmpvar_15;
  tmpvar_15 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_14, tmpvar_14))) * _CameraPosition.w), 0.000000, 1.00000);
  color_2.w = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.xyz = ((2.00000 * waveColor_3) * _glesColor.xyz);
  tmpvar_16.w = color_2.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_1);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_16;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * vertex_1));
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 vertex_1;
  vertex_1.yw = _glesVertex.yw;
  lowp vec4 color_2;
  color_2.xyz = _glesColor.xyz;
  lowp vec3 waveColor_3;
  highp vec3 waveMove_4;
  waveMove_4.y = 0.000000;
  highp vec4 tmpvar_5;
  tmpvar_5 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_5);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_5 + (tmpvar_7 * -0.161616)) + (tmpvar_8 * 0.00833330)) + ((tmpvar_8 * tmpvar_6) * -0.000198410));
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_4.x = dot (tmpvar_12, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_4.z = dot (tmpvar_12, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_1.xz = (_glesVertex.xz - (waveMove_4.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_13;
  tmpvar_13 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_11, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_3 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (vertex_1.xyz - _CameraPosition.xyz);
  highp float tmpvar_15;
  tmpvar_15 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_14, tmpvar_14))) * _CameraPosition.w), 0.000000, 1.00000);
  color_2.w = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.xyz = ((2.00000 * waveColor_3) * _glesColor.xyz);
  tmpvar_16.w = color_2.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_1);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_16;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * vertex_1));
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 vertex_4;
  vertex_4.yw = _glesVertex.yw;
  lowp vec4 color_5;
  color_5.xyz = _glesColor.xyz;
  lowp vec3 waveColor_6;
  highp vec3 waveMove_7;
  waveMove_7.y = 0.000000;
  highp vec4 tmpvar_8;
  tmpvar_8 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_8 + (tmpvar_10 * -0.161616)) + (tmpvar_11 * 0.00833330)) + ((tmpvar_11 * tmpvar_9) * -0.000198410));
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_7.x = dot (tmpvar_15, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_7.z = dot (tmpvar_15, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_4.xz = (_glesVertex.xz - (waveMove_7.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_16;
  tmpvar_16 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_14, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_6 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (vertex_4.xyz - _CameraPosition.xyz);
  highp float tmpvar_18;
  tmpvar_18 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_17, tmpvar_17))) * _CameraPosition.w), 0.000000, 1.00000);
  color_5.w = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = ((2.00000 * waveColor_6) * _glesColor.xyz);
  tmpvar_19.w = color_5.w;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = tmpvar_21;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  mediump vec3 x3_25;
  highp float vC_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_26 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_26);
  x3_25 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_25);
  shlight_1 = tmpvar_23;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_Object2World * vertex_4).xyz;
  highp vec4 tmpvar_39;
  tmpvar_39 = (unity_4LightPosX0 - tmpvar_38.x);
  highp vec4 tmpvar_40;
  tmpvar_40 = (unity_4LightPosY0 - tmpvar_38.y);
  highp vec4 tmpvar_41;
  tmpvar_41 = (unity_4LightPosZ0 - tmpvar_38.z);
  highp vec4 tmpvar_42;
  tmpvar_42 = (((tmpvar_39 * tmpvar_39) + (tmpvar_40 * tmpvar_40)) + (tmpvar_41 * tmpvar_41));
  highp vec4 tmpvar_43;
  tmpvar_43 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_39 * tmpvar_21.x) + (tmpvar_40 * tmpvar_21.y)) + (tmpvar_41 * tmpvar_21.z)) * inversesqrt(tmpvar_42))) * (1.0/((1.00000 + (tmpvar_42 * unity_4LightAtten0)))));
  highp vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_43.x) + (unity_LightColor[1].xyz * tmpvar_43.y)) + (unity_LightColor[2].xyz * tmpvar_43.z)) + (unity_LightColor[3].xyz * tmpvar_43.w)));
  tmpvar_3 = tmpvar_44;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_4);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_19;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  highp vec4 vertex_4;
  vertex_4.yw = _glesVertex.yw;
  lowp vec4 color_5;
  color_5.xyz = _glesColor.xyz;
  lowp vec3 waveColor_6;
  highp vec3 waveMove_7;
  waveMove_7.y = 0.000000;
  highp vec4 tmpvar_8;
  tmpvar_8 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_9);
  highp vec4 tmpvar_12;
  tmpvar_12 = (((tmpvar_8 + (tmpvar_10 * -0.161616)) + (tmpvar_11 * 0.00833330)) + ((tmpvar_11 * tmpvar_9) * -0.000198410));
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_7.x = dot (tmpvar_15, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_7.z = dot (tmpvar_15, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_4.xz = (_glesVertex.xz - (waveMove_7.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_16;
  tmpvar_16 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_14, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_6 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (vertex_4.xyz - _CameraPosition.xyz);
  highp float tmpvar_18;
  tmpvar_18 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_17, tmpvar_17))) * _CameraPosition.w), 0.000000, 1.00000);
  color_5.w = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19.xyz = ((2.00000 * waveColor_6) * _glesColor.xyz);
  tmpvar_19.w = color_5.w;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_2 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = tmpvar_21;
  mediump vec3 tmpvar_23;
  mediump vec4 normal_24;
  normal_24 = tmpvar_22;
  mediump vec3 x3_25;
  highp float vC_26;
  mediump vec3 x2_27;
  mediump vec3 x1_28;
  highp float tmpvar_29;
  tmpvar_29 = dot (unity_SHAr, normal_24);
  x1_28.x = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHAg, normal_24);
  x1_28.y = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHAb, normal_24);
  x1_28.z = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = (normal_24.xyzz * normal_24.yzzx);
  highp float tmpvar_33;
  tmpvar_33 = dot (unity_SHBr, tmpvar_32);
  x2_27.x = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = dot (unity_SHBg, tmpvar_32);
  x2_27.y = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHBb, tmpvar_32);
  x2_27.z = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = ((normal_24.x * normal_24.x) - (normal_24.y * normal_24.y));
  vC_26 = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (unity_SHC.xyz * vC_26);
  x3_25 = tmpvar_37;
  tmpvar_23 = ((x1_28 + x2_27) + x3_25);
  shlight_1 = tmpvar_23;
  tmpvar_3 = shlight_1;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_Object2World * vertex_4).xyz;
  highp vec4 tmpvar_39;
  tmpvar_39 = (unity_4LightPosX0 - tmpvar_38.x);
  highp vec4 tmpvar_40;
  tmpvar_40 = (unity_4LightPosY0 - tmpvar_38.y);
  highp vec4 tmpvar_41;
  tmpvar_41 = (unity_4LightPosZ0 - tmpvar_38.z);
  highp vec4 tmpvar_42;
  tmpvar_42 = (((tmpvar_39 * tmpvar_39) + (tmpvar_40 * tmpvar_40)) + (tmpvar_41 * tmpvar_41));
  highp vec4 tmpvar_43;
  tmpvar_43 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_39 * tmpvar_21.x) + (tmpvar_40 * tmpvar_21.y)) + (tmpvar_41 * tmpvar_21.z)) * inversesqrt(tmpvar_42))) * (1.0/((1.00000 + (tmpvar_42 * unity_4LightAtten0)))));
  highp vec3 tmpvar_44;
  tmpvar_44 = (tmpvar_3 + ((((unity_LightColor[0].xyz * tmpvar_43.x) + (unity_LightColor[1].xyz * tmpvar_43.y)) + (unity_LightColor[2].xyz * tmpvar_43.z)) + (unity_LightColor[3].xyz * tmpvar_43.w)));
  tmpvar_3 = tmpvar_44;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_4);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_19;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * vertex_4));
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
  Tags { "LIGHTMODE"="ForwardAdd" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 vertex_3;
  vertex_3.yw = _glesVertex.yw;
  lowp vec4 color_4;
  color_4.xyz = _glesColor.xyz;
  lowp vec3 waveColor_5;
  highp vec3 waveMove_6;
  waveMove_6.y = 0.000000;
  highp vec4 tmpvar_7;
  tmpvar_7 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_7 + (tmpvar_9 * -0.161616)) + (tmpvar_10 * 0.00833330)) + ((tmpvar_10 * tmpvar_8) * -0.000198410));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_6.x = dot (tmpvar_14, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_6.z = dot (tmpvar_14, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_3.xz = (_glesVertex.xz - (waveMove_6.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_15;
  tmpvar_15 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_13, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (vertex_3.xyz - _CameraPosition.xyz);
  highp float tmpvar_17;
  tmpvar_17 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_16, tmpvar_16))) * _CameraPosition.w), 0.000000, 1.00000);
  color_4.w = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18.xyz = ((2.00000 * waveColor_5) * _glesColor.xyz);
  tmpvar_18.w = color_4.w;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_WorldSpaceLightPos0.xyz - (_Object2World * vertex_3).xyz);
  tmpvar_2 = tmpvar_21;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_3);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_18;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_3)).xyz;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 vertex_3;
  vertex_3.yw = _glesVertex.yw;
  lowp vec4 color_4;
  color_4.xyz = _glesColor.xyz;
  lowp vec3 waveColor_5;
  highp vec3 waveMove_6;
  waveMove_6.y = 0.000000;
  highp vec4 tmpvar_7;
  tmpvar_7 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_7 + (tmpvar_9 * -0.161616)) + (tmpvar_10 * 0.00833330)) + ((tmpvar_10 * tmpvar_8) * -0.000198410));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_6.x = dot (tmpvar_14, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_6.z = dot (tmpvar_14, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_3.xz = (_glesVertex.xz - (waveMove_6.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_15;
  tmpvar_15 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_13, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (vertex_3.xyz - _CameraPosition.xyz);
  highp float tmpvar_17;
  tmpvar_17 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_16, tmpvar_16))) * _CameraPosition.w), 0.000000, 1.00000);
  color_4.w = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18.xyz = ((2.00000 * waveColor_5) * _glesColor.xyz);
  tmpvar_18.w = color_4.w;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_21;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_3);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_18;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 vertex_3;
  vertex_3.yw = _glesVertex.yw;
  lowp vec4 color_4;
  color_4.xyz = _glesColor.xyz;
  lowp vec3 waveColor_5;
  highp vec3 waveMove_6;
  waveMove_6.y = 0.000000;
  highp vec4 tmpvar_7;
  tmpvar_7 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_7 + (tmpvar_9 * -0.161616)) + (tmpvar_10 * 0.00833330)) + ((tmpvar_10 * tmpvar_8) * -0.000198410));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_6.x = dot (tmpvar_14, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_6.z = dot (tmpvar_14, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_3.xz = (_glesVertex.xz - (waveMove_6.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_15;
  tmpvar_15 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_13, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (vertex_3.xyz - _CameraPosition.xyz);
  highp float tmpvar_17;
  tmpvar_17 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_16, tmpvar_16))) * _CameraPosition.w), 0.000000, 1.00000);
  color_4.w = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18.xyz = ((2.00000 * waveColor_5) * _glesColor.xyz);
  tmpvar_18.w = color_4.w;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_WorldSpaceLightPos0.xyz - (_Object2World * vertex_3).xyz);
  tmpvar_2 = tmpvar_21;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_3);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_18;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_3));
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 vertex_3;
  vertex_3.yw = _glesVertex.yw;
  lowp vec4 color_4;
  color_4.xyz = _glesColor.xyz;
  lowp vec3 waveColor_5;
  highp vec3 waveMove_6;
  waveMove_6.y = 0.000000;
  highp vec4 tmpvar_7;
  tmpvar_7 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_7 + (tmpvar_9 * -0.161616)) + (tmpvar_10 * 0.00833330)) + ((tmpvar_10 * tmpvar_8) * -0.000198410));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_6.x = dot (tmpvar_14, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_6.z = dot (tmpvar_14, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_3.xz = (_glesVertex.xz - (waveMove_6.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_15;
  tmpvar_15 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_13, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (vertex_3.xyz - _CameraPosition.xyz);
  highp float tmpvar_17;
  tmpvar_17 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_16, tmpvar_16))) * _CameraPosition.w), 0.000000, 1.00000);
  color_4.w = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18.xyz = ((2.00000 * waveColor_5) * _glesColor.xyz);
  tmpvar_18.w = color_4.w;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_WorldSpaceLightPos0.xyz - (_Object2World * vertex_3).xyz);
  tmpvar_2 = tmpvar_21;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_3);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_18;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_3)).xyz;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mediump vec3 tmpvar_2;
  highp vec4 vertex_3;
  vertex_3.yw = _glesVertex.yw;
  lowp vec4 color_4;
  color_4.xyz = _glesColor.xyz;
  lowp vec3 waveColor_5;
  highp vec3 waveMove_6;
  waveMove_6.y = 0.000000;
  highp vec4 tmpvar_7;
  tmpvar_7 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_7);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_8);
  highp vec4 tmpvar_11;
  tmpvar_11 = (((tmpvar_7 + (tmpvar_9 * -0.161616)) + (tmpvar_10 * 0.00833330)) + ((tmpvar_10 * tmpvar_8) * -0.000198410));
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_6.x = dot (tmpvar_14, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_6.z = dot (tmpvar_14, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_3.xz = (_glesVertex.xz - (waveMove_6.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_15;
  tmpvar_15 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_13, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (vertex_3.xyz - _CameraPosition.xyz);
  highp float tmpvar_17;
  tmpvar_17 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_16, tmpvar_16))) * _CameraPosition.w), 0.000000, 1.00000);
  color_4.w = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18.xyz = ((2.00000 * waveColor_5) * _glesColor.xyz);
  tmpvar_18.w = color_4.w;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _WorldSpaceLightPos0.xyz;
  tmpvar_2 = tmpvar_21;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_3);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_18;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * vertex_3)).xy;
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
  Tags { "LIGHTMODE"="SHADOWCASTER" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 vertex_2;
  vertex_2.yw = _glesVertex.yw;
  lowp vec4 color_3;
  color_3.xyz = _glesColor.xyz;
  lowp vec3 waveColor_4;
  highp vec3 waveMove_5;
  waveMove_5.y = 0.000000;
  highp vec4 tmpvar_6;
  tmpvar_6 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (((tmpvar_6 + (tmpvar_8 * -0.161616)) + (tmpvar_9 * 0.00833330)) + ((tmpvar_9 * tmpvar_7) * -0.000198410));
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_5.x = dot (tmpvar_13, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_5.z = dot (tmpvar_13, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_2.xz = (_glesVertex.xz - (waveMove_5.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_14;
  tmpvar_14 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_12, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_4 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (vertex_2.xyz - _CameraPosition.xyz);
  highp float tmpvar_16;
  tmpvar_16 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_15, tmpvar_15))) * _CameraPosition.w), 0.000000, 1.00000);
  color_3.w = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17.xyz = ((2.00000 * waveColor_4) * _glesColor.xyz);
  tmpvar_17.w = color_3.w;
  highp vec4 tmpvar_18;
  tmpvar_18 = (gl_ModelViewProjectionMatrix * vertex_2);
  tmpvar_1.xyw = tmpvar_18.xyw;
  tmpvar_1.z = (tmpvar_18.z + unity_LightShadowBias.x);
  tmpvar_1.z = mix (tmpvar_1.z, max (tmpvar_1.z, (tmpvar_18.w * -1.00000)), unity_LightShadowBias.y);
  gl_Position = tmpvar_1;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_17;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 vertex_1;
  vertex_1.yw = _glesVertex.yw;
  lowp vec4 color_2;
  color_2.xyz = _glesColor.xyz;
  lowp vec3 waveColor_3;
  highp vec3 waveMove_4;
  waveMove_4.y = 0.000000;
  highp vec4 tmpvar_5;
  tmpvar_5 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_5);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (((tmpvar_5 + (tmpvar_7 * -0.161616)) + (tmpvar_8 * 0.00833330)) + ((tmpvar_8 * tmpvar_6) * -0.000198410));
  highp vec4 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * tmpvar_9);
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_4.x = dot (tmpvar_12, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_4.z = dot (tmpvar_12, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_1.xz = (_glesVertex.xz - (waveMove_4.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_13;
  tmpvar_13 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_11, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_3 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = (vertex_1.xyz - _CameraPosition.xyz);
  highp float tmpvar_15;
  tmpvar_15 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_14, tmpvar_14))) * _CameraPosition.w), 0.000000, 1.00000);
  color_2.w = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.xyz = ((2.00000 * waveColor_3) * _glesColor.xyz);
  tmpvar_16.w = color_2.w;
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_1);
  xlv_TEXCOORD0 = ((_Object2World * vertex_1).xyz - _LightPositionRange.xyz);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_16;
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
  Tags { "LIGHTMODE"="SHADOWCOLLECTOR" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 vertex_2;
  vertex_2.yw = _glesVertex.yw;
  lowp vec4 color_3;
  color_3.xyz = _glesColor.xyz;
  lowp vec3 waveColor_4;
  highp vec3 waveMove_5;
  waveMove_5.y = 0.000000;
  highp vec4 tmpvar_6;
  tmpvar_6 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (((tmpvar_6 + (tmpvar_8 * -0.161616)) + (tmpvar_9 * 0.00833330)) + ((tmpvar_9 * tmpvar_7) * -0.000198410));
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_5.x = dot (tmpvar_13, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_5.z = dot (tmpvar_13, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_2.xz = (_glesVertex.xz - (waveMove_5.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_14;
  tmpvar_14 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_12, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_4 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (vertex_2.xyz - _CameraPosition.xyz);
  highp float tmpvar_16;
  tmpvar_16 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_15, tmpvar_15))) * _CameraPosition.w), 0.000000, 1.00000);
  color_3.w = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17.xyz = ((2.00000 * waveColor_4) * _glesColor.xyz);
  tmpvar_17.w = color_3.w;
  highp vec4 tmpvar_18;
  tmpvar_18 = (_Object2World * vertex_2);
  tmpvar_1.xyz = tmpvar_18.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * vertex_2).z);
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_2);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_18).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_18).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_18).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_18).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_17;
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
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 vertex_2;
  vertex_2.yw = _glesVertex.yw;
  lowp vec4 color_3;
  color_3.xyz = _glesColor.xyz;
  lowp vec3 waveColor_4;
  highp vec3 waveMove_5;
  waveMove_5.y = 0.000000;
  highp vec4 tmpvar_6;
  tmpvar_6 = ((fract((((_glesVertex.x * (vec4(0.0120000, 0.0200000, 0.0600000, 0.0240000) * _WaveAndDistance.y)) + (_glesVertex.z * (vec4(0.00600000, 0.0200000, 0.0200000, 0.0500000) * _WaveAndDistance.y))) + (_WaveAndDistance.x * vec4(1.20000, 2.00000, 1.60000, 4.80000)))) * 6.40885) - 3.14159);
  highp vec4 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * tmpvar_6);
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * tmpvar_6);
  highp vec4 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * tmpvar_7);
  highp vec4 tmpvar_10;
  tmpvar_10 = (((tmpvar_6 + (tmpvar_8 * -0.161616)) + (tmpvar_9 * 0.00833330)) + ((tmpvar_9 * tmpvar_7) * -0.000198410));
  highp vec4 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * tmpvar_10);
  highp vec4 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (tmpvar_12 * (_glesColor.w * _WaveAndDistance.z));
  waveMove_5.x = dot (tmpvar_13, vec4(0.0240000, 0.0400000, -0.120000, 0.0960000));
  waveMove_5.z = dot (tmpvar_13, vec4(0.00600000, 0.0200000, -0.0200000, 0.100000));
  vertex_2.xz = (_glesVertex.xz - (waveMove_5.xz * _WaveAndDistance.z));
  highp vec3 tmpvar_14;
  tmpvar_14 = mix (vec3(0.500000, 0.500000, 0.500000), _WavingTint.xyz, vec3((dot (tmpvar_12, normalize(vec4(1.00000, 1.00000, 0.400000, 0.200000))) * 0.700000)));
  waveColor_4 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (vertex_2.xyz - _CameraPosition.xyz);
  highp float tmpvar_16;
  tmpvar_16 = clamp (((2.00000 * (_WaveAndDistance.w - dot (tmpvar_15, tmpvar_15))) * _CameraPosition.w), 0.000000, 1.00000);
  color_3.w = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17.xyz = ((2.00000 * waveColor_4) * _glesColor.xyz);
  tmpvar_17.w = color_3.w;
  highp vec4 tmpvar_18;
  tmpvar_18 = (_Object2World * vertex_2);
  tmpvar_1.xyz = tmpvar_18.xyz;
  tmpvar_1.w = -((gl_ModelViewMatrix * vertex_2).z);
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_2);
  xlv_TEXCOORD0 = (unity_World2Shadow[0] * tmpvar_18).xyz;
  xlv_TEXCOORD1 = (unity_World2Shadow[1] * tmpvar_18).xyz;
  xlv_TEXCOORD2 = (unity_World2Shadow[2] * tmpvar_18).xyz;
  xlv_TEXCOORD3 = (unity_World2Shadow[3] * tmpvar_18).xyz;
  xlv_TEXCOORD4 = tmpvar_1;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR0 = tmpvar_17;
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
 LOD 200
 Tags { "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
 Pass {
  Tags { "LIGHTMODE"="Vertex" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
  Lighting On
  Material {
   Ambient (1,1,1,1)
   Diffuse (1,1,1,1)
  }
  Cull Off
  AlphaTest Greater [_Cutoff]
  ColorMask RGB
  ColorMaterial AmbientAndDiffuse
  SetTexture [_MainTex] { combine texture * primary double, texture alpha }
 }
 Pass {
  Tags { "LIGHTMODE"="VertexLMRGBM" "QUEUE"="Geometry+200" "IGNOREPROJECTOR"="True" "RenderType"="Grass" }
  BindChannels {
   Bind "vertex", Vertex
   Bind "texcoord1", TexCoord0
   Bind "texcoord", TexCoord1
  }
  Cull Off
  AlphaTest Greater [_Cutoff]
  ColorMask RGB
  SetTexture [unity_Lightmap] { Matrix [unity_LightmapMatrix] combine texture * texture alpha double }
  SetTexture [_MainTex] { combine texture * previous quad, texture alpha }
 }
}
Fallback Off
}