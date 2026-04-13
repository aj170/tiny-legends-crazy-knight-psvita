­²Shader "Self-Illumin/Parallax Specular" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
 _Shininess ("Shininess", Range(0.01,1)) = 0.078125
 _Parallax ("Height", Range(0.005,0.08)) = 0.02
 _MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
 _Illum ("Illumin (A)", 2D) = "white" {}
 _BumpMap ("Normalmap", 2D) = "bump" {}
 _ParallaxMap ("Heightmap (A)", 2D) = "black" {}
 _EmissionLM ("Emission (Lightmapper)", Float) = 0
}
SubShader { 
 LOD 600
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "FORWARD"
  Tags { "LIGHTMODE"="ForwardBase" "RenderType"="Opaque" }
Program "vp" {
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  mediump vec3 x3_16;
  highp float vC_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_17 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_17);
  x3_16 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_16);
  shlight_3 = tmpvar_14;
  tmpvar_6 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.zw + tmpvar_4);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_10);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_11).xyz * 2.00000) - 1.00000);
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_17;
  viewDir_17 = tmpvar_16;
  lowp vec4 c_18;
  highp float nh_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.000000, dot (tmpvar_15, xlv_TEXCOORD3));
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (tmpvar_15, normalize((xlv_TEXCOORD3 + viewDir_17))));
  nh_19 = tmpvar_21;
  mediump float arg1_22;
  arg1_22 = (_Shininess * 128.000);
  highp float tmpvar_23;
  tmpvar_23 = (pow (nh_19, arg1_22) * tmpvar_13.w);
  highp vec3 tmpvar_24;
  tmpvar_24 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_20) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_23)) * 2.00000);
  c_18.xyz = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = (tmpvar_14.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_23));
  c_18.w = tmpvar_25;
  c_1.w = c_18.w;
  c_1.xyz = (c_18.xyz + (tmpvar_14.xyz * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + (tmpvar_14.xyz * texture2D (_Illum, tmpvar_12).w));
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

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_12;
  tmpvar_12 = (texture2D (_MainTex, tmpvar_10) * _Color);
  c_1.xyz = (tmpvar_12.xyz * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz));
  c_1.w = tmpvar_12.w;
  c_1.xyz = (c_1.xyz + (tmpvar_12.xyz * texture2D (_Illum, tmpvar_11).w));
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

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.zw + tmpvar_4);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_10);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_11).xyz * 2.00000) - 1.00000);
  c_1.w = 0.000000;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_17;
  mediump vec3 viewDir_18;
  viewDir_18 = tmpvar_16;
  mediump vec3 specColor_19;
  highp float nh_20;
  mediump vec3 normal_21;
  normal_21 = tmpvar_15;
  mediump vec3 scalePerBasisVector_22;
  mediump vec3 lm_23;
  lowp vec3 tmpvar_24;
  tmpvar_24 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_23 = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (2.00000 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  scalePerBasisVector_22 = tmpvar_25;
  lm_23 = (lm_23 * dot (clamp ((mat3(0.816497, -0.408248, -0.408248, 0.000000, 0.707107, -0.707107, 0.577350, 0.577350, 0.577350) * normal_21), 0.000000, 1.00000), scalePerBasisVector_22));
  mediump float tmpvar_26;
  tmpvar_26 = max (0.000000, dot (tmpvar_15, normalize((normalize((((scalePerBasisVector_22.x * vec3(0.816497, 0.000000, 0.577350)) + (scalePerBasisVector_22.y * vec3(-0.408248, 0.707107, 0.577350))) + (scalePerBasisVector_22.z * vec3(-0.408248, -0.707107, 0.577350)))) + viewDir_18))));
  nh_20 = tmpvar_26;
  highp float tmpvar_27;
  mediump float arg1_28;
  arg1_28 = (_Shininess * 128.000);
  tmpvar_27 = pow (nh_20, arg1_28);
  highp vec3 tmpvar_29;
  tmpvar_29 = (((lm_23 * _SpecColor.xyz) * tmpvar_13.w) * tmpvar_27);
  specColor_19 = tmpvar_29;
  highp vec4 tmpvar_30;
  tmpvar_30.xyz = lm_23;
  tmpvar_30.w = tmpvar_27;
  tmpvar_17 = tmpvar_30;
  c_1.xyz = specColor_19;
  mediump vec3 tmpvar_31;
  tmpvar_31 = (c_1.xyz + (tmpvar_14.xyz * tmpvar_17.xyz));
  c_1.xyz = tmpvar_31;
  c_1.w = tmpvar_14.w;
  c_1.xyz = (c_1.xyz + (tmpvar_14.xyz * texture2D (_Illum, tmpvar_12).w));
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  mediump vec3 x3_16;
  highp float vC_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_17 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_17);
  x3_16 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_16);
  shlight_3 = tmpvar_14;
  tmpvar_6 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.zw + tmpvar_4);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_10);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_11).xyz * 2.00000) - 1.00000);
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_22;
  lowp vec4 c_24;
  highp float nh_25;
  lowp float tmpvar_26;
  tmpvar_26 = max (0.000000, dot (tmpvar_15, xlv_TEXCOORD3));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.000000, dot (tmpvar_15, normalize((xlv_TEXCOORD3 + viewDir_23))));
  nh_25 = tmpvar_27;
  mediump float arg1_28;
  arg1_28 = (_Shininess * 128.000);
  highp float tmpvar_29;
  tmpvar_29 = (pow (nh_25, arg1_28) * tmpvar_13.w);
  highp vec3 tmpvar_30;
  tmpvar_30 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_26) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_29)) * (tmpvar_16 * 2.00000));
  c_24.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (tmpvar_14.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_29) * tmpvar_16));
  c_24.w = tmpvar_31;
  c_1.w = c_24.w;
  c_1.xyz = (c_24.xyz + (tmpvar_14.xyz * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + (tmpvar_14.xyz * texture2D (_Illum, tmpvar_12).w));
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_12;
  tmpvar_12 = (texture2D (_MainTex, tmpvar_10) * _Color);
  lowp float tmpvar_13;
  mediump float lightShadowDataX_14;
  highp float dist_15;
  lowp float tmpvar_16;
  tmpvar_16 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_15 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = _LightShadowData.x;
  lightShadowDataX_14 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = max (float((dist_15 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_14);
  tmpvar_13 = tmpvar_18;
  c_1.xyz = (tmpvar_12.xyz * min ((2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz), vec3((tmpvar_13 * 2.00000))));
  c_1.w = tmpvar_12.w;
  c_1.xyz = (c_1.xyz + (tmpvar_12.xyz * texture2D (_Illum, tmpvar_11).w));
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

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_4 = tmpvar_1.xyz;
  tmpvar_5 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_6;
  tmpvar_6[0].x = tmpvar_4.x;
  tmpvar_6[0].y = tmpvar_5.x;
  tmpvar_6[0].z = tmpvar_2.x;
  tmpvar_6[1].x = tmpvar_4.y;
  tmpvar_6[1].y = tmpvar_5.y;
  tmpvar_6[1].z = tmpvar_2.y;
  tmpvar_6[2].x = tmpvar_4.z;
  tmpvar_6[2].y = tmpvar_5.z;
  tmpvar_6[2].z = tmpvar_2.z;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_6 * (((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.zw + tmpvar_4);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_10);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_11).xyz * 2.00000) - 1.00000);
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  c_1.w = 0.000000;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD2);
  mediump vec4 tmpvar_23;
  mediump vec3 viewDir_24;
  viewDir_24 = tmpvar_22;
  mediump vec3 specColor_25;
  highp float nh_26;
  mediump vec3 normal_27;
  normal_27 = tmpvar_15;
  mediump vec3 scalePerBasisVector_28;
  mediump vec3 lm_29;
  lowp vec3 tmpvar_30;
  tmpvar_30 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_29 = tmpvar_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (2.00000 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  scalePerBasisVector_28 = tmpvar_31;
  lm_29 = (lm_29 * dot (clamp ((mat3(0.816497, -0.408248, -0.408248, 0.000000, 0.707107, -0.707107, 0.577350, 0.577350, 0.577350) * normal_27), 0.000000, 1.00000), scalePerBasisVector_28));
  mediump float tmpvar_32;
  tmpvar_32 = max (0.000000, dot (tmpvar_15, normalize((normalize((((scalePerBasisVector_28.x * vec3(0.816497, 0.000000, 0.577350)) + (scalePerBasisVector_28.y * vec3(-0.408248, 0.707107, 0.577350))) + (scalePerBasisVector_28.z * vec3(-0.408248, -0.707107, 0.577350)))) + viewDir_24))));
  nh_26 = tmpvar_32;
  highp float tmpvar_33;
  mediump float arg1_34;
  arg1_34 = (_Shininess * 128.000);
  tmpvar_33 = pow (nh_26, arg1_34);
  highp vec3 tmpvar_35;
  tmpvar_35 = (((lm_29 * _SpecColor.xyz) * tmpvar_13.w) * tmpvar_33);
  specColor_25 = tmpvar_35;
  highp vec4 tmpvar_36;
  tmpvar_36.xyz = lm_29;
  tmpvar_36.w = tmpvar_33;
  tmpvar_23 = tmpvar_36;
  c_1.xyz = specColor_25;
  lowp vec3 tmpvar_37;
  tmpvar_37 = vec3((tmpvar_16 * 2.00000));
  mediump vec3 tmpvar_38;
  tmpvar_38 = (c_1.xyz + (tmpvar_14.xyz * min (tmpvar_23.xyz, tmpvar_37)));
  c_1.xyz = tmpvar_38;
  c_1.w = tmpvar_14.w;
  c_1.xyz = (c_1.xyz + (tmpvar_14.xyz * texture2D (_Illum, tmpvar_12).w));
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

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = tmpvar_8;
  mediump vec3 tmpvar_15;
  mediump vec4 normal_16;
  normal_16 = tmpvar_14;
  mediump vec3 x3_17;
  highp float vC_18;
  mediump vec3 x2_19;
  mediump vec3 x1_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal_16);
  x1_20.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal_16);
  x1_20.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal_16);
  x1_20.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal_16.xyzz * normal_16.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2_19.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2_19.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2_19.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal_16.x * normal_16.x) - (normal_16.y * normal_16.y));
  vC_18 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC_18);
  x3_17 = tmpvar_29;
  tmpvar_15 = ((x1_20 + x2_19) + x3_17);
  shlight_3 = tmpvar_15;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_30;
  tmpvar_30 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosX0 - tmpvar_30.x);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosY0 - tmpvar_30.y);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosZ0 - tmpvar_30.z);
  highp vec4 tmpvar_34;
  tmpvar_34 = (((tmpvar_31 * tmpvar_31) + (tmpvar_32 * tmpvar_32)) + (tmpvar_33 * tmpvar_33));
  highp vec4 tmpvar_35;
  tmpvar_35 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_31 * tmpvar_8.x) + (tmpvar_32 * tmpvar_8.y)) + (tmpvar_33 * tmpvar_8.z)) * inversesqrt(tmpvar_34))) * (1.0/((1.00000 + (tmpvar_34 * unity_4LightAtten0)))));
  highp vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_35.x) + (unity_LightColor[1].xyz * tmpvar_35.y)) + (unity_LightColor[2].xyz * tmpvar_35.z)) + (unity_LightColor[3].xyz * tmpvar_35.w)));
  tmpvar_6 = tmpvar_36;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_11 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.zw + tmpvar_4);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_10);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_11).xyz * 2.00000) - 1.00000);
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_17;
  viewDir_17 = tmpvar_16;
  lowp vec4 c_18;
  highp float nh_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.000000, dot (tmpvar_15, xlv_TEXCOORD3));
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (tmpvar_15, normalize((xlv_TEXCOORD3 + viewDir_17))));
  nh_19 = tmpvar_21;
  mediump float arg1_22;
  arg1_22 = (_Shininess * 128.000);
  highp float tmpvar_23;
  tmpvar_23 = (pow (nh_19, arg1_22) * tmpvar_13.w);
  highp vec3 tmpvar_24;
  tmpvar_24 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_20) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_23)) * 2.00000);
  c_18.xyz = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = (tmpvar_14.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_23));
  c_18.w = tmpvar_25;
  c_1.w = c_18.w;
  c_1.xyz = (c_18.xyz + (tmpvar_14.xyz * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + (tmpvar_14.xyz * texture2D (_Illum, tmpvar_12).w));
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

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _Illum_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  highp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = tmpvar_8;
  mediump vec3 tmpvar_15;
  mediump vec4 normal_16;
  normal_16 = tmpvar_14;
  mediump vec3 x3_17;
  highp float vC_18;
  mediump vec3 x2_19;
  mediump vec3 x1_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal_16);
  x1_20.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal_16);
  x1_20.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal_16);
  x1_20.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal_16.xyzz * normal_16.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2_19.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2_19.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2_19.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal_16.x * normal_16.x) - (normal_16.y * normal_16.y));
  vC_18 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC_18);
  x3_17 = tmpvar_29;
  tmpvar_15 = ((x1_20 + x2_19) + x3_17);
  shlight_3 = tmpvar_15;
  tmpvar_6 = shlight_3;
  highp vec3 tmpvar_30;
  tmpvar_30 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosX0 - tmpvar_30.x);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosY0 - tmpvar_30.y);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosZ0 - tmpvar_30.z);
  highp vec4 tmpvar_34;
  tmpvar_34 = (((tmpvar_31 * tmpvar_31) + (tmpvar_32 * tmpvar_32)) + (tmpvar_33 * tmpvar_33));
  highp vec4 tmpvar_35;
  tmpvar_35 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_31 * tmpvar_8.x) + (tmpvar_32 * tmpvar_8.y)) + (tmpvar_33 * tmpvar_8.z)) * inversesqrt(tmpvar_34))) * (1.0/((1.00000 + (tmpvar_34 * unity_4LightAtten0)))));
  highp vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_6 + ((((unity_LightColor[0].xyz * tmpvar_35.x) + (unity_LightColor[1].xyz * tmpvar_35.y)) + (unity_LightColor[2].xyz * tmpvar_35.z)) + (unity_LightColor[3].xyz * tmpvar_35.w)));
  tmpvar_6 = tmpvar_36;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = ((_glesMultiTexCoord0.xy * _Illum_ST.xy) + _Illum_ST.zw);
  xlv_TEXCOORD2 = (tmpvar_11 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform sampler2D _Illum;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  mediump float h_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_2 = tmpvar_3;
  highp vec2 tmpvar_4;
  mediump float height_5;
  height_5 = _Parallax;
  mediump vec3 viewDir_6;
  viewDir_6 = xlv_TEXCOORD2;
  highp vec3 v_7;
  mediump float tmpvar_8;
  tmpvar_8 = ((h_2 * height_5) - (height_5 / 2.00000));
  mediump vec3 tmpvar_9;
  tmpvar_9 = normalize(viewDir_6);
  v_7 = tmpvar_9;
  v_7.z = (v_7.z + 0.420000);
  tmpvar_4 = (tmpvar_8 * (v_7.xy / v_7.z));
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy + tmpvar_4);
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.zw + tmpvar_4);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD1 + tmpvar_4);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_10);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_11).xyz * 2.00000) - 1.00000);
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize(xlv_TEXCOORD2);
  mediump vec3 viewDir_23;
  viewDir_23 = tmpvar_22;
  lowp vec4 c_24;
  highp float nh_25;
  lowp float tmpvar_26;
  tmpvar_26 = max (0.000000, dot (tmpvar_15, xlv_TEXCOORD3));
  mediump float tmpvar_27;
  tmpvar_27 = max (0.000000, dot (tmpvar_15, normalize((xlv_TEXCOORD3 + viewDir_23))));
  nh_25 = tmpvar_27;
  mediump float arg1_28;
  arg1_28 = (_Shininess * 128.000);
  highp float tmpvar_29;
  tmpvar_29 = (pow (nh_25, arg1_28) * tmpvar_13.w);
  highp vec3 tmpvar_30;
  tmpvar_30 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_26) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_29)) * (tmpvar_16 * 2.00000));
  c_24.xyz = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = (tmpvar_14.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_29) * tmpvar_16));
  c_24.w = tmpvar_31;
  c_1.w = c_24.w;
  c_1.xyz = (c_24.xyz + (tmpvar_14.xyz * xlv_TEXCOORD4));
  c_1.xyz = (c_1.xyz + (tmpvar_14.xyz * texture2D (_Illum, tmpvar_12).w));
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
  Tags { "LIGHTMODE"="ForwardAdd" "RenderType"="Opaque" }
  ZWrite Off
  Fog {
   Color (0,0,0,0)
  }
  Blend One One
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
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_3 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_3 * height_6) - (height_6 / 2.00000));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.420000);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_11);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_12).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  mediump vec3 viewDir_19;
  viewDir_19 = tmpvar_17;
  lowp float atten_20;
  atten_20 = texture2D (_LightTexture0, vec2(tmpvar_18)).w;
  lowp vec4 c_21;
  highp float nh_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.000000, dot (tmpvar_15, lightDir_2));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.000000, dot (tmpvar_15, normalize((lightDir_2 + viewDir_19))));
  nh_22 = tmpvar_24;
  mediump float arg1_25;
  arg1_25 = (_Shininess * 128.000);
  highp float tmpvar_26;
  tmpvar_26 = (pow (nh_22, arg1_25) * tmpvar_13.w);
  highp vec3 tmpvar_27;
  tmpvar_27 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_23) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_26)) * (atten_20 * 2.00000));
  c_21.xyz = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_14.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_26) * atten_20));
  c_21.w = tmpvar_28;
  c_1.xyz = c_21.xyz;
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
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_3 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_3 * height_6) - (height_6 / 2.00000));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.420000);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_11);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_12).xyz * 2.00000) - 1.00000);
  lightDir_2 = xlv_TEXCOORD2;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_17;
  viewDir_17 = tmpvar_16;
  lowp vec4 c_18;
  highp float nh_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.000000, dot (tmpvar_15, lightDir_2));
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (tmpvar_15, normalize((lightDir_2 + viewDir_17))));
  nh_19 = tmpvar_21;
  mediump float arg1_22;
  arg1_22 = (_Shininess * 128.000);
  highp float tmpvar_23;
  tmpvar_23 = (pow (nh_19, arg1_22) * tmpvar_13.w);
  highp vec3 tmpvar_24;
  tmpvar_24 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_20) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_23)) * 2.00000);
  c_18.xyz = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = (tmpvar_14.w + ((_LightColor0.w * _SpecColor.w) * tmpvar_23));
  c_18.w = tmpvar_25;
  c_1.xyz = c_18.xyz;
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
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_3 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_3 * height_6) - (height_6 / 2.00000));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.420000);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_11);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_12).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  highp vec2 P_18;
  P_18 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.500000);
  highp float tmpvar_19;
  tmpvar_19 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  mediump vec3 viewDir_20;
  viewDir_20 = tmpvar_17;
  lowp float atten_21;
  atten_21 = ((float((xlv_TEXCOORD3.z > 0.000000)) * texture2D (_LightTexture0, P_18).w) * texture2D (_LightTextureB0, vec2(tmpvar_19)).w);
  lowp vec4 c_22;
  highp float nh_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.000000, dot (tmpvar_15, lightDir_2));
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (tmpvar_15, normalize((lightDir_2 + viewDir_20))));
  nh_23 = tmpvar_25;
  mediump float arg1_26;
  arg1_26 = (_Shininess * 128.000);
  highp float tmpvar_27;
  tmpvar_27 = (pow (nh_23, arg1_26) * tmpvar_13.w);
  highp vec3 tmpvar_28;
  tmpvar_28 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_24) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_27)) * (atten_21 * 2.00000));
  c_22.xyz = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = (tmpvar_14.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_27) * atten_21));
  c_22.w = tmpvar_29;
  c_1.xyz = c_22.xyz;
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
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_3 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_3 * height_6) - (height_6 / 2.00000));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.420000);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_11);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_12).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize(xlv_TEXCOORD1);
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  mediump vec3 viewDir_19;
  viewDir_19 = tmpvar_17;
  lowp float atten_20;
  atten_20 = (texture2D (_LightTextureB0, vec2(tmpvar_18)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w);
  lowp vec4 c_21;
  highp float nh_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.000000, dot (tmpvar_15, lightDir_2));
  mediump float tmpvar_24;
  tmpvar_24 = max (0.000000, dot (tmpvar_15, normalize((lightDir_2 + viewDir_19))));
  nh_22 = tmpvar_24;
  mediump float arg1_25;
  arg1_25 = (_Shininess * 128.000);
  highp float tmpvar_26;
  tmpvar_26 = (pow (nh_22, arg1_25) * tmpvar_13.w);
  highp vec3 tmpvar_27;
  tmpvar_27 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_23) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_26)) * (atten_20 * 2.00000));
  c_21.xyz = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_14.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_26) * atten_20));
  c_21.w = tmpvar_28;
  c_1.xyz = c_21.xyz;
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
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _BumpMap_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec4 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump float h_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_3 = tmpvar_4;
  highp vec2 tmpvar_5;
  mediump float height_6;
  height_6 = _Parallax;
  mediump vec3 viewDir_7;
  viewDir_7 = xlv_TEXCOORD1;
  highp vec3 v_8;
  mediump float tmpvar_9;
  tmpvar_9 = ((h_3 * height_6) - (height_6 / 2.00000));
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(viewDir_7);
  v_8 = tmpvar_10;
  v_8.z = (v_8.z + 0.420000);
  tmpvar_5 = (tmpvar_9 * (v_8.xy / v_8.z));
  highp vec2 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xy + tmpvar_5);
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.zw + tmpvar_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_MainTex, tmpvar_11);
  lowp vec4 tmpvar_14;
  tmpvar_14 = (tmpvar_13 * _Color);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((texture2D (_BumpMap, tmpvar_12).xyz * 2.00000) - 1.00000);
  lightDir_2 = xlv_TEXCOORD2;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize(xlv_TEXCOORD1);
  mediump vec3 viewDir_17;
  viewDir_17 = tmpvar_16;
  lowp float atten_18;
  atten_18 = texture2D (_LightTexture0, xlv_TEXCOORD3).w;
  lowp vec4 c_19;
  highp float nh_20;
  lowp float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (tmpvar_15, lightDir_2));
  mediump float tmpvar_22;
  tmpvar_22 = max (0.000000, dot (tmpvar_15, normalize((lightDir_2 + viewDir_17))));
  nh_20 = tmpvar_22;
  mediump float arg1_23;
  arg1_23 = (_Shininess * 128.000);
  highp float tmpvar_24;
  tmpvar_24 = (pow (nh_20, arg1_23) * tmpvar_13.w);
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_14.xyz * _LightColor0.xyz) * tmpvar_21) + ((_LightColor0.xyz * _SpecColor.xyz) * tmpvar_24)) * (atten_18 * 2.00000));
  c_19.xyz = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = (tmpvar_14.w + (((_LightColor0.w * _SpecColor.w) * tmpvar_24) * atten_18));
  c_19.w = tmpvar_26;
  c_1.xyz = c_19.xyz;
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
}
Fallback "Self-Illumin/Bumped Specular"
}