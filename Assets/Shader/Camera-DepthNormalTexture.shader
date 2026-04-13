‚ðShader "Hidden/Camera-DepthNormalTexture" {
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
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD0;



uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_2[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_2[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_2 * normalize(_glesNormal));
  tmpvar_1.w = -(((gl_ModelViewMatrix * _glesVertex).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 enc_2;
  enc_2.xy = ((((xlv_TEXCOORD0.xy / (xlv_TEXCOORD0.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD0.w));
  enc_3.y = tmpvar_4.y;
  enc_3.x = (tmpvar_4.x - (tmpvar_4.y * 0.00392157));
  enc_2.zw = enc_3;
  tmpvar_1 = enc_2;
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
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;



uniform highp vec4 _ProjectionParams;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_2[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_2[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_2 * normalize(_glesNormal));
  tmpvar_1.w = -(((gl_ModelViewMatrix * _glesVertex).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp float x_2;
  x_2 = ((texture2D (_MainTex, xlv_TEXCOORD0).w * _Color.w) - _Cutoff);
  if ((x_2 < 0.000000)) {
    discard;
  };
  highp vec4 enc_3;
  enc_3.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_4.y = tmpvar_5.y;
  enc_4.x = (tmpvar_5.x - (tmpvar_5.y * 0.00392157));
  enc_3.zw = enc_4;
  tmpvar_1 = enc_3;
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
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;



uniform highp vec4 _Wind;
uniform highp vec4 _Time;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = _glesVertex.w;
  tmpvar_2.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 pos_3;
  pos_3.w = tmpvar_2.w;
  highp vec3 bend_4;
  vec4 v_5;
  v_5.x = _Object2World[0].w;
  v_5.y = _Object2World[1].w;
  v_5.z = _Object2World[2].w;
  v_5.w = _Object2World[3].w;
  highp float tmpvar_6;
  tmpvar_6 = (dot (v_5.xyz, vec3(1.00000, 1.00000, 1.00000)) + _glesColor.x);
  highp vec2 tmpvar_7;
  tmpvar_7.x = dot (tmpvar_2.xyz, vec3((_glesColor.y + tmpvar_6)));
  tmpvar_7.y = tmpvar_6;
  highp vec4 tmpvar_8;
  tmpvar_8 = abs(((fract((((fract(((_Time.yy + tmpvar_7).xxyy * vec4(1.97500, 0.793000, 0.375000, 0.193000))) * 2.00000) - 1.00000) + 0.500000)) * 2.00000) - 1.00000));
  highp vec4 tmpvar_9;
  tmpvar_9 = ((tmpvar_8 * tmpvar_8) * (3.00000 - (2.00000 * tmpvar_8)));
  highp vec2 tmpvar_10;
  tmpvar_10 = (tmpvar_9.xz + tmpvar_9.yw);
  bend_4.xz = ((_glesColor.y * 0.100000) * _glesNormal).xz;
  bend_4.y = (_glesMultiTexCoord1.y * 0.300000);
  pos_3.xyz = (tmpvar_2.xyz + (((tmpvar_10.xyx * bend_4) + ((_Wind.xyz * tmpvar_10.y) * _glesMultiTexCoord1.y)) * _Wind.w));
  pos_3.xyz = (pos_3.xyz + (_glesMultiTexCoord1.x * _Wind.xyz));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.00000;
  tmpvar_11.xyz = mix ((pos_3.xyz - ((dot (_SquashPlaneNormal.xyz, pos_3.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_3.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_11;
  mat3 tmpvar_12;
  tmpvar_12[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_12[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_12[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_12 * normalize(_glesNormal));
  tmpvar_1.w = -(((gl_ModelViewMatrix * tmpvar_11).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 enc_2;
  enc_2.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_3.y = tmpvar_4.y;
  enc_3.x = (tmpvar_4.x - (tmpvar_4.y * 0.00392157));
  enc_2.zw = enc_3;
  tmpvar_1 = enc_2;
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;



uniform highp vec4 _Wind;
uniform highp vec4 _Time;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp vec4 _ProjectionParams;
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
  highp vec4 tmpvar_2;
  highp float tmpvar_3;
  tmpvar_3 = (1.00000 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.000000;
  tmpvar_4.xyz = _glesNormal;
  highp vec4 tmpvar_5;
  tmpvar_5.zw = vec2(0.000000, 0.000000);
  tmpvar_5.xy = _glesNormal.xy;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_glesVertex + ((tmpvar_5 * gl_ModelViewMatrixInverseTranspose) * tmpvar_3));
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (_glesNormal, normalize((tmpvar_4 * gl_ModelViewMatrixInverseTranspose)).xyz, vec3(tmpvar_3));
  tmpvar_2.w = tmpvar_6.w;
  tmpvar_2.xyz = (tmpvar_6.xyz * _Scale.xyz);
  highp vec4 pos_8;
  pos_8.w = tmpvar_2.w;
  highp vec3 bend_9;
  vec4 v_10;
  v_10.x = _Object2World[0].w;
  v_10.y = _Object2World[1].w;
  v_10.z = _Object2World[2].w;
  v_10.w = _Object2World[3].w;
  highp float tmpvar_11;
  tmpvar_11 = (dot (v_10.xyz, vec3(1.00000, 1.00000, 1.00000)) + _glesColor.x);
  highp vec2 tmpvar_12;
  tmpvar_12.x = dot (tmpvar_2.xyz, vec3((_glesColor.y + tmpvar_11)));
  tmpvar_12.y = tmpvar_11;
  highp vec4 tmpvar_13;
  tmpvar_13 = abs(((fract((((fract(((_Time.yy + tmpvar_12).xxyy * vec4(1.97500, 0.793000, 0.375000, 0.193000))) * 2.00000) - 1.00000) + 0.500000)) * 2.00000) - 1.00000));
  highp vec4 tmpvar_14;
  tmpvar_14 = ((tmpvar_13 * tmpvar_13) * (3.00000 - (2.00000 * tmpvar_13)));
  highp vec2 tmpvar_15;
  tmpvar_15 = (tmpvar_14.xz + tmpvar_14.yw);
  bend_9.xz = ((_glesColor.y * 0.100000) * tmpvar_7).xz;
  bend_9.y = (_glesMultiTexCoord1.y * 0.300000);
  pos_8.xyz = (tmpvar_2.xyz + (((tmpvar_15.xyx * bend_9) + ((_Wind.xyz * tmpvar_15.y) * _glesMultiTexCoord1.y)) * _Wind.w));
  pos_8.xyz = (pos_8.xyz + (_glesMultiTexCoord1.x * _Wind.xyz));
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.00000;
  tmpvar_16.xyz = mix ((pos_8.xyz - ((dot (_SquashPlaneNormal.xyz, pos_8.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_8.xyz, vec3(_SquashAmount));
  tmpvar_2 = tmpvar_16;
  mat3 tmpvar_17;
  tmpvar_17[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_17[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_17[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_17 * normalize(tmpvar_7));
  tmpvar_1.w = -(((gl_ModelViewMatrix * tmpvar_16).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_16);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float alpha_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0).w;
  alpha_2 = tmpvar_3;
  mediump float x_4;
  x_4 = (alpha_2 - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  highp vec4 enc_5;
  enc_5.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_6.y = tmpvar_7.y;
  enc_6.x = (tmpvar_7.x - (tmpvar_7.y * 0.00392157));
  enc_5.zw = enc_6;
  tmpvar_1 = enc_5;
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
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD0;



uniform highp mat4 _TerrainEngineBendTree;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 pos_2;
  pos_2.w = _glesVertex.w;
  pos_2.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.000000;
  tmpvar_3.xyz = pos_2.xyz;
  pos_2.xyz = mix (pos_2.xyz, (_TerrainEngineBendTree * tmpvar_3).xyz, _glesColor.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.00000;
  tmpvar_4.xyz = mix ((pos_2.xyz - ((dot (_SquashPlaneNormal.xyz, pos_2.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_2.xyz, vec3(_SquashAmount));
  pos_2 = tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_5[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_5[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_5 * normalize(_glesNormal));
  tmpvar_1.w = -(((gl_ModelViewMatrix * tmpvar_4).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 enc_2;
  enc_2.xy = ((((xlv_TEXCOORD0.xy / (xlv_TEXCOORD0.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_3;
  highp vec2 tmpvar_4;
  tmpvar_4 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD0.w));
  enc_3.y = tmpvar_4.y;
  enc_3.x = (tmpvar_4.x - (tmpvar_4.y * 0.00392157));
  enc_2.zw = enc_3;
  tmpvar_1 = enc_2;
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
SubShader { 
 Tags { "RenderType"="TreeTransparentCutout" }
 Pass {
  Tags { "RenderType"="TreeTransparentCutout" }
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;



uniform highp mat4 _TerrainEngineBendTree;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 pos_2;
  pos_2.w = _glesVertex.w;
  pos_2.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.000000;
  tmpvar_3.xyz = pos_2.xyz;
  pos_2.xyz = mix (pos_2.xyz, (_TerrainEngineBendTree * tmpvar_3).xyz, _glesColor.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.00000;
  tmpvar_4.xyz = mix ((pos_2.xyz - ((dot (_SquashPlaneNormal.xyz, pos_2.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_2.xyz, vec3(_SquashAmount));
  pos_2 = tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_5[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_5[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_5 * normalize(_glesNormal));
  tmpvar_1.w = -(((gl_ModelViewMatrix * tmpvar_4).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump float alpha_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD0).w;
  alpha_2 = tmpvar_3;
  mediump float x_4;
  x_4 = (alpha_2 - _Cutoff);
  if ((x_4 < 0.000000)) {
    discard;
  };
  highp vec4 enc_5;
  enc_5.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_6.y = tmpvar_7.y;
  enc_6.x = (tmpvar_7.x - (tmpvar_7.y * 0.00392157));
  enc_5.zw = enc_6;
  tmpvar_1 = enc_5;
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
 Pass {
  Tags { "RenderType"="TreeTransparentCutout" }
  Cull Front
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;



uniform highp mat4 _TerrainEngineBendTree;
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec4 _Scale;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 pos_2;
  pos_2.w = _glesVertex.w;
  pos_2.xyz = (_glesVertex.xyz * _Scale.xyz);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 0.000000;
  tmpvar_3.xyz = pos_2.xyz;
  pos_2.xyz = mix (pos_2.xyz, (_TerrainEngineBendTree * tmpvar_3).xyz, _glesColor.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.00000;
  tmpvar_4.xyz = mix ((pos_2.xyz - ((dot (_SquashPlaneNormal.xyz, pos_2.xyz) + _SquashPlaneNormal.w) * _SquashPlaneNormal.xyz)), pos_2.xyz, vec3(_SquashAmount));
  pos_2 = tmpvar_4;
  mat3 tmpvar_5;
  tmpvar_5[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_5[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_5[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = -((tmpvar_5 * normalize(_glesNormal)));
  tmpvar_1.w = -(((gl_ModelViewMatrix * tmpvar_4).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, xlv_TEXCOORD0).w - _Cutoff);
  if ((x_2 < 0.000000)) {
    discard;
  };
  highp vec4 enc_3;
  enc_3.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_4.y = tmpvar_5.y;
  enc_4.x = (tmpvar_5.x - (tmpvar_5.y * 0.00392157));
  enc_3.zw = enc_4;
  tmpvar_1 = enc_3;
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
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;


uniform highp vec4 _TreeBillboardDistances;
uniform highp vec4 _TreeBillboardCameraUp;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 pos_3;
  pos_3 = _glesVertex;
  highp vec2 offset_4;
  offset_4 = _glesMultiTexCoord1.xy;
  highp float offsetz_5;
  offsetz_5 = _glesMultiTexCoord0.y;
  highp vec3 tmpvar_6;
  tmpvar_6 = (_glesVertex.xyz - _TreeBillboardCameraPos.xyz);
  highp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_6, tmpvar_6);
  if ((tmpvar_7 > _TreeBillboardDistances.x)) {
    offsetz_5 = 0.000000;
    offset_4 = vec2(0.000000, 0.000000);
  };
  pos_3.xyz = (_glesVertex.xyz + (_TreeBillboardCameraRight * offset_4.x));
  pos_3.xyz = (pos_3.xyz + (_TreeBillboardCameraUp.xyz * mix (offset_4.y, offsetz_5, _TreeBillboardCameraPos.w)));
  pos_3.xyz = (pos_3.xyz + ((_TreeBillboardCameraFront.xyz * abs(offset_4.x)) * _TreeBillboardCameraUp.w));
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = float((_glesMultiTexCoord0.y > 0.000000));
  tmpvar_2.xyz = vec3(0.000000, 0.000000, 1.00000);
  tmpvar_2.w = -(((gl_ModelViewMatrix * pos_3).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * pos_3);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, xlv_TEXCOORD0).w - 0.00100000);
  if ((x_2 < 0.000000)) {
    discard;
  };
  highp vec4 enc_3;
  enc_3.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_4.y = tmpvar_5.y;
  enc_4.x = (tmpvar_5.x - (tmpvar_5.y * 0.00392157));
  enc_3.zw = enc_4;
  tmpvar_1 = enc_3;
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
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;



uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp vec4 _ProjectionParams;
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
  mat3 tmpvar_22;
  tmpvar_22[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_22[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_22[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_22 * _glesNormal);
  tmpvar_1.w = -(((gl_ModelViewMatrix * vertex_6).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_6);
  xlv_COLOR = tmpvar_21;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp float x_2;
  x_2 = ((texture2D (_MainTex, xlv_TEXCOORD0).w * xlv_COLOR.w) - _Cutoff);
  if ((x_2 < 0.000000)) {
    discard;
  };
  highp vec4 enc_3;
  enc_3.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_4.y = tmpvar_5.y;
  enc_4.x = (tmpvar_5.x - (tmpvar_5.y * 0.00392157));
  enc_3.zw = enc_4;
  tmpvar_1 = enc_3;
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
#define gl_ModelViewMatrixInverseTranspose glstate_matrix_invtrans_modelview0
uniform mat4 glstate_matrix_invtrans_modelview0;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;



uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _CameraPosition;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
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
  mat3 tmpvar_18;
  tmpvar_18[0] = gl_ModelViewMatrixInverseTranspose[0].xyz;
  tmpvar_18[1] = gl_ModelViewMatrixInverseTranspose[1].xyz;
  tmpvar_18[2] = gl_ModelViewMatrixInverseTranspose[2].xyz;
  tmpvar_1.xyz = (tmpvar_18 * normalize(_glesNormal));
  tmpvar_1.w = -(((gl_ModelViewMatrix * vertex_2).z * _ProjectionParams.w));
  gl_Position = (gl_ModelViewProjectionMatrix * vertex_2);
  xlv_COLOR = tmpvar_17;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp float x_2;
  x_2 = ((texture2D (_MainTex, xlv_TEXCOORD0).w * xlv_COLOR.w) - _Cutoff);
  if ((x_2 < 0.000000)) {
    discard;
  };
  highp vec4 enc_3;
  enc_3.xy = ((((xlv_TEXCOORD1.xy / (xlv_TEXCOORD1.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
  highp vec2 enc_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = fract((vec2(1.00000, 255.000) * xlv_TEXCOORD1.w));
  enc_4.y = tmpvar_5.y;
  enc_4.x = (tmpvar_5.x - (tmpvar_5.y * 0.00392157));
  enc_3.zw = enc_4;
  tmpvar_1 = enc_3;
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