܃Shader "Reflective/Parallax Diffuse" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
 _Parallax ("Height", Range(0.005,0.08)) = 0.02
 _MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
 _Cube ("Reflection Cubemap", CUBE) = "_Skybox" { TexGen CubeReflect }
 _BumpMap ("Normalmap", 2D) = "bump" {}
 _ParallaxMap ("Heightmap (A)", 2D) = "black" {}
}
SubShader { 
 LOD 500
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.00000;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesVertex.xyz - ((_World2Object * tmpvar_10).xyz * unity_Scale.w)));
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  vec4 v_16;
  v_16.x = _Object2World[0].x;
  v_16.y = _Object2World[1].x;
  v_16.z = _Object2World[2].x;
  v_16.w = _Object2World[3].x;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_15 * v_16.xyz);
  tmpvar_17.w = tmpvar_12.x;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  v_19.w = _Object2World[3].y;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_15 * v_19.xyz);
  tmpvar_20.w = tmpvar_12.y;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  vec4 v_22;
  v_22.x = _Object2World[0].z;
  v_22.y = _Object2World[1].z;
  v_22.z = _Object2World[2].z;
  v_22.w = _Object2World[3].z;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = (tmpvar_15 * v_22.xyz);
  tmpvar_23.w = tmpvar_12.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * unity_Scale.w);
  tmpvar_7 = tmpvar_24;
  mat3 tmpvar_25;
  tmpvar_25[0] = _Object2World[0].xyz;
  tmpvar_25[1] = _Object2World[1].xyz;
  tmpvar_25[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_8 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = (tmpvar_25 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_29;
  mediump vec4 normal_30;
  normal_30 = tmpvar_28;
  mediump vec3 x3_31;
  highp float vC_32;
  mediump vec3 x2_33;
  mediump vec3 x1_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHAr, normal_30);
  x1_34.x = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = dot (unity_SHAg, normal_30);
  x1_34.y = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHAb, normal_30);
  x1_34.z = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38 = (normal_30.xyzz * normal_30.yzzx);
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHBr, tmpvar_38);
  x2_33.x = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHBg, tmpvar_38);
  x2_33.y = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = dot (unity_SHBb, tmpvar_38);
  x2_33.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = ((normal_30.x * normal_30.x) - (normal_30.y * normal_30.y));
  vC_32 = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = (unity_SHC.xyz * vC_32);
  x3_31 = tmpvar_43;
  tmpvar_29 = ((x1_34 + x2_33) + x3_31);
  shlight_3 = tmpvar_29;
  tmpvar_9 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_15 * (((_World2Object * tmpvar_27).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = tmpvar_9;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _Color);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_3, tmpvar_22);
  tmpvar_23.y = dot (tmpvar_4, tmpvar_22);
  tmpvar_23.z = dot (tmpvar_5, tmpvar_22);
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 - (2.00000 * (dot (tmpvar_23, tmpvar_2) * tmpvar_23)));
  lowp vec4 tmpvar_25;
  tmpvar_25 = (textureCube (_Cube, tmpvar_24) * tmpvar_20.w);
  lowp vec4 c_26;
  c_26.xyz = ((tmpvar_21.xyz * _LightColor0.xyz) * (max (0.000000, dot (tmpvar_22, xlv_TEXCOORD5)) * 2.00000));
  c_26.w = (tmpvar_25.w * _ReflectColor.w);
  c_1.w = c_26.w;
  c_1.xyz = (c_26.xyz + (tmpvar_21.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (tmpvar_25.xyz * _ReflectColor.xyz));
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

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
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
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  vec4 v_13;
  v_13.x = _Object2World[0].x;
  v_13.y = _Object2World[1].x;
  v_13.z = _Object2World[2].x;
  v_13.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_12 * v_13.xyz);
  tmpvar_14.w = tmpvar_9.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_16;
  v_16.x = _Object2World[0].y;
  v_16.y = _Object2World[1].y;
  v_16.z = _Object2World[2].y;
  v_16.w = _Object2World[3].y;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_16.xyz);
  tmpvar_17.w = tmpvar_9.y;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].z;
  v_19.y = _Object2World[1].z;
  v_19.z = _Object2World[2].z;
  v_19.w = _Object2World[3].z;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_12 * v_19.xyz);
  tmpvar_20.w = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_3, tmpvar_21);
  tmpvar_22.y = dot (tmpvar_4, tmpvar_21);
  tmpvar_22.z = dot (tmpvar_5, tmpvar_21);
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 - (2.00000 * (dot (tmpvar_22, tmpvar_2) * tmpvar_22)));
  lowp vec4 tmpvar_24;
  tmpvar_24 = (textureCube (_Cube, tmpvar_23) * tmpvar_20.w);
  c_1.xyz = ((tmpvar_20 * _Color).xyz * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz));
  c_1.w = (tmpvar_24.w * _ReflectColor.w);
  c_1.xyz = (c_1.xyz + (tmpvar_24.xyz * _ReflectColor.xyz));
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

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
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
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  vec4 v_13;
  v_13.x = _Object2World[0].x;
  v_13.y = _Object2World[1].x;
  v_13.z = _Object2World[2].x;
  v_13.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_12 * v_13.xyz);
  tmpvar_14.w = tmpvar_9.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_16;
  v_16.x = _Object2World[0].y;
  v_16.y = _Object2World[1].y;
  v_16.z = _Object2World[2].y;
  v_16.w = _Object2World[3].y;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_16.xyz);
  tmpvar_17.w = tmpvar_9.y;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].z;
  v_19.y = _Object2World[1].z;
  v_19.z = _Object2World[2].z;
  v_19.w = _Object2World[3].z;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_12 * v_19.xyz);
  tmpvar_20.w = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _Color);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_3, tmpvar_22);
  tmpvar_23.y = dot (tmpvar_4, tmpvar_22);
  tmpvar_23.z = dot (tmpvar_5, tmpvar_22);
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 - (2.00000 * (dot (tmpvar_23, tmpvar_2) * tmpvar_23)));
  lowp vec4 tmpvar_25;
  tmpvar_25 = (textureCube (_Cube, tmpvar_24) * tmpvar_20.w);
  mediump vec3 normal_26;
  normal_26 = tmpvar_22;
  mediump vec3 scalePerBasisVector_27;
  mediump vec3 lm_28;
  lowp vec3 tmpvar_29;
  tmpvar_29 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz);
  lm_28 = tmpvar_29;
  lowp vec3 tmpvar_30;
  tmpvar_30 = (2.00000 * texture2D (unity_LightmapInd, xlv_TEXCOORD5).xyz);
  scalePerBasisVector_27 = tmpvar_30;
  lm_28 = (lm_28 * dot (clamp ((mat3(0.816497, -0.408248, -0.408248, 0.000000, 0.707107, -0.707107, 0.577350, 0.577350, 0.577350) * normal_26), 0.000000, 1.00000), scalePerBasisVector_27));
  mediump vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_21.xyz * lm_28);
  c_1.xyz = tmpvar_31;
  c_1.w = (tmpvar_25.w * _ReflectColor.w);
  c_1.xyz = (c_1.xyz + (tmpvar_25.xyz * _ReflectColor.xyz));
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.00000;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesVertex.xyz - ((_World2Object * tmpvar_10).xyz * unity_Scale.w)));
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  vec4 v_16;
  v_16.x = _Object2World[0].x;
  v_16.y = _Object2World[1].x;
  v_16.z = _Object2World[2].x;
  v_16.w = _Object2World[3].x;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_15 * v_16.xyz);
  tmpvar_17.w = tmpvar_12.x;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  v_19.w = _Object2World[3].y;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_15 * v_19.xyz);
  tmpvar_20.w = tmpvar_12.y;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  vec4 v_22;
  v_22.x = _Object2World[0].z;
  v_22.y = _Object2World[1].z;
  v_22.z = _Object2World[2].z;
  v_22.w = _Object2World[3].z;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = (tmpvar_15 * v_22.xyz);
  tmpvar_23.w = tmpvar_12.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * unity_Scale.w);
  tmpvar_7 = tmpvar_24;
  mat3 tmpvar_25;
  tmpvar_25[0] = _Object2World[0].xyz;
  tmpvar_25[1] = _Object2World[1].xyz;
  tmpvar_25[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_8 = tmpvar_26;
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = (tmpvar_25 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_29;
  mediump vec4 normal_30;
  normal_30 = tmpvar_28;
  mediump vec3 x3_31;
  highp float vC_32;
  mediump vec3 x2_33;
  mediump vec3 x1_34;
  highp float tmpvar_35;
  tmpvar_35 = dot (unity_SHAr, normal_30);
  x1_34.x = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = dot (unity_SHAg, normal_30);
  x1_34.y = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHAb, normal_30);
  x1_34.z = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38 = (normal_30.xyzz * normal_30.yzzx);
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHBr, tmpvar_38);
  x2_33.x = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHBg, tmpvar_38);
  x2_33.y = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = dot (unity_SHBb, tmpvar_38);
  x2_33.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = ((normal_30.x * normal_30.x) - (normal_30.y * normal_30.y));
  vC_32 = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = (unity_SHC.xyz * vC_32);
  x3_31 = tmpvar_43;
  tmpvar_29 = ((x1_34 + x2_33) + x3_31);
  shlight_3 = tmpvar_29;
  tmpvar_9 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_15 * (((_World2Object * tmpvar_27).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = tmpvar_9;
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _Color);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_3, tmpvar_22);
  tmpvar_23.y = dot (tmpvar_4, tmpvar_22);
  tmpvar_23.z = dot (tmpvar_5, tmpvar_22);
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 - (2.00000 * (dot (tmpvar_23, tmpvar_2) * tmpvar_23)));
  lowp vec4 tmpvar_25;
  tmpvar_25 = (textureCube (_Cube, tmpvar_24) * tmpvar_20.w);
  lowp float tmpvar_26;
  mediump float lightShadowDataX_27;
  highp float dist_28;
  lowp float tmpvar_29;
  tmpvar_29 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  dist_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = _LightShadowData.x;
  lightShadowDataX_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = max (float((dist_28 > (xlv_TEXCOORD7.z / xlv_TEXCOORD7.w))), lightShadowDataX_27);
  tmpvar_26 = tmpvar_31;
  lowp vec4 c_32;
  c_32.xyz = ((tmpvar_21.xyz * _LightColor0.xyz) * ((max (0.000000, dot (tmpvar_22, xlv_TEXCOORD5)) * tmpvar_26) * 2.00000));
  c_32.w = (tmpvar_25.w * _ReflectColor.w);
  c_1.w = c_32.w;
  c_1.xyz = (c_32.xyz + (tmpvar_21.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (tmpvar_25.xyz * _ReflectColor.xyz));
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

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
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
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  vec4 v_13;
  v_13.x = _Object2World[0].x;
  v_13.y = _Object2World[1].x;
  v_13.z = _Object2World[2].x;
  v_13.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_12 * v_13.xyz);
  tmpvar_14.w = tmpvar_9.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_16;
  v_16.x = _Object2World[0].y;
  v_16.y = _Object2World[1].y;
  v_16.z = _Object2World[2].y;
  v_16.w = _Object2World[3].y;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_16.xyz);
  tmpvar_17.w = tmpvar_9.y;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].z;
  v_19.y = _Object2World[1].z;
  v_19.z = _Object2World[2].z;
  v_19.w = _Object2World[3].z;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_12 * v_19.xyz);
  tmpvar_20.w = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_22;
  tmpvar_22.x = dot (tmpvar_3, tmpvar_21);
  tmpvar_22.y = dot (tmpvar_4, tmpvar_21);
  tmpvar_22.z = dot (tmpvar_5, tmpvar_21);
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_2 - (2.00000 * (dot (tmpvar_22, tmpvar_2) * tmpvar_22)));
  lowp vec4 tmpvar_24;
  tmpvar_24 = (textureCube (_Cube, tmpvar_23) * tmpvar_20.w);
  lowp float tmpvar_25;
  mediump float lightShadowDataX_26;
  highp float dist_27;
  lowp float tmpvar_28;
  tmpvar_28 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x;
  dist_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = _LightShadowData.x;
  lightShadowDataX_26 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = max (float((dist_27 > (xlv_TEXCOORD6.z / xlv_TEXCOORD6.w))), lightShadowDataX_26);
  tmpvar_25 = tmpvar_30;
  c_1.xyz = ((tmpvar_20 * _Color).xyz * min ((2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz), vec3((tmpvar_25 * 2.00000))));
  c_1.w = (tmpvar_24.w * _ReflectColor.w);
  c_1.xyz = (c_1.xyz + (tmpvar_24.xyz * _ReflectColor.xyz));
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

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
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
  lowp vec4 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * (_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)));
  highp vec3 tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_10 = tmpvar_1.xyz;
  tmpvar_11 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_12;
  tmpvar_12[0].x = tmpvar_10.x;
  tmpvar_12[0].y = tmpvar_11.x;
  tmpvar_12[0].z = tmpvar_2.x;
  tmpvar_12[1].x = tmpvar_10.y;
  tmpvar_12[1].y = tmpvar_11.y;
  tmpvar_12[1].z = tmpvar_2.y;
  tmpvar_12[2].x = tmpvar_10.z;
  tmpvar_12[2].y = tmpvar_11.z;
  tmpvar_12[2].z = tmpvar_2.z;
  vec4 v_13;
  v_13.x = _Object2World[0].x;
  v_13.y = _Object2World[1].x;
  v_13.z = _Object2World[2].x;
  v_13.w = _Object2World[3].x;
  highp vec4 tmpvar_14;
  tmpvar_14.xyz = (tmpvar_12 * v_13.xyz);
  tmpvar_14.w = tmpvar_9.x;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_14 * unity_Scale.w);
  tmpvar_4 = tmpvar_15;
  vec4 v_16;
  v_16.x = _Object2World[0].y;
  v_16.y = _Object2World[1].y;
  v_16.z = _Object2World[2].y;
  v_16.w = _Object2World[3].y;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_12 * v_16.xyz);
  tmpvar_17.w = tmpvar_9.y;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].z;
  v_19.y = _Object2World[1].z;
  v_19.z = _Object2World[2].z;
  v_19.w = _Object2World[3].z;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_12 * v_19.xyz);
  tmpvar_20.w = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = _WorldSpaceCameraPos;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (tmpvar_12 * (((_World2Object * tmpvar_22).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD6 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _Color);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_3, tmpvar_22);
  tmpvar_23.y = dot (tmpvar_4, tmpvar_22);
  tmpvar_23.z = dot (tmpvar_5, tmpvar_22);
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 - (2.00000 * (dot (tmpvar_23, tmpvar_2) * tmpvar_23)));
  lowp vec4 tmpvar_25;
  tmpvar_25 = (textureCube (_Cube, tmpvar_24) * tmpvar_20.w);
  lowp float tmpvar_26;
  mediump float lightShadowDataX_27;
  highp float dist_28;
  lowp float tmpvar_29;
  tmpvar_29 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD6).x;
  dist_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = _LightShadowData.x;
  lightShadowDataX_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = max (float((dist_28 > (xlv_TEXCOORD6.z / xlv_TEXCOORD6.w))), lightShadowDataX_27);
  tmpvar_26 = tmpvar_31;
  mediump vec3 normal_32;
  normal_32 = tmpvar_22;
  mediump vec3 scalePerBasisVector_33;
  mediump vec3 lm_34;
  lowp vec3 tmpvar_35;
  tmpvar_35 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD5).xyz);
  lm_34 = tmpvar_35;
  lowp vec3 tmpvar_36;
  tmpvar_36 = (2.00000 * texture2D (unity_LightmapInd, xlv_TEXCOORD5).xyz);
  scalePerBasisVector_33 = tmpvar_36;
  lm_34 = (lm_34 * dot (clamp ((mat3(0.816497, -0.408248, -0.408248, 0.000000, 0.707107, -0.707107, 0.577350, 0.577350, 0.577350) * normal_32), 0.000000, 1.00000), scalePerBasisVector_33));
  lowp vec3 tmpvar_37;
  tmpvar_37 = vec3((tmpvar_26 * 2.00000));
  mediump vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_21.xyz * min (lm_34, tmpvar_37));
  c_1.xyz = tmpvar_38;
  c_1.w = (tmpvar_25.w * _ReflectColor.w);
  c_1.xyz = (c_1.xyz + (tmpvar_25.xyz * _ReflectColor.xyz));
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.00000;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesVertex.xyz - ((_World2Object * tmpvar_10).xyz * unity_Scale.w)));
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  vec4 v_16;
  v_16.x = _Object2World[0].x;
  v_16.y = _Object2World[1].x;
  v_16.z = _Object2World[2].x;
  v_16.w = _Object2World[3].x;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_15 * v_16.xyz);
  tmpvar_17.w = tmpvar_12.x;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  v_19.w = _Object2World[3].y;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_15 * v_19.xyz);
  tmpvar_20.w = tmpvar_12.y;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  vec4 v_22;
  v_22.x = _Object2World[0].z;
  v_22.y = _Object2World[1].z;
  v_22.z = _Object2World[2].z;
  v_22.w = _Object2World[3].z;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = (tmpvar_15 * v_22.xyz);
  tmpvar_23.w = tmpvar_12.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * unity_Scale.w);
  tmpvar_7 = tmpvar_24;
  mat3 tmpvar_25;
  tmpvar_25[0] = _Object2World[0].xyz;
  tmpvar_25[1] = _Object2World[1].xyz;
  tmpvar_25[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_25 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_8 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.00000;
  tmpvar_29.xyz = tmpvar_26;
  mediump vec3 tmpvar_30;
  mediump vec4 normal_31;
  normal_31 = tmpvar_29;
  mediump vec3 x3_32;
  highp float vC_33;
  mediump vec3 x2_34;
  mediump vec3 x1_35;
  highp float tmpvar_36;
  tmpvar_36 = dot (unity_SHAr, normal_31);
  x1_35.x = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHAg, normal_31);
  x1_35.y = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHAb, normal_31);
  x1_35.z = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39 = (normal_31.xyzz * normal_31.yzzx);
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHBr, tmpvar_39);
  x2_34.x = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = dot (unity_SHBg, tmpvar_39);
  x2_34.y = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHBb, tmpvar_39);
  x2_34.z = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = ((normal_31.x * normal_31.x) - (normal_31.y * normal_31.y));
  vC_33 = tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_44 = (unity_SHC.xyz * vC_33);
  x3_32 = tmpvar_44;
  tmpvar_30 = ((x1_35 + x2_34) + x3_32);
  shlight_3 = tmpvar_30;
  tmpvar_9 = shlight_3;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_46;
  tmpvar_46 = (unity_4LightPosX0 - tmpvar_45.x);
  highp vec4 tmpvar_47;
  tmpvar_47 = (unity_4LightPosY0 - tmpvar_45.y);
  highp vec4 tmpvar_48;
  tmpvar_48 = (unity_4LightPosZ0 - tmpvar_45.z);
  highp vec4 tmpvar_49;
  tmpvar_49 = (((tmpvar_46 * tmpvar_46) + (tmpvar_47 * tmpvar_47)) + (tmpvar_48 * tmpvar_48));
  highp vec4 tmpvar_50;
  tmpvar_50 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_46 * tmpvar_26.x) + (tmpvar_47 * tmpvar_26.y)) + (tmpvar_48 * tmpvar_26.z)) * inversesqrt(tmpvar_49))) * (1.0/((1.00000 + (tmpvar_49 * unity_4LightAtten0)))));
  highp vec3 tmpvar_51;
  tmpvar_51 = (tmpvar_9 + ((((unity_LightColor[0].xyz * tmpvar_50.x) + (unity_LightColor[1].xyz * tmpvar_50.y)) + (unity_LightColor[2].xyz * tmpvar_50.z)) + (unity_LightColor[3].xyz * tmpvar_50.w)));
  tmpvar_9 = tmpvar_51;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_15 * (((_World2Object * tmpvar_28).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = tmpvar_9;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _Color);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_3, tmpvar_22);
  tmpvar_23.y = dot (tmpvar_4, tmpvar_22);
  tmpvar_23.z = dot (tmpvar_5, tmpvar_22);
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 - (2.00000 * (dot (tmpvar_23, tmpvar_2) * tmpvar_23)));
  lowp vec4 tmpvar_25;
  tmpvar_25 = (textureCube (_Cube, tmpvar_24) * tmpvar_20.w);
  lowp vec4 c_26;
  c_26.xyz = ((tmpvar_21.xyz * _LightColor0.xyz) * (max (0.000000, dot (tmpvar_22, xlv_TEXCOORD5)) * 2.00000));
  c_26.w = (tmpvar_25.w * _ReflectColor.w);
  c_1.w = c_26.w;
  c_1.xyz = (c_26.xyz + (tmpvar_21.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (tmpvar_25.xyz * _ReflectColor.xyz));
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
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
  lowp vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  lowp vec4 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_4.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_4.zw = ((_glesMultiTexCoord0.xy * _BumpMap_ST.xy) + _BumpMap_ST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.00000;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_11;
  tmpvar_11[0] = _Object2World[0].xyz;
  tmpvar_11[1] = _Object2World[1].xyz;
  tmpvar_11[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_glesVertex.xyz - ((_World2Object * tmpvar_10).xyz * unity_Scale.w)));
  highp vec3 tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_13 = tmpvar_1.xyz;
  tmpvar_14 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_13.x;
  tmpvar_15[0].y = tmpvar_14.x;
  tmpvar_15[0].z = tmpvar_2.x;
  tmpvar_15[1].x = tmpvar_13.y;
  tmpvar_15[1].y = tmpvar_14.y;
  tmpvar_15[1].z = tmpvar_2.y;
  tmpvar_15[2].x = tmpvar_13.z;
  tmpvar_15[2].y = tmpvar_14.z;
  tmpvar_15[2].z = tmpvar_2.z;
  vec4 v_16;
  v_16.x = _Object2World[0].x;
  v_16.y = _Object2World[1].x;
  v_16.z = _Object2World[2].x;
  v_16.w = _Object2World[3].x;
  highp vec4 tmpvar_17;
  tmpvar_17.xyz = (tmpvar_15 * v_16.xyz);
  tmpvar_17.w = tmpvar_12.x;
  highp vec4 tmpvar_18;
  tmpvar_18 = (tmpvar_17 * unity_Scale.w);
  tmpvar_5 = tmpvar_18;
  vec4 v_19;
  v_19.x = _Object2World[0].y;
  v_19.y = _Object2World[1].y;
  v_19.z = _Object2World[2].y;
  v_19.w = _Object2World[3].y;
  highp vec4 tmpvar_20;
  tmpvar_20.xyz = (tmpvar_15 * v_19.xyz);
  tmpvar_20.w = tmpvar_12.y;
  highp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * unity_Scale.w);
  tmpvar_6 = tmpvar_21;
  vec4 v_22;
  v_22.x = _Object2World[0].z;
  v_22.y = _Object2World[1].z;
  v_22.z = _Object2World[2].z;
  v_22.w = _Object2World[3].z;
  highp vec4 tmpvar_23;
  tmpvar_23.xyz = (tmpvar_15 * v_22.xyz);
  tmpvar_23.w = tmpvar_12.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 * unity_Scale.w);
  tmpvar_7 = tmpvar_24;
  mat3 tmpvar_25;
  tmpvar_25[0] = _Object2World[0].xyz;
  tmpvar_25[1] = _Object2World[1].xyz;
  tmpvar_25[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_25 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_15 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_8 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_29;
  tmpvar_29.w = 1.00000;
  tmpvar_29.xyz = tmpvar_26;
  mediump vec3 tmpvar_30;
  mediump vec4 normal_31;
  normal_31 = tmpvar_29;
  mediump vec3 x3_32;
  highp float vC_33;
  mediump vec3 x2_34;
  mediump vec3 x1_35;
  highp float tmpvar_36;
  tmpvar_36 = dot (unity_SHAr, normal_31);
  x1_35.x = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = dot (unity_SHAg, normal_31);
  x1_35.y = tmpvar_37;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHAb, normal_31);
  x1_35.z = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39 = (normal_31.xyzz * normal_31.yzzx);
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHBr, tmpvar_39);
  x2_34.x = tmpvar_40;
  highp float tmpvar_41;
  tmpvar_41 = dot (unity_SHBg, tmpvar_39);
  x2_34.y = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHBb, tmpvar_39);
  x2_34.z = tmpvar_42;
  mediump float tmpvar_43;
  tmpvar_43 = ((normal_31.x * normal_31.x) - (normal_31.y * normal_31.y));
  vC_33 = tmpvar_43;
  highp vec3 tmpvar_44;
  tmpvar_44 = (unity_SHC.xyz * vC_33);
  x3_32 = tmpvar_44;
  tmpvar_30 = ((x1_35 + x2_34) + x3_32);
  shlight_3 = tmpvar_30;
  tmpvar_9 = shlight_3;
  highp vec3 tmpvar_45;
  tmpvar_45 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_46;
  tmpvar_46 = (unity_4LightPosX0 - tmpvar_45.x);
  highp vec4 tmpvar_47;
  tmpvar_47 = (unity_4LightPosY0 - tmpvar_45.y);
  highp vec4 tmpvar_48;
  tmpvar_48 = (unity_4LightPosZ0 - tmpvar_45.z);
  highp vec4 tmpvar_49;
  tmpvar_49 = (((tmpvar_46 * tmpvar_46) + (tmpvar_47 * tmpvar_47)) + (tmpvar_48 * tmpvar_48));
  highp vec4 tmpvar_50;
  tmpvar_50 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_46 * tmpvar_26.x) + (tmpvar_47 * tmpvar_26.y)) + (tmpvar_48 * tmpvar_26.z)) * inversesqrt(tmpvar_49))) * (1.0/((1.00000 + (tmpvar_49 * unity_4LightAtten0)))));
  highp vec3 tmpvar_51;
  tmpvar_51 = (tmpvar_9 + ((((unity_LightColor[0].xyz * tmpvar_50.x) + (unity_LightColor[1].xyz * tmpvar_50.y)) + (unity_LightColor[2].xyz * tmpvar_50.z)) + (unity_LightColor[3].xyz * tmpvar_50.w)));
  tmpvar_9 = tmpvar_51;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = (tmpvar_15 * (((_World2Object * tmpvar_28).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = tmpvar_6;
  xlv_TEXCOORD4 = tmpvar_7;
  xlv_TEXCOORD5 = tmpvar_8;
  xlv_TEXCOORD6 = tmpvar_9;
  xlv_TEXCOORD7 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec4 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  highp vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6.x = xlv_TEXCOORD2.w;
  tmpvar_6.y = xlv_TEXCOORD3.w;
  tmpvar_6.z = xlv_TEXCOORD4.w;
  tmpvar_2 = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD2.xyz;
  tmpvar_3 = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = xlv_TEXCOORD3.xyz;
  tmpvar_4 = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = xlv_TEXCOORD4.xyz;
  tmpvar_5 = tmpvar_9;
  mediump float h_10;
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_10 = tmpvar_11;
  highp vec2 tmpvar_12;
  mediump float height_13;
  height_13 = _Parallax;
  mediump vec3 viewDir_14;
  viewDir_14 = xlv_TEXCOORD1;
  highp vec3 v_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((h_10 * height_13) - (height_13 / 2.00000));
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(viewDir_14);
  v_15 = tmpvar_17;
  v_15.z = (v_15.z + 0.420000);
  tmpvar_12 = (tmpvar_16 * (v_15.xy / v_15.z));
  highp vec2 tmpvar_18;
  tmpvar_18 = (xlv_TEXCOORD0.xy + tmpvar_12);
  highp vec2 tmpvar_19;
  tmpvar_19 = (xlv_TEXCOORD0.zw + tmpvar_12);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_MainTex, tmpvar_18);
  lowp vec4 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * _Color);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((texture2D (_BumpMap, tmpvar_19).xyz * 2.00000) - 1.00000);
  mediump vec3 tmpvar_23;
  tmpvar_23.x = dot (tmpvar_3, tmpvar_22);
  tmpvar_23.y = dot (tmpvar_4, tmpvar_22);
  tmpvar_23.z = dot (tmpvar_5, tmpvar_22);
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 - (2.00000 * (dot (tmpvar_23, tmpvar_2) * tmpvar_23)));
  lowp vec4 tmpvar_25;
  tmpvar_25 = (textureCube (_Cube, tmpvar_24) * tmpvar_20.w);
  lowp float tmpvar_26;
  mediump float lightShadowDataX_27;
  highp float dist_28;
  lowp float tmpvar_29;
  tmpvar_29 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7).x;
  dist_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = _LightShadowData.x;
  lightShadowDataX_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = max (float((dist_28 > (xlv_TEXCOORD7.z / xlv_TEXCOORD7.w))), lightShadowDataX_27);
  tmpvar_26 = tmpvar_31;
  lowp vec4 c_32;
  c_32.xyz = ((tmpvar_21.xyz * _LightColor0.xyz) * ((max (0.000000, dot (tmpvar_22, xlv_TEXCOORD5)) * tmpvar_26) * 2.00000));
  c_32.w = (tmpvar_25.w * _ReflectColor.w);
  c_1.w = c_32.w;
  c_1.xyz = (c_32.xyz + (tmpvar_21.xyz * xlv_TEXCOORD6));
  c_1.xyz = (c_1.xyz + (tmpvar_25.xyz * _ReflectColor.xyz));
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
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec3 tmpvar_3;
  mediump float h_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_4 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_4 * height_7) - (height_7 / 2.00000));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.420000);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_12);
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_17;
  c_17.xyz = (((tmpvar_14 * _Color).xyz * _LightColor0.xyz) * ((max (0.000000, dot (((texture2D (_BumpMap, tmpvar_13).xyz * 2.00000) - 1.00000), lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_16)).w) * 2.00000));
  c_17.w = ((textureCube (_Cube, tmpvar_3) * tmpvar_14.w).w * _ReflectColor.w);
  c_1.xyz = c_17.xyz;
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
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec3 tmpvar_3;
  mediump float h_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_4 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_4 * height_7) - (height_7 / 2.00000));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.420000);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_12);
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_15;
  c_15.xyz = (((tmpvar_14 * _Color).xyz * _LightColor0.xyz) * (max (0.000000, dot (((texture2D (_BumpMap, tmpvar_13).xyz * 2.00000) - 1.00000), lightDir_2)) * 2.00000));
  c_15.w = ((textureCube (_Cube, tmpvar_3) * tmpvar_14.w).w * _ReflectColor.w);
  c_1.xyz = c_15.xyz;
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
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec3 tmpvar_3;
  mediump float h_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_4 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_4 * height_7) - (height_7 / 2.00000));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.420000);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_12);
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_15;
  highp vec2 P_16;
  P_16 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.500000);
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp float atten_18;
  atten_18 = ((float((xlv_TEXCOORD3.z > 0.000000)) * texture2D (_LightTexture0, P_16).w) * texture2D (_LightTextureB0, vec2(tmpvar_17)).w);
  lowp vec4 c_19;
  c_19.xyz = (((tmpvar_14 * _Color).xyz * _LightColor0.xyz) * ((max (0.000000, dot (((texture2D (_BumpMap, tmpvar_13).xyz * 2.00000) - 1.00000), lightDir_2)) * atten_18) * 2.00000));
  c_19.w = ((textureCube (_Cube, tmpvar_3) * tmpvar_14.w).w * _ReflectColor.w);
  c_1.xyz = c_19.xyz;
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
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec3 tmpvar_3;
  mediump float h_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_4 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_4 * height_7) - (height_7 / 2.00000));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.420000);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_12);
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(xlv_TEXCOORD2);
  lightDir_2 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 c_17;
  c_17.xyz = (((tmpvar_14 * _Color).xyz * _LightColor0.xyz) * ((max (0.000000, dot (((texture2D (_BumpMap, tmpvar_13).xyz * 2.00000) - 1.00000), lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_16)).w * textureCube (_LightTexture0, xlv_TEXCOORD3).w)) * 2.00000));
  c_17.w = ((textureCube (_Cube, tmpvar_3) * tmpvar_14.w).w * _ReflectColor.w);
  c_1.xyz = c_17.xyz;
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
uniform lowp vec4 _ReflectColor;
uniform sampler2D _ParallaxMap;
uniform highp float _Parallax;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  highp vec3 tmpvar_3;
  mediump float h_4;
  lowp float tmpvar_5;
  tmpvar_5 = texture2D (_ParallaxMap, xlv_TEXCOORD0.zw).w;
  h_4 = tmpvar_5;
  highp vec2 tmpvar_6;
  mediump float height_7;
  height_7 = _Parallax;
  mediump vec3 viewDir_8;
  viewDir_8 = xlv_TEXCOORD1;
  highp vec3 v_9;
  mediump float tmpvar_10;
  tmpvar_10 = ((h_4 * height_7) - (height_7 / 2.00000));
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(viewDir_8);
  v_9 = tmpvar_11;
  v_9.z = (v_9.z + 0.420000);
  tmpvar_6 = (tmpvar_10 * (v_9.xy / v_9.z));
  highp vec2 tmpvar_12;
  tmpvar_12 = (xlv_TEXCOORD0.xy + tmpvar_6);
  highp vec2 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.zw + tmpvar_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, tmpvar_12);
  lightDir_2 = xlv_TEXCOORD2;
  lowp vec4 c_15;
  c_15.xyz = (((tmpvar_14 * _Color).xyz * _LightColor0.xyz) * ((max (0.000000, dot (((texture2D (_BumpMap, tmpvar_13).xyz * 2.00000) - 1.00000), lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD3).w) * 2.00000));
  c_15.w = ((textureCube (_Cube, tmpvar_3) * tmpvar_14.w).w * _ReflectColor.w);
  c_1.xyz = c_15.xyz;
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
Fallback "Reflective/Bumped Diffuse"
}