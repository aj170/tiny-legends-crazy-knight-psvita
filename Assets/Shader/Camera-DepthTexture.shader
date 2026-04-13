›”Shader "Hidden/Camera-DepthTexture" {
Properties {
 _MainTex ("", 2D) = "white" {}
 _Cutoff ("", Float) = 0.5
 _Color ("", Color) = (1,1,1,1)
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "RenderType"="Opaque" }
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;


attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
}



#endif
#ifdef FRAGMENT

void main ()
{
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="TransparentCutout" }
 Pass {
  Tags { "RenderType"="TransparentCutout" }
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
uniform lowp vec4 _Color;
void main ()
{
  lowp float x_1;
  x_1 = ((texture2D (_MainTex, xlv_TEXCOORD0).w * _Color.w) - _Cutoff);
  if ((x_1 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="TreeBark" }
 Pass {
  Tags { "RenderType"="TreeBark" }
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;


uniform highp vec4 _Wind;
uniform highp vec4 _Time;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = _glesVertex.w;
  tmpvar_1.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 pos_2;
  pos_2.w = tmpvar_1.w;
  highp vec3 bend_3;
  vec4 v_4;
  v_4.x = _Object2World[0].w;
  v_4.y = _Object2World[1].w;
  v_4.z = _Object2World[2].w;
  v_4.w = _Object2World[3].w;
  highp float tmpvar_5;
  tmpvar_5 = (dot (v_4.xyz, vec3(1.00000, 1.00000, 1.00000)) + _glesColor.x);
  highp vec2 tmpvar_6;
  tmpvar_6.x = dot (tmpvar_1.xyz, vec3((_glesColor.y + tmpvar_5)));
  tmpvar_6.y = tmpvar_5;
  highp vec4 tmpvar_7;
  tmpvar_7 = abs(((fract((((fract(((_Time.yy + tmpvar_6).xxyy * vec4(1.97500, 0.793000, 0.375000, 0.193000))) * 2.00000) - 1.00000) + 0.500000)) * 2.00000) - 1.00000));
  highp vec4 tmpvar_8;
  tmpvar_8 = ((tmpvar_7 * tmpvar_7) * (3.00000 - (2.00000 * tmpvar_7)));
  highp vec2 tmpvar_9;
  tmpvar_9 = (tmpvar_8.xz + tmpvar_8.yw);
  bend_3.xz = ((_glesColor.y * 0.100000) * _glesNormal).xz;
  bend_3.y = (_glesMultiTexCoord1.y * 0.300000);
  pos_2.xyz = (tmpvar_1.xyz + (((tmpvar_9.xyx * bend_3) + ((_Wind.xyz * tmpvar_9.y) * _glesMultiTexCoord1.y)) * _Wind.w));
  pos_2.xyz = (pos_2.xyz + (_glesMultiTexCoord1.x * _Wind.xyz));
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.00000;
  tmpvar_10.xyz = mix ((pos_2.xyz - ((dot (_SquashPlaneNormal.xyz, pos_2.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_2.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_10);
}



#endif
#ifdef FRAGMENT

void main ()
{
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="TreeLeaf" }
 Pass {
  Tags { "RenderType"="TreeLeaf" }
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec2 xlv_TEXCOORD0;


uniform highp vec4 _Wind;
uniform highp vec4 _Time;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp float tmpvar_2;
  tmpvar_2 = (1.00000 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.000000;
  tmpvar_3.xyz = _glesNormal;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.000000, 0.000000);
  tmpvar_4.xy = _glesNormal.xy;
  highp vec4 tmpvar_5;
  tmpvar_5 = (_glesVertex + ((tmpvar_4 * gl_ModelViewMatrixInverseTranspose) * tmpvar_2));
  tmpvar_1.w = tmpvar_5.w;
  tmpvar_1.xyz = (tmpvar_5.xyz * _Scale.xyz);
  highp vec4 pos_6;
  pos_6.w = tmpvar_1.w;
  highp vec3 bend_7;
  vec4 v_8;
  v_8.x = _Object2World[0].w;
  v_8.y = _Object2World[1].w;
  v_8.z = _Object2World[2].w;
  v_8.w = _Object2World[3].w;
  highp float tmpvar_9;
  tmpvar_9 = (dot (v_8.xyz, vec3(1.00000, 1.00000, 1.00000)) + _glesColor.x);
  highp vec2 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_1.xyz, vec3((_glesColor.y + tmpvar_9)));
  tmpvar_10.y = tmpvar_9;
  highp vec4 tmpvar_11;
  tmpvar_11 = abs(((fract((((fract(((_Time.yy + tmpvar_10).xxyy * vec4(1.97500, 0.793000, 0.375000, 0.193000))) * 2.00000) - 1.00000) + 0.500000)) * 2.00000) - 1.00000));
  highp vec4 tmpvar_12;
  tmpvar_12 = ((tmpvar_11 * tmpvar_11) * (3.00000 - (2.00000 * tmpvar_11)));
  highp vec2 tmpvar_13;
  tmpvar_13 = (tmpvar_12.xz + tmpvar_12.yw);
  bend_7.xz = ((_glesColor.y * 0.100000) * mix (_glesNormal, normalize((tmpvar_3 * gl_ModelViewMatrixInverseTranspose)).xyz, vec3(tmpvar_2))).xz;
  bend_7.y = (_glesMultiTexCoord1.y * 0.300000);
  pos_6.xyz = (tmpvar_1.xyz + (((tmpvar_13.xyx * bend_7) + ((_Wind.xyz * tmpvar_13.y) * _glesMultiTexCoord1.y)) * _Wind.w));
  pos_6.xyz = (pos_6.xyz + (_glesMultiTexCoord1.x * _Wind.xyz));
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = mix ((pos_6.xyz - ((dot (_SquashPlaneNormal.xyz, pos_6.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_6.xyz, vec3(_SquashAmount));
  tmpvar_1 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_14);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  mediump float alpha_1;
  lowp float tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0).w;
  alpha_1 = tmpvar_2;
  mediump float x_3;
  x_3 = (alpha_1 - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="TreeOpaque" }
 Pass {
  Tags { "RenderType"="TreeOpaque" }
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;


uniform highp mat4 _TerrainEngineBendTree;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1.w = _glesVertex.w;
  pos_1.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.000000;
  tmpvar_2.xyz = pos_1.xyz;
  pos_1.xyz = mix (pos_1.xyz, (_TerrainEngineBendTree * tmpvar_2).xyz, _glesColor.www);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.00000;
  tmpvar_3.xyz = mix ((pos_1.xyz - ((dot (_SquashPlaneNormal.xyz, pos_1.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_1.xyz, vec3(_SquashAmount));
  pos_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_3);
}



#endif
#ifdef FRAGMENT

void main ()
{
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="TreeTransparentCutout" }
 Pass {
  Tags { "RenderType"="TreeTransparentCutout" }
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

varying highp vec2 xlv_TEXCOORD0;

uniform highp mat4 _TerrainEngineBendTree;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 pos_1;
  pos_1.w = _glesVertex.w;
  pos_1.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 tmpvar_2;
  tmpvar_2.w = 0.000000;
  tmpvar_2.xyz = pos_1.xyz;
  pos_1.xyz = mix (pos_1.xyz, (_TerrainEngineBendTree * tmpvar_2).xyz, _glesColor.www);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.00000;
  tmpvar_3.xyz = mix ((pos_1.xyz - ((dot (_SquashPlaneNormal.xyz, pos_1.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_1.xyz, vec3(_SquashAmount));
  pos_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_3);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  mediump float alpha_1;
  lowp float tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0).w;
  alpha_1 = tmpvar_2;
  mediump float x_3;
  x_3 = (alpha_1 - _Cutoff);
  if ((x_3 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="TreeBillboard" }
 Pass {
  Tags { "RenderType"="TreeBillboard" }
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

varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _TreeBillboardDistances;
uniform highp vec4 _TreeBillboardCameraUp;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardCameraFront;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 pos_2;
  pos_2 = _glesVertex;
  highp vec2 offset_3;
  offset_3 = _glesMultiTexCoord1.xy;
  highp float offsetz_4;
  offsetz_4 = _glesMultiTexCoord0.y;
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz - _TreeBillboardCameraPos.xyz);
  highp float tmpvar_6;
  tmpvar_6 = dot (tmpvar_5, tmpvar_5);
  if ((tmpvar_6 > _TreeBillboardDistances.x)) {
    offsetz_4 = 0.000000;
    offset_3 = vec2(0.000000, 0.000000);
  };
  pos_2.xyz = (_glesVertex.xyz + (_TreeBillboardCameraRight * offset_3.x));
  pos_2.xyz = (pos_2.xyz + (_TreeBillboardCameraUp.xyz * mix (offset_3.y, offsetz_4, _TreeBillboardCameraPos.w)));
  pos_2.xyz = (pos_2.xyz + ((_TreeBillboardCameraFront.xyz * abs(offset_3.x)) * _TreeBillboardCameraUp.w));
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = float((_glesMultiTexCoord0.y > 0.000000));
  gl_Position = (gl_ModelViewProjectionMatrix * pos_2);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp float x_1;
  x_1 = (texture2D (_MainTex, xlv_TEXCOORD0).w - 0.00100000);
  if ((x_1 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="GrassBillboard" }
 Pass {
  Tags { "RenderType"="GrassBillboard" }
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

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
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
  xlv_COLOR = tmpvar_20;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp float x_1;
  x_1 = ((texture2D (_MainTex, xlv_TEXCOORD0).w * xlv_COLOR.w) - _Cutoff);
  if ((x_1 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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
SubShader { 
 Tags { "RenderType"="Grass" }
 Pass {
  Tags { "RenderType"="Grass" }
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

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;

uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
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
  xlv_COLOR = tmpvar_16;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp float x_1;
  x_1 = ((texture2D (_MainTex, xlv_TEXCOORD0).w * xlv_COLOR.w) - _Cutoff);
  if ((x_1 < 0.000000)) {
    discard;
  };
  gl_FragData[0] = vec4(0.000000, 0.000000, 0.000000, 0.000000);
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