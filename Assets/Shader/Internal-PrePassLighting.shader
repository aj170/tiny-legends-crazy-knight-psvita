•‡Shader "Hidden/Internal-PrePassLighting" {
Properties {
 _LightTexture0 ("", any) = "" {}
 _LightTextureB0 ("", 2D) = "" {}
 _ShadowMapTexture ("", any) = "" {}
}
SubShader { 
 Pass {
  ZWrite Off
  Fog { Mode Off }
  Blend DstColor Zero
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_18;
  tmpvar_18 = -(normalize(tmpvar_17));
  lightDir_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp float tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19)).w;
  atten_5 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (spec_3 * clamp (atten_5, 0.000000, 1.00000));
  spec_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * (tmpvar_21 * atten_5));
  res_2.xyz = tmpvar_25;
  lowp vec3 c_26;
  c_26 = _LightColor.xyz;
  lowp float tmpvar_27;
  tmpvar_27 = dot (c_26, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_24 * tmpvar_27);
  res_2.w = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_30;
  tmpvar_30 = (res_2 * tmpvar_29);
  res_2 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31 = exp2(-(tmpvar_30));
  tmpvar_1 = tmpvar_31;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec4 nspec_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_7 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(((nspec_7.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_8).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_16;
  tmpvar_16 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.000000, dot (lightDir_5, tmpvar_10));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.000000, dot (h_4, tmpvar_10)), (nspec_7.w * 128.000));
  spec_3 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (spec_3 * clamp (1.00000, 0.000000, 1.00000));
  spec_3 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_LightColor.xyz * tmpvar_17);
  res_2.xyz = tmpvar_21;
  lowp vec3 c_22;
  c_22 = _LightColor.xyz;
  lowp float tmpvar_23;
  tmpvar_23 = dot (c_22, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_24;
  tmpvar_24 = (tmpvar_20 * tmpvar_23);
  res_2.w = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.00000 - ((mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (res_2 * tmpvar_25);
  res_2 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(tmpvar_26));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(tmpvar_17);
  lightDir_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = tmpvar_15;
  highp vec4 tmpvar_20;
  tmpvar_20 = (_LightMatrix0 * tmpvar_19);
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_LightTexture0, tmpvar_20).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_LightTextureB0, vec2(tmpvar_22));
  highp float tmpvar_24;
  tmpvar_24 = ((atten_5 * float((tmpvar_20.w < 0.000000))) * tmpvar_23.w);
  atten_5 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_18;
  tmpvar_18 = -(normalize(tmpvar_17));
  lightDir_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp float tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19)).w;
  atten_5 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = tmpvar_15;
  lowp vec4 tmpvar_22;
  highp vec3 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xyz;
  tmpvar_22 = textureCube (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = (atten_5 * tmpvar_22.w);
  atten_5 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec4 nspec_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_7 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(((nspec_7.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_8).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_16;
  tmpvar_16 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.00000;
  tmpvar_17.xyz = tmpvar_14;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = tmpvar_18.w;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (lightDir_5, tmpvar_10));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.000000, dot (h_4, tmpvar_10)), (nspec_7.w * 128.000));
  spec_3 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (spec_3 * clamp (tmpvar_20, 0.000000, 1.00000));
  spec_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * (tmpvar_21 * tmpvar_20));
  res_2.xyz = tmpvar_25;
  lowp vec3 c_26;
  c_26 = _LightColor.xyz;
  lowp float tmpvar_27;
  tmpvar_27 = dot (c_26, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_24 * tmpvar_27);
  res_2.w = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.00000 - ((mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_30;
  tmpvar_30 = (res_2 * tmpvar_29);
  res_2 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31 = exp2(-(tmpvar_30));
  tmpvar_1 = tmpvar_31;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(tmpvar_18);
  lightDir_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = tmpvar_15;
  highp vec4 tmpvar_21;
  tmpvar_21 = (_LightMatrix0 * tmpvar_20);
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_LightTexture0, tmpvar_21).w;
  atten_5 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  atten_5 = ((atten_5 * float((tmpvar_21.w < 0.000000))) * tmpvar_24.w);
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (((tmpvar_17 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = tmpvar_15;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * tmpvar_27);
  mediump float shadow_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, tmpvar_28);
  highp float tmpvar_31;
  if ((tmpvar_30.x < (tmpvar_28.z / tmpvar_28.w))) {
    tmpvar_31 = _LightShadowData.x;
  } else {
    tmpvar_31 = 1.00000;
  };
  shadow_29 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((shadow_29 + tmpvar_26), 0.000000, 1.00000);
  tmpvar_25 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (atten_5 * tmpvar_25);
  atten_5 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (spec_3 * clamp (tmpvar_33, 0.000000, 1.00000));
  spec_3 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_LightColor.xyz * (tmpvar_34 * tmpvar_33));
  res_2.xyz = tmpvar_38;
  lowp vec3 c_39;
  c_39 = _LightColor.xyz;
  lowp float tmpvar_40;
  tmpvar_40 = dot (c_39, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_41;
  tmpvar_41 = (tmpvar_37 * tmpvar_40);
  res_2.w = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_43;
  tmpvar_43 = (res_2 * tmpvar_42);
  res_2 = tmpvar_43;
  mediump vec4 tmpvar_44;
  tmpvar_44 = exp2(-(tmpvar_43));
  tmpvar_1 = tmpvar_44;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec3 normal_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  normal_7 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_17;
  mediump float tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_9);
  highp float tmpvar_20;
  tmpvar_20 = clamp ((tmpvar_19.x + clamp (((tmpvar_16 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000)), 0.000000, 1.00000);
  tmpvar_18 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = tmpvar_18;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.000000, dot (lightDir_5, normal_7));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.000000, dot (h_4, normal_7)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = (spec_3 * clamp (tmpvar_21, 0.000000, 1.00000));
  spec_3 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (_LightColor.xyz * (tmpvar_22 * tmpvar_21));
  res_2.xyz = tmpvar_26;
  lowp vec3 c_27;
  c_27 = _LightColor.xyz;
  lowp float tmpvar_28;
  tmpvar_28 = dot (c_27, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_29;
  tmpvar_29 = (tmpvar_25 * tmpvar_28);
  res_2.w = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp ((1.00000 - ((tmpvar_16 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_31;
  tmpvar_31 = (res_2 * tmpvar_30);
  res_2 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec3 normal_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  normal_7 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_17;
  mediump float tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_9);
  highp float tmpvar_20;
  tmpvar_20 = clamp ((tmpvar_19.x + clamp (((tmpvar_16 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000)), 0.000000, 1.00000);
  tmpvar_18 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = tmpvar_14;
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xy;
  tmpvar_22 = texture2D (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = (tmpvar_18 * tmpvar_22.w);
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_5, normal_7));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, normal_7)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((tmpvar_16 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump float tmpvar_23;
  highp vec4 packDist_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_ShadowMapTexture, tmpvar_18);
  packDist_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (packDist_24, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp float tmpvar_27;
  if ((tmpvar_26 < tmpvar_22)) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.00000;
  };
  tmpvar_23 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_5 * tmpvar_23);
  atten_5 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (spec_3 * clamp (tmpvar_28, 0.000000, 1.00000));
  spec_3 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (_LightColor.xyz * (tmpvar_29 * tmpvar_28));
  res_2.xyz = tmpvar_33;
  lowp vec3 c_34;
  c_34 = _LightColor.xyz;
  lowp float tmpvar_35;
  tmpvar_35 = dot (c_34, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_36;
  tmpvar_36 = (tmpvar_32 * tmpvar_35);
  res_2.w = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_38;
  tmpvar_38 = (res_2 * tmpvar_37);
  res_2 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39 = exp2(-(tmpvar_38));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump float tmpvar_23;
  highp vec4 packDist_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_ShadowMapTexture, tmpvar_18);
  packDist_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (packDist_24, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp float tmpvar_27;
  if ((tmpvar_26 < tmpvar_22)) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.00000;
  };
  tmpvar_23 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = tmpvar_15;
  lowp vec4 tmpvar_29;
  highp vec3 P_30;
  P_30 = (_LightMatrix0 * tmpvar_28).xyz;
  tmpvar_29 = textureCube (_LightTexture0, P_30);
  highp float tmpvar_31;
  tmpvar_31 = ((atten_5 * tmpvar_23) * tmpvar_29.w);
  atten_5 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_31, 0.000000, 1.00000));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_31));
  res_2.xyz = tmpvar_36;
  lowp vec3 c_37;
  c_37 = _LightColor.xyz;
  lowp float tmpvar_38;
  tmpvar_38 = dot (c_37, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(tmpvar_41));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(tmpvar_18);
  lightDir_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = tmpvar_15;
  highp vec4 tmpvar_21;
  tmpvar_21 = (_LightMatrix0 * tmpvar_20);
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_LightTexture0, tmpvar_21).w;
  atten_5 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  atten_5 = ((atten_5 * float((tmpvar_21.w < 0.000000))) * tmpvar_24.w);
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (((tmpvar_17 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = tmpvar_15;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * tmpvar_27);
  mediump vec4 shadows_29;
  highp vec4 shadowVals_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_28.xyz / tmpvar_28.w);
  highp vec2 P_32;
  P_32 = (tmpvar_31.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_30.x = tmpvar_33;
  highp vec2 P_34;
  P_34 = (tmpvar_31.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, P_34).x;
  shadowVals_30.y = tmpvar_35;
  highp vec2 P_36;
  P_36 = (tmpvar_31.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, P_36).x;
  shadowVals_30.z = tmpvar_37;
  highp vec2 P_38;
  P_38 = (tmpvar_31.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, P_38).x;
  shadowVals_30.w = tmpvar_39;
  bvec4 tmpvar_40;
  tmpvar_40 = lessThan (shadowVals_30, tmpvar_31.zzzz);
  highp vec4 tmpvar_41;
  tmpvar_41 = _LightShadowData.xxxx;
  highp float tmpvar_42;
  if (tmpvar_40.x) {
    tmpvar_42 = tmpvar_41.x;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp float tmpvar_43;
  if (tmpvar_40.y) {
    tmpvar_43 = tmpvar_41.y;
  } else {
    tmpvar_43 = 1.00000;
  };
  highp float tmpvar_44;
  if (tmpvar_40.z) {
    tmpvar_44 = tmpvar_41.z;
  } else {
    tmpvar_44 = 1.00000;
  };
  highp float tmpvar_45;
  if (tmpvar_40.w) {
    tmpvar_45 = tmpvar_41.w;
  } else {
    tmpvar_45 = 1.00000;
  };
  highp vec4 tmpvar_46;
  tmpvar_46.x = tmpvar_42;
  tmpvar_46.y = tmpvar_43;
  tmpvar_46.z = tmpvar_44;
  tmpvar_46.w = tmpvar_45;
  shadows_29 = tmpvar_46;
  mediump float tmpvar_47;
  tmpvar_47 = dot (shadows_29, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((tmpvar_47 + tmpvar_26), 0.000000, 1.00000);
  tmpvar_25 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = (atten_5 * tmpvar_25);
  atten_5 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_51;
  tmpvar_51 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_51;
  mediump float tmpvar_52;
  tmpvar_52 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = (spec_3 * clamp (tmpvar_49, 0.000000, 1.00000));
  spec_3 = tmpvar_53;
  highp vec3 tmpvar_54;
  tmpvar_54 = (_LightColor.xyz * (tmpvar_50 * tmpvar_49));
  res_2.xyz = tmpvar_54;
  lowp vec3 c_55;
  c_55 = _LightColor.xyz;
  lowp float tmpvar_56;
  tmpvar_56 = dot (c_55, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_57;
  tmpvar_57 = (tmpvar_53 * tmpvar_56);
  res_2.w = tmpvar_57;
  highp float tmpvar_58;
  tmpvar_58 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_59;
  tmpvar_59 = (res_2 * tmpvar_58);
  res_2 = tmpvar_59;
  mediump vec4 tmpvar_60;
  tmpvar_60 = exp2(-(tmpvar_59));
  tmpvar_1 = tmpvar_60;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump vec4 shadows_23;
  highp vec4 shadowVals_24;
  highp vec3 vec_25;
  vec_25 = (tmpvar_18 + vec3(0.00781250, 0.00781250, 0.00781250));
  highp vec4 packDist_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_ShadowMapTexture, vec_25);
  packDist_26 = tmpvar_27;
  shadowVals_24.x = dot (packDist_26, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_28;
  vec_28 = (tmpvar_18 + vec3(-0.00781250, -0.00781250, 0.00781250));
  highp vec4 packDist_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_ShadowMapTexture, vec_28);
  packDist_29 = tmpvar_30;
  shadowVals_24.y = dot (packDist_29, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_31;
  vec_31 = (tmpvar_18 + vec3(-0.00781250, 0.00781250, -0.00781250));
  highp vec4 packDist_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_ShadowMapTexture, vec_31);
  packDist_32 = tmpvar_33;
  shadowVals_24.z = dot (packDist_32, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_34;
  vec_34 = (tmpvar_18 + vec3(0.00781250, -0.00781250, -0.00781250));
  highp vec4 packDist_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = textureCube (_ShadowMapTexture, vec_34);
  packDist_35 = tmpvar_36;
  shadowVals_24.w = dot (packDist_35, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  bvec4 tmpvar_37;
  tmpvar_37 = lessThan (shadowVals_24, vec4(tmpvar_22));
  highp vec4 tmpvar_38;
  tmpvar_38 = _LightShadowData.xxxx;
  highp float tmpvar_39;
  if (tmpvar_37.x) {
    tmpvar_39 = tmpvar_38.x;
  } else {
    tmpvar_39 = 1.00000;
  };
  highp float tmpvar_40;
  if (tmpvar_37.y) {
    tmpvar_40 = tmpvar_38.y;
  } else {
    tmpvar_40 = 1.00000;
  };
  highp float tmpvar_41;
  if (tmpvar_37.z) {
    tmpvar_41 = tmpvar_38.z;
  } else {
    tmpvar_41 = 1.00000;
  };
  highp float tmpvar_42;
  if (tmpvar_37.w) {
    tmpvar_42 = tmpvar_38.w;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp vec4 tmpvar_43;
  tmpvar_43.x = tmpvar_39;
  tmpvar_43.y = tmpvar_40;
  tmpvar_43.z = tmpvar_41;
  tmpvar_43.w = tmpvar_42;
  shadows_23 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = dot (shadows_23, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp float tmpvar_45;
  tmpvar_45 = (atten_5 * tmpvar_44);
  atten_5 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_47;
  tmpvar_47 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = (spec_3 * clamp (tmpvar_45, 0.000000, 1.00000));
  spec_3 = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (_LightColor.xyz * (tmpvar_46 * tmpvar_45));
  res_2.xyz = tmpvar_50;
  lowp vec3 c_51;
  c_51 = _LightColor.xyz;
  lowp float tmpvar_52;
  tmpvar_52 = dot (c_51, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_49 * tmpvar_52);
  res_2.w = tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_55;
  tmpvar_55 = (res_2 * tmpvar_54);
  res_2 = tmpvar_55;
  mediump vec4 tmpvar_56;
  tmpvar_56 = exp2(-(tmpvar_55));
  tmpvar_1 = tmpvar_56;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump vec4 shadows_23;
  highp vec4 shadowVals_24;
  highp vec3 vec_25;
  vec_25 = (tmpvar_18 + vec3(0.00781250, 0.00781250, 0.00781250));
  highp vec4 packDist_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_ShadowMapTexture, vec_25);
  packDist_26 = tmpvar_27;
  shadowVals_24.x = dot (packDist_26, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_28;
  vec_28 = (tmpvar_18 + vec3(-0.00781250, -0.00781250, 0.00781250));
  highp vec4 packDist_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_ShadowMapTexture, vec_28);
  packDist_29 = tmpvar_30;
  shadowVals_24.y = dot (packDist_29, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_31;
  vec_31 = (tmpvar_18 + vec3(-0.00781250, 0.00781250, -0.00781250));
  highp vec4 packDist_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_ShadowMapTexture, vec_31);
  packDist_32 = tmpvar_33;
  shadowVals_24.z = dot (packDist_32, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_34;
  vec_34 = (tmpvar_18 + vec3(0.00781250, -0.00781250, -0.00781250));
  highp vec4 packDist_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = textureCube (_ShadowMapTexture, vec_34);
  packDist_35 = tmpvar_36;
  shadowVals_24.w = dot (packDist_35, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  bvec4 tmpvar_37;
  tmpvar_37 = lessThan (shadowVals_24, vec4(tmpvar_22));
  highp vec4 tmpvar_38;
  tmpvar_38 = _LightShadowData.xxxx;
  highp float tmpvar_39;
  if (tmpvar_37.x) {
    tmpvar_39 = tmpvar_38.x;
  } else {
    tmpvar_39 = 1.00000;
  };
  highp float tmpvar_40;
  if (tmpvar_37.y) {
    tmpvar_40 = tmpvar_38.y;
  } else {
    tmpvar_40 = 1.00000;
  };
  highp float tmpvar_41;
  if (tmpvar_37.z) {
    tmpvar_41 = tmpvar_38.z;
  } else {
    tmpvar_41 = 1.00000;
  };
  highp float tmpvar_42;
  if (tmpvar_37.w) {
    tmpvar_42 = tmpvar_38.w;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp vec4 tmpvar_43;
  tmpvar_43.x = tmpvar_39;
  tmpvar_43.y = tmpvar_40;
  tmpvar_43.z = tmpvar_41;
  tmpvar_43.w = tmpvar_42;
  shadows_23 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = dot (shadows_23, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp vec4 tmpvar_45;
  tmpvar_45.w = 1.00000;
  tmpvar_45.xyz = tmpvar_15;
  lowp vec4 tmpvar_46;
  highp vec3 P_47;
  P_47 = (_LightMatrix0 * tmpvar_45).xyz;
  tmpvar_46 = textureCube (_LightTexture0, P_47);
  highp float tmpvar_48;
  tmpvar_48 = ((atten_5 * tmpvar_44) * tmpvar_46.w);
  atten_5 = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_50;
  tmpvar_50 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_50;
  mediump float tmpvar_51;
  tmpvar_51 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = (spec_3 * clamp (tmpvar_48, 0.000000, 1.00000));
  spec_3 = tmpvar_52;
  highp vec3 tmpvar_53;
  tmpvar_53 = (_LightColor.xyz * (tmpvar_49 * tmpvar_48));
  res_2.xyz = tmpvar_53;
  lowp vec3 c_54;
  c_54 = _LightColor.xyz;
  lowp float tmpvar_55;
  tmpvar_55 = dot (c_54, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_56;
  tmpvar_56 = (tmpvar_52 * tmpvar_55);
  res_2.w = tmpvar_56;
  highp float tmpvar_57;
  tmpvar_57 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_58;
  tmpvar_58 = (res_2 * tmpvar_57);
  res_2 = tmpvar_58;
  mediump vec4 tmpvar_59;
  tmpvar_59 = exp2(-(tmpvar_58));
  tmpvar_1 = tmpvar_59;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
}
 }
 Pass {
  ZWrite Off
  Fog { Mode Off }
  Blend One One
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_18;
  tmpvar_18 = -(normalize(tmpvar_17));
  lightDir_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp float tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19)).w;
  atten_5 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (spec_3 * clamp (atten_5, 0.000000, 1.00000));
  spec_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * (tmpvar_21 * atten_5));
  res_2.xyz = tmpvar_25;
  lowp vec3 c_26;
  c_26 = _LightColor.xyz;
  lowp float tmpvar_27;
  tmpvar_27 = dot (c_26, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_24 * tmpvar_27);
  res_2.w = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_30;
  tmpvar_30 = (res_2 * tmpvar_29);
  res_2 = tmpvar_30;
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec4 nspec_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_7 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(((nspec_7.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_8).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_16;
  tmpvar_16 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.000000, dot (lightDir_5, tmpvar_10));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.000000, dot (h_4, tmpvar_10)), (nspec_7.w * 128.000));
  spec_3 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (spec_3 * clamp (1.00000, 0.000000, 1.00000));
  spec_3 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_LightColor.xyz * tmpvar_17);
  res_2.xyz = tmpvar_21;
  lowp vec3 c_22;
  c_22 = _LightColor.xyz;
  lowp float tmpvar_23;
  tmpvar_23 = dot (c_22, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_24;
  tmpvar_24 = (tmpvar_20 * tmpvar_23);
  res_2.w = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.00000 - ((mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (res_2 * tmpvar_25);
  res_2 = tmpvar_26;
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(tmpvar_17);
  lightDir_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = tmpvar_15;
  highp vec4 tmpvar_20;
  tmpvar_20 = (_LightMatrix0 * tmpvar_19);
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_LightTexture0, tmpvar_20).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_LightTextureB0, vec2(tmpvar_22));
  highp float tmpvar_24;
  tmpvar_24 = ((atten_5 * float((tmpvar_20.w < 0.000000))) * tmpvar_23.w);
  atten_5 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_18;
  tmpvar_18 = -(normalize(tmpvar_17));
  lightDir_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp float tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19)).w;
  atten_5 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = tmpvar_15;
  lowp vec4 tmpvar_22;
  highp vec3 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xyz;
  tmpvar_22 = textureCube (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = (atten_5 * tmpvar_22.w);
  atten_5 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec4 nspec_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_7 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(((nspec_7.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_8).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_16;
  tmpvar_16 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.00000;
  tmpvar_17.xyz = tmpvar_14;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = tmpvar_18.w;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (lightDir_5, tmpvar_10));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.000000, dot (h_4, tmpvar_10)), (nspec_7.w * 128.000));
  spec_3 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (spec_3 * clamp (tmpvar_20, 0.000000, 1.00000));
  spec_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * (tmpvar_21 * tmpvar_20));
  res_2.xyz = tmpvar_25;
  lowp vec3 c_26;
  c_26 = _LightColor.xyz;
  lowp float tmpvar_27;
  tmpvar_27 = dot (c_26, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_24 * tmpvar_27);
  res_2.w = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.00000 - ((mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_30;
  tmpvar_30 = (res_2 * tmpvar_29);
  res_2 = tmpvar_30;
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(tmpvar_18);
  lightDir_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = tmpvar_15;
  highp vec4 tmpvar_21;
  tmpvar_21 = (_LightMatrix0 * tmpvar_20);
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_LightTexture0, tmpvar_21).w;
  atten_5 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  atten_5 = ((atten_5 * float((tmpvar_21.w < 0.000000))) * tmpvar_24.w);
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (((tmpvar_17 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = tmpvar_15;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * tmpvar_27);
  mediump float shadow_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, tmpvar_28);
  highp float tmpvar_31;
  if ((tmpvar_30.x < (tmpvar_28.z / tmpvar_28.w))) {
    tmpvar_31 = _LightShadowData.x;
  } else {
    tmpvar_31 = 1.00000;
  };
  shadow_29 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((shadow_29 + tmpvar_26), 0.000000, 1.00000);
  tmpvar_25 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (atten_5 * tmpvar_25);
  atten_5 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (spec_3 * clamp (tmpvar_33, 0.000000, 1.00000));
  spec_3 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_LightColor.xyz * (tmpvar_34 * tmpvar_33));
  res_2.xyz = tmpvar_38;
  lowp vec3 c_39;
  c_39 = _LightColor.xyz;
  lowp float tmpvar_40;
  tmpvar_40 = dot (c_39, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_41;
  tmpvar_41 = (tmpvar_37 * tmpvar_40);
  res_2.w = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_43;
  tmpvar_43 = (res_2 * tmpvar_42);
  res_2 = tmpvar_43;
  tmpvar_1 = tmpvar_43;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec3 normal_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  normal_7 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_17;
  mediump float tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_9);
  highp float tmpvar_20;
  tmpvar_20 = clamp ((tmpvar_19.x + clamp (((tmpvar_16 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000)), 0.000000, 1.00000);
  tmpvar_18 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = tmpvar_18;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.000000, dot (lightDir_5, normal_7));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.000000, dot (h_4, normal_7)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = (spec_3 * clamp (tmpvar_21, 0.000000, 1.00000));
  spec_3 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (_LightColor.xyz * (tmpvar_22 * tmpvar_21));
  res_2.xyz = tmpvar_26;
  lowp vec3 c_27;
  c_27 = _LightColor.xyz;
  lowp float tmpvar_28;
  tmpvar_28 = dot (c_27, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_29;
  tmpvar_29 = (tmpvar_25 * tmpvar_28);
  res_2.w = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp ((1.00000 - ((tmpvar_16 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_31;
  tmpvar_31 = (res_2 * tmpvar_30);
  res_2 = tmpvar_31;
  tmpvar_1 = tmpvar_31;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec3 normal_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  normal_7 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_17;
  mediump float tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_9);
  highp float tmpvar_20;
  tmpvar_20 = clamp ((tmpvar_19.x + clamp (((tmpvar_16 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000)), 0.000000, 1.00000);
  tmpvar_18 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = tmpvar_14;
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xy;
  tmpvar_22 = texture2D (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = (tmpvar_18 * tmpvar_22.w);
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_5, normal_7));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, normal_7)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((tmpvar_16 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump float tmpvar_23;
  highp vec4 packDist_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_ShadowMapTexture, tmpvar_18);
  packDist_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (packDist_24, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp float tmpvar_27;
  if ((tmpvar_26 < tmpvar_22)) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.00000;
  };
  tmpvar_23 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_5 * tmpvar_23);
  atten_5 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (spec_3 * clamp (tmpvar_28, 0.000000, 1.00000));
  spec_3 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (_LightColor.xyz * (tmpvar_29 * tmpvar_28));
  res_2.xyz = tmpvar_33;
  lowp vec3 c_34;
  c_34 = _LightColor.xyz;
  lowp float tmpvar_35;
  tmpvar_35 = dot (c_34, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_36;
  tmpvar_36 = (tmpvar_32 * tmpvar_35);
  res_2.w = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_38;
  tmpvar_38 = (res_2 * tmpvar_37);
  res_2 = tmpvar_38;
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump float tmpvar_23;
  highp vec4 packDist_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_ShadowMapTexture, tmpvar_18);
  packDist_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (packDist_24, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp float tmpvar_27;
  if ((tmpvar_26 < tmpvar_22)) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.00000;
  };
  tmpvar_23 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = tmpvar_15;
  lowp vec4 tmpvar_29;
  highp vec3 P_30;
  P_30 = (_LightMatrix0 * tmpvar_28).xyz;
  tmpvar_29 = textureCube (_LightTexture0, P_30);
  highp float tmpvar_31;
  tmpvar_31 = ((atten_5 * tmpvar_23) * tmpvar_29.w);
  atten_5 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_31, 0.000000, 1.00000));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_31));
  res_2.xyz = tmpvar_36;
  lowp vec3 c_37;
  c_37 = _LightColor.xyz;
  lowp float tmpvar_38;
  tmpvar_38 = dot (c_37, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  tmpvar_1 = tmpvar_41;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(tmpvar_18);
  lightDir_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = tmpvar_15;
  highp vec4 tmpvar_21;
  tmpvar_21 = (_LightMatrix0 * tmpvar_20);
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_LightTexture0, tmpvar_21).w;
  atten_5 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  atten_5 = ((atten_5 * float((tmpvar_21.w < 0.000000))) * tmpvar_24.w);
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (((tmpvar_17 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = tmpvar_15;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * tmpvar_27);
  mediump vec4 shadows_29;
  highp vec4 shadowVals_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_28.xyz / tmpvar_28.w);
  highp vec2 P_32;
  P_32 = (tmpvar_31.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_30.x = tmpvar_33;
  highp vec2 P_34;
  P_34 = (tmpvar_31.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, P_34).x;
  shadowVals_30.y = tmpvar_35;
  highp vec2 P_36;
  P_36 = (tmpvar_31.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, P_36).x;
  shadowVals_30.z = tmpvar_37;
  highp vec2 P_38;
  P_38 = (tmpvar_31.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, P_38).x;
  shadowVals_30.w = tmpvar_39;
  bvec4 tmpvar_40;
  tmpvar_40 = lessThan (shadowVals_30, tmpvar_31.zzzz);
  highp vec4 tmpvar_41;
  tmpvar_41 = _LightShadowData.xxxx;
  highp float tmpvar_42;
  if (tmpvar_40.x) {
    tmpvar_42 = tmpvar_41.x;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp float tmpvar_43;
  if (tmpvar_40.y) {
    tmpvar_43 = tmpvar_41.y;
  } else {
    tmpvar_43 = 1.00000;
  };
  highp float tmpvar_44;
  if (tmpvar_40.z) {
    tmpvar_44 = tmpvar_41.z;
  } else {
    tmpvar_44 = 1.00000;
  };
  highp float tmpvar_45;
  if (tmpvar_40.w) {
    tmpvar_45 = tmpvar_41.w;
  } else {
    tmpvar_45 = 1.00000;
  };
  highp vec4 tmpvar_46;
  tmpvar_46.x = tmpvar_42;
  tmpvar_46.y = tmpvar_43;
  tmpvar_46.z = tmpvar_44;
  tmpvar_46.w = tmpvar_45;
  shadows_29 = tmpvar_46;
  mediump float tmpvar_47;
  tmpvar_47 = dot (shadows_29, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((tmpvar_47 + tmpvar_26), 0.000000, 1.00000);
  tmpvar_25 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = (atten_5 * tmpvar_25);
  atten_5 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_51;
  tmpvar_51 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_51;
  mediump float tmpvar_52;
  tmpvar_52 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = (spec_3 * clamp (tmpvar_49, 0.000000, 1.00000));
  spec_3 = tmpvar_53;
  highp vec3 tmpvar_54;
  tmpvar_54 = (_LightColor.xyz * (tmpvar_50 * tmpvar_49));
  res_2.xyz = tmpvar_54;
  lowp vec3 c_55;
  c_55 = _LightColor.xyz;
  lowp float tmpvar_56;
  tmpvar_56 = dot (c_55, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_57;
  tmpvar_57 = (tmpvar_53 * tmpvar_56);
  res_2.w = tmpvar_57;
  highp float tmpvar_58;
  tmpvar_58 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_59;
  tmpvar_59 = (res_2 * tmpvar_58);
  res_2 = tmpvar_59;
  tmpvar_1 = tmpvar_59;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump vec4 shadows_23;
  highp vec4 shadowVals_24;
  highp vec3 vec_25;
  vec_25 = (tmpvar_18 + vec3(0.00781250, 0.00781250, 0.00781250));
  highp vec4 packDist_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_ShadowMapTexture, vec_25);
  packDist_26 = tmpvar_27;
  shadowVals_24.x = dot (packDist_26, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_28;
  vec_28 = (tmpvar_18 + vec3(-0.00781250, -0.00781250, 0.00781250));
  highp vec4 packDist_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_ShadowMapTexture, vec_28);
  packDist_29 = tmpvar_30;
  shadowVals_24.y = dot (packDist_29, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_31;
  vec_31 = (tmpvar_18 + vec3(-0.00781250, 0.00781250, -0.00781250));
  highp vec4 packDist_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_ShadowMapTexture, vec_31);
  packDist_32 = tmpvar_33;
  shadowVals_24.z = dot (packDist_32, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_34;
  vec_34 = (tmpvar_18 + vec3(0.00781250, -0.00781250, -0.00781250));
  highp vec4 packDist_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = textureCube (_ShadowMapTexture, vec_34);
  packDist_35 = tmpvar_36;
  shadowVals_24.w = dot (packDist_35, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  bvec4 tmpvar_37;
  tmpvar_37 = lessThan (shadowVals_24, vec4(tmpvar_22));
  highp vec4 tmpvar_38;
  tmpvar_38 = _LightShadowData.xxxx;
  highp float tmpvar_39;
  if (tmpvar_37.x) {
    tmpvar_39 = tmpvar_38.x;
  } else {
    tmpvar_39 = 1.00000;
  };
  highp float tmpvar_40;
  if (tmpvar_37.y) {
    tmpvar_40 = tmpvar_38.y;
  } else {
    tmpvar_40 = 1.00000;
  };
  highp float tmpvar_41;
  if (tmpvar_37.z) {
    tmpvar_41 = tmpvar_38.z;
  } else {
    tmpvar_41 = 1.00000;
  };
  highp float tmpvar_42;
  if (tmpvar_37.w) {
    tmpvar_42 = tmpvar_38.w;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp vec4 tmpvar_43;
  tmpvar_43.x = tmpvar_39;
  tmpvar_43.y = tmpvar_40;
  tmpvar_43.z = tmpvar_41;
  tmpvar_43.w = tmpvar_42;
  shadows_23 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = dot (shadows_23, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp float tmpvar_45;
  tmpvar_45 = (atten_5 * tmpvar_44);
  atten_5 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_47;
  tmpvar_47 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = (spec_3 * clamp (tmpvar_45, 0.000000, 1.00000));
  spec_3 = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (_LightColor.xyz * (tmpvar_46 * tmpvar_45));
  res_2.xyz = tmpvar_50;
  lowp vec3 c_51;
  c_51 = _LightColor.xyz;
  lowp float tmpvar_52;
  tmpvar_52 = dot (c_51, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_49 * tmpvar_52);
  res_2.w = tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_55;
  tmpvar_55 = (res_2 * tmpvar_54);
  res_2 = tmpvar_55;
  tmpvar_1 = tmpvar_55;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump vec4 shadows_23;
  highp vec4 shadowVals_24;
  highp vec3 vec_25;
  vec_25 = (tmpvar_18 + vec3(0.00781250, 0.00781250, 0.00781250));
  highp vec4 packDist_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_ShadowMapTexture, vec_25);
  packDist_26 = tmpvar_27;
  shadowVals_24.x = dot (packDist_26, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_28;
  vec_28 = (tmpvar_18 + vec3(-0.00781250, -0.00781250, 0.00781250));
  highp vec4 packDist_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_ShadowMapTexture, vec_28);
  packDist_29 = tmpvar_30;
  shadowVals_24.y = dot (packDist_29, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_31;
  vec_31 = (tmpvar_18 + vec3(-0.00781250, 0.00781250, -0.00781250));
  highp vec4 packDist_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_ShadowMapTexture, vec_31);
  packDist_32 = tmpvar_33;
  shadowVals_24.z = dot (packDist_32, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_34;
  vec_34 = (tmpvar_18 + vec3(0.00781250, -0.00781250, -0.00781250));
  highp vec4 packDist_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = textureCube (_ShadowMapTexture, vec_34);
  packDist_35 = tmpvar_36;
  shadowVals_24.w = dot (packDist_35, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  bvec4 tmpvar_37;
  tmpvar_37 = lessThan (shadowVals_24, vec4(tmpvar_22));
  highp vec4 tmpvar_38;
  tmpvar_38 = _LightShadowData.xxxx;
  highp float tmpvar_39;
  if (tmpvar_37.x) {
    tmpvar_39 = tmpvar_38.x;
  } else {
    tmpvar_39 = 1.00000;
  };
  highp float tmpvar_40;
  if (tmpvar_37.y) {
    tmpvar_40 = tmpvar_38.y;
  } else {
    tmpvar_40 = 1.00000;
  };
  highp float tmpvar_41;
  if (tmpvar_37.z) {
    tmpvar_41 = tmpvar_38.z;
  } else {
    tmpvar_41 = 1.00000;
  };
  highp float tmpvar_42;
  if (tmpvar_37.w) {
    tmpvar_42 = tmpvar_38.w;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp vec4 tmpvar_43;
  tmpvar_43.x = tmpvar_39;
  tmpvar_43.y = tmpvar_40;
  tmpvar_43.z = tmpvar_41;
  tmpvar_43.w = tmpvar_42;
  shadows_23 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = dot (shadows_23, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp vec4 tmpvar_45;
  tmpvar_45.w = 1.00000;
  tmpvar_45.xyz = tmpvar_15;
  lowp vec4 tmpvar_46;
  highp vec3 P_47;
  P_47 = (_LightMatrix0 * tmpvar_45).xyz;
  tmpvar_46 = textureCube (_LightTexture0, P_47);
  highp float tmpvar_48;
  tmpvar_48 = ((atten_5 * tmpvar_44) * tmpvar_46.w);
  atten_5 = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_50;
  tmpvar_50 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_50;
  mediump float tmpvar_51;
  tmpvar_51 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = (spec_3 * clamp (tmpvar_48, 0.000000, 1.00000));
  spec_3 = tmpvar_52;
  highp vec3 tmpvar_53;
  tmpvar_53 = (_LightColor.xyz * (tmpvar_49 * tmpvar_48));
  res_2.xyz = tmpvar_53;
  lowp vec3 c_54;
  c_54 = _LightColor.xyz;
  lowp float tmpvar_55;
  tmpvar_55 = dot (c_54, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_56;
  tmpvar_56 = (tmpvar_52 * tmpvar_55);
  res_2.w = tmpvar_56;
  highp float tmpvar_57;
  tmpvar_57 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_58;
  tmpvar_58 = (res_2 * tmpvar_57);
  res_2 = tmpvar_58;
  tmpvar_1 = tmpvar_58;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
}
 }
 Pass {
  ZWrite Off
  Fog { Mode Off }
  Blend One One
Program "vp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_18;
  tmpvar_18 = -(normalize(tmpvar_17));
  lightDir_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp float tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19)).w;
  atten_5 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (spec_3 * clamp (atten_5, 0.000000, 1.00000));
  spec_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * (tmpvar_21 * atten_5));
  res_2.xyz = tmpvar_25;
  lowp vec3 c_26;
  c_26 = _LightColor.xyz;
  lowp float tmpvar_27;
  tmpvar_27 = dot (c_26, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_24 * tmpvar_27);
  res_2.w = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_30;
  tmpvar_30 = (res_2 * tmpvar_29);
  res_2 = tmpvar_30;
  tmpvar_1 = tmpvar_30.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec4 nspec_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_7 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(((nspec_7.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_8).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_16;
  tmpvar_16 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = max (0.000000, dot (lightDir_5, tmpvar_10));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.000000, dot (h_4, tmpvar_10)), (nspec_7.w * 128.000));
  spec_3 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (spec_3 * clamp (1.00000, 0.000000, 1.00000));
  spec_3 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (_LightColor.xyz * tmpvar_17);
  res_2.xyz = tmpvar_21;
  lowp vec3 c_22;
  c_22 = _LightColor.xyz;
  lowp float tmpvar_23;
  tmpvar_23 = dot (c_22, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_24;
  tmpvar_24 = (tmpvar_20 * tmpvar_23);
  res_2.w = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.00000 - ((mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (res_2 * tmpvar_25);
  res_2 = tmpvar_26;
  tmpvar_1 = tmpvar_26.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize(tmpvar_17);
  lightDir_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = tmpvar_15;
  highp vec4 tmpvar_20;
  tmpvar_20 = (_LightMatrix0 * tmpvar_19);
  lowp float tmpvar_21;
  tmpvar_21 = texture2DProj (_LightTexture0, tmpvar_20).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_LightTextureB0, vec2(tmpvar_22));
  highp float tmpvar_24;
  tmpvar_24 = ((atten_5 * float((tmpvar_20.w < 0.000000))) * tmpvar_23.w);
  atten_5 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_17;
  tmpvar_17 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_18;
  tmpvar_18 = -(normalize(tmpvar_17));
  lightDir_6 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = (dot (tmpvar_17, tmpvar_17) * _LightPos.w);
  lowp float tmpvar_20;
  tmpvar_20 = texture2D (_LightTextureB0, vec2(tmpvar_19)).w;
  atten_5 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = tmpvar_15;
  lowp vec4 tmpvar_22;
  highp vec3 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xyz;
  tmpvar_22 = textureCube (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = (atten_5 * tmpvar_22.w);
  atten_5 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_6, tmpvar_11));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, tmpvar_11)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec4 nspec_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraNormalsTexture, tmpvar_8);
  nspec_7 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = normalize(((nspec_7.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_8).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_16;
  tmpvar_16 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.00000;
  tmpvar_17.xyz = tmpvar_14;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (_LightMatrix0 * tmpvar_17).xy;
  tmpvar_18 = texture2D (_LightTexture0, P_19);
  highp float tmpvar_20;
  tmpvar_20 = tmpvar_18.w;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.000000, dot (lightDir_5, tmpvar_10));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.000000, dot (h_4, tmpvar_10)), (nspec_7.w * 128.000));
  spec_3 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = (spec_3 * clamp (tmpvar_20, 0.000000, 1.00000));
  spec_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_LightColor.xyz * (tmpvar_21 * tmpvar_20));
  res_2.xyz = tmpvar_25;
  lowp vec3 c_26;
  c_26 = _LightColor.xyz;
  lowp float tmpvar_27;
  tmpvar_27 = dot (c_26, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_28;
  tmpvar_28 = (tmpvar_24 * tmpvar_27);
  res_2.w = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.00000 - ((mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_30;
  tmpvar_30 = (res_2 * tmpvar_29);
  res_2 = tmpvar_30;
  tmpvar_1 = tmpvar_30.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(tmpvar_18);
  lightDir_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = tmpvar_15;
  highp vec4 tmpvar_21;
  tmpvar_21 = (_LightMatrix0 * tmpvar_20);
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_LightTexture0, tmpvar_21).w;
  atten_5 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  atten_5 = ((atten_5 * float((tmpvar_21.w < 0.000000))) * tmpvar_24.w);
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (((tmpvar_17 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = tmpvar_15;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * tmpvar_27);
  mediump float shadow_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, tmpvar_28);
  highp float tmpvar_31;
  if ((tmpvar_30.x < (tmpvar_28.z / tmpvar_28.w))) {
    tmpvar_31 = _LightShadowData.x;
  } else {
    tmpvar_31 = 1.00000;
  };
  shadow_29 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = clamp ((shadow_29 + tmpvar_26), 0.000000, 1.00000);
  tmpvar_25 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = (atten_5 * tmpvar_25);
  atten_5 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_35;
  tmpvar_35 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_35;
  mediump float tmpvar_36;
  tmpvar_36 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = (spec_3 * clamp (tmpvar_33, 0.000000, 1.00000));
  spec_3 = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (_LightColor.xyz * (tmpvar_34 * tmpvar_33));
  res_2.xyz = tmpvar_38;
  lowp vec3 c_39;
  c_39 = _LightColor.xyz;
  lowp float tmpvar_40;
  tmpvar_40 = dot (c_39, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_41;
  tmpvar_41 = (tmpvar_37 * tmpvar_40);
  res_2.w = tmpvar_41;
  highp float tmpvar_42;
  tmpvar_42 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_43;
  tmpvar_43 = (res_2 * tmpvar_42);
  res_2 = tmpvar_43;
  tmpvar_1 = tmpvar_43.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec3 normal_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  normal_7 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_17;
  mediump float tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_9);
  highp float tmpvar_20;
  tmpvar_20 = clamp ((tmpvar_19.x + clamp (((tmpvar_16 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000)), 0.000000, 1.00000);
  tmpvar_18 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = tmpvar_18;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.000000, dot (lightDir_5, normal_7));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow (max (0.000000, dot (h_4, normal_7)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = (spec_3 * clamp (tmpvar_21, 0.000000, 1.00000));
  spec_3 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (_LightColor.xyz * (tmpvar_22 * tmpvar_21));
  res_2.xyz = tmpvar_26;
  lowp vec3 c_27;
  c_27 = _LightColor.xyz;
  lowp float tmpvar_28;
  tmpvar_28 = dot (c_27, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_29;
  tmpvar_29 = (tmpvar_25 * tmpvar_28);
  res_2.w = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp ((1.00000 - ((tmpvar_16 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_31;
  tmpvar_31 = (res_2 * tmpvar_30);
  res_2 = tmpvar_31;
  tmpvar_1 = tmpvar_31.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec3 lightDir_5;
  highp float depth_6;
  mediump vec3 normal_7;
  mediump vec4 nspec_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraNormalsTexture, tmpvar_9);
  nspec_8 = tmpvar_10;
  normal_7 = normalize(((nspec_8.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_11;
  tmpvar_11 = texture2D (_CameraDepthTexture, tmpvar_9).x;
  depth_6 = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = (1.0/(((_ZBufferParams.x * depth_6) + _ZBufferParams.y)));
  depth_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_12);
  highp vec3 tmpvar_14;
  tmpvar_14 = (_CameraToWorld * tmpvar_13).xyz;
  highp vec3 p_15;
  p_15 = (tmpvar_14 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_16;
  tmpvar_16 = mix (tmpvar_13.z, sqrt(dot (p_15, p_15)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_17;
  tmpvar_17 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_17;
  mediump float tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_9);
  highp float tmpvar_20;
  tmpvar_20 = clamp ((tmpvar_19.x + clamp (((tmpvar_16 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000)), 0.000000, 1.00000);
  tmpvar_18 = tmpvar_20;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = tmpvar_14;
  lowp vec4 tmpvar_22;
  highp vec2 P_23;
  P_23 = (_LightMatrix0 * tmpvar_21).xy;
  tmpvar_22 = texture2D (_LightTexture0, P_23);
  highp float tmpvar_24;
  tmpvar_24 = (tmpvar_18 * tmpvar_22.w);
  mediump float tmpvar_25;
  tmpvar_25 = max (0.000000, dot (lightDir_5, normal_7));
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize((lightDir_5 - normalize((tmpvar_14 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = pow (max (0.000000, dot (h_4, normal_7)), (nspec_8.w * 128.000));
  spec_3 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (spec_3 * clamp (tmpvar_24, 0.000000, 1.00000));
  spec_3 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_LightColor.xyz * (tmpvar_25 * tmpvar_24));
  res_2.xyz = tmpvar_29;
  lowp vec3 c_30;
  c_30 = _LightColor.xyz;
  lowp float tmpvar_31;
  tmpvar_31 = dot (c_30, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (tmpvar_28 * tmpvar_31);
  res_2.w = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.00000 - ((tmpvar_16 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_2 * tmpvar_33);
  res_2 = tmpvar_34;
  tmpvar_1 = tmpvar_34.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump float tmpvar_23;
  highp vec4 packDist_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_ShadowMapTexture, tmpvar_18);
  packDist_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (packDist_24, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp float tmpvar_27;
  if ((tmpvar_26 < tmpvar_22)) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.00000;
  };
  tmpvar_23 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = (atten_5 * tmpvar_23);
  atten_5 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = (spec_3 * clamp (tmpvar_28, 0.000000, 1.00000));
  spec_3 = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = (_LightColor.xyz * (tmpvar_29 * tmpvar_28));
  res_2.xyz = tmpvar_33;
  lowp vec3 c_34;
  c_34 = _LightColor.xyz;
  lowp float tmpvar_35;
  tmpvar_35 = dot (c_34, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_36;
  tmpvar_36 = (tmpvar_32 * tmpvar_35);
  res_2.w = tmpvar_36;
  highp float tmpvar_37;
  tmpvar_37 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_38;
  tmpvar_38 = (res_2 * tmpvar_37);
  res_2 = tmpvar_38;
  tmpvar_1 = tmpvar_38.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump float tmpvar_23;
  highp vec4 packDist_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = textureCube (_ShadowMapTexture, tmpvar_18);
  packDist_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (packDist_24, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp float tmpvar_27;
  if ((tmpvar_26 < tmpvar_22)) {
    tmpvar_27 = _LightShadowData.x;
  } else {
    tmpvar_27 = 1.00000;
  };
  tmpvar_23 = tmpvar_27;
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.00000;
  tmpvar_28.xyz = tmpvar_15;
  lowp vec4 tmpvar_29;
  highp vec3 P_30;
  P_30 = (_LightMatrix0 * tmpvar_28).xyz;
  tmpvar_29 = textureCube (_LightTexture0, P_30);
  highp float tmpvar_31;
  tmpvar_31 = ((atten_5 * tmpvar_23) * tmpvar_29.w);
  atten_5 = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_33;
  mediump float tmpvar_34;
  tmpvar_34 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = (spec_3 * clamp (tmpvar_31, 0.000000, 1.00000));
  spec_3 = tmpvar_35;
  highp vec3 tmpvar_36;
  tmpvar_36 = (_LightColor.xyz * (tmpvar_32 * tmpvar_31));
  res_2.xyz = tmpvar_36;
  lowp vec3 c_37;
  c_37 = _LightColor.xyz;
  lowp float tmpvar_38;
  tmpvar_38 = dot (c_37, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_39;
  tmpvar_39 = (tmpvar_35 * tmpvar_38);
  res_2.w = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_2 * tmpvar_40);
  res_2 = tmpvar_41;
  tmpvar_1 = tmpvar_41.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (_LightPos.xyz - tmpvar_15);
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize(tmpvar_18);
  lightDir_6 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = tmpvar_15;
  highp vec4 tmpvar_21;
  tmpvar_21 = (_LightMatrix0 * tmpvar_20);
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_LightTexture0, tmpvar_21).w;
  atten_5 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_LightTextureB0, vec2(tmpvar_23));
  atten_5 = ((atten_5 * float((tmpvar_21.w < 0.000000))) * tmpvar_24.w);
  mediump float tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = clamp (((tmpvar_17 * _LightShadowData.z) + _LightShadowData.w), 0.000000, 1.00000);
  highp vec4 tmpvar_27;
  tmpvar_27.w = 1.00000;
  tmpvar_27.xyz = tmpvar_15;
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_World2Shadow[0] * tmpvar_27);
  mediump vec4 shadows_29;
  highp vec4 shadowVals_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_28.xyz / tmpvar_28.w);
  highp vec2 P_32;
  P_32 = (tmpvar_31.xy + _ShadowOffsets[0].xy);
  lowp float tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, P_32).x;
  shadowVals_30.x = tmpvar_33;
  highp vec2 P_34;
  P_34 = (tmpvar_31.xy + _ShadowOffsets[1].xy);
  lowp float tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, P_34).x;
  shadowVals_30.y = tmpvar_35;
  highp vec2 P_36;
  P_36 = (tmpvar_31.xy + _ShadowOffsets[2].xy);
  lowp float tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, P_36).x;
  shadowVals_30.z = tmpvar_37;
  highp vec2 P_38;
  P_38 = (tmpvar_31.xy + _ShadowOffsets[3].xy);
  lowp float tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, P_38).x;
  shadowVals_30.w = tmpvar_39;
  bvec4 tmpvar_40;
  tmpvar_40 = lessThan (shadowVals_30, tmpvar_31.zzzz);
  highp vec4 tmpvar_41;
  tmpvar_41 = _LightShadowData.xxxx;
  highp float tmpvar_42;
  if (tmpvar_40.x) {
    tmpvar_42 = tmpvar_41.x;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp float tmpvar_43;
  if (tmpvar_40.y) {
    tmpvar_43 = tmpvar_41.y;
  } else {
    tmpvar_43 = 1.00000;
  };
  highp float tmpvar_44;
  if (tmpvar_40.z) {
    tmpvar_44 = tmpvar_41.z;
  } else {
    tmpvar_44 = 1.00000;
  };
  highp float tmpvar_45;
  if (tmpvar_40.w) {
    tmpvar_45 = tmpvar_41.w;
  } else {
    tmpvar_45 = 1.00000;
  };
  highp vec4 tmpvar_46;
  tmpvar_46.x = tmpvar_42;
  tmpvar_46.y = tmpvar_43;
  tmpvar_46.z = tmpvar_44;
  tmpvar_46.w = tmpvar_45;
  shadows_29 = tmpvar_46;
  mediump float tmpvar_47;
  tmpvar_47 = dot (shadows_29, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((tmpvar_47 + tmpvar_26), 0.000000, 1.00000);
  tmpvar_25 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = (atten_5 * tmpvar_25);
  atten_5 = tmpvar_49;
  mediump float tmpvar_50;
  tmpvar_50 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_51;
  tmpvar_51 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_51;
  mediump float tmpvar_52;
  tmpvar_52 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_52;
  highp float tmpvar_53;
  tmpvar_53 = (spec_3 * clamp (tmpvar_49, 0.000000, 1.00000));
  spec_3 = tmpvar_53;
  highp vec3 tmpvar_54;
  tmpvar_54 = (_LightColor.xyz * (tmpvar_50 * tmpvar_49));
  res_2.xyz = tmpvar_54;
  lowp vec3 c_55;
  c_55 = _LightColor.xyz;
  lowp float tmpvar_56;
  tmpvar_56 = dot (c_55, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_57;
  tmpvar_57 = (tmpvar_53 * tmpvar_56);
  res_2.w = tmpvar_57;
  highp float tmpvar_58;
  tmpvar_58 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_59;
  tmpvar_59 = (res_2 * tmpvar_58);
  res_2 = tmpvar_59;
  tmpvar_1 = tmpvar_59.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump vec4 shadows_23;
  highp vec4 shadowVals_24;
  highp vec3 vec_25;
  vec_25 = (tmpvar_18 + vec3(0.00781250, 0.00781250, 0.00781250));
  highp vec4 packDist_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_ShadowMapTexture, vec_25);
  packDist_26 = tmpvar_27;
  shadowVals_24.x = dot (packDist_26, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_28;
  vec_28 = (tmpvar_18 + vec3(-0.00781250, -0.00781250, 0.00781250));
  highp vec4 packDist_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_ShadowMapTexture, vec_28);
  packDist_29 = tmpvar_30;
  shadowVals_24.y = dot (packDist_29, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_31;
  vec_31 = (tmpvar_18 + vec3(-0.00781250, 0.00781250, -0.00781250));
  highp vec4 packDist_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_ShadowMapTexture, vec_31);
  packDist_32 = tmpvar_33;
  shadowVals_24.z = dot (packDist_32, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_34;
  vec_34 = (tmpvar_18 + vec3(0.00781250, -0.00781250, -0.00781250));
  highp vec4 packDist_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = textureCube (_ShadowMapTexture, vec_34);
  packDist_35 = tmpvar_36;
  shadowVals_24.w = dot (packDist_35, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  bvec4 tmpvar_37;
  tmpvar_37 = lessThan (shadowVals_24, vec4(tmpvar_22));
  highp vec4 tmpvar_38;
  tmpvar_38 = _LightShadowData.xxxx;
  highp float tmpvar_39;
  if (tmpvar_37.x) {
    tmpvar_39 = tmpvar_38.x;
  } else {
    tmpvar_39 = 1.00000;
  };
  highp float tmpvar_40;
  if (tmpvar_37.y) {
    tmpvar_40 = tmpvar_38.y;
  } else {
    tmpvar_40 = 1.00000;
  };
  highp float tmpvar_41;
  if (tmpvar_37.z) {
    tmpvar_41 = tmpvar_38.z;
  } else {
    tmpvar_41 = 1.00000;
  };
  highp float tmpvar_42;
  if (tmpvar_37.w) {
    tmpvar_42 = tmpvar_38.w;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp vec4 tmpvar_43;
  tmpvar_43.x = tmpvar_39;
  tmpvar_43.y = tmpvar_40;
  tmpvar_43.z = tmpvar_41;
  tmpvar_43.w = tmpvar_42;
  shadows_23 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = dot (shadows_23, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp float tmpvar_45;
  tmpvar_45 = (atten_5 * tmpvar_44);
  atten_5 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_47;
  tmpvar_47 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_47;
  mediump float tmpvar_48;
  tmpvar_48 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_48;
  highp float tmpvar_49;
  tmpvar_49 = (spec_3 * clamp (tmpvar_45, 0.000000, 1.00000));
  spec_3 = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (_LightColor.xyz * (tmpvar_46 * tmpvar_45));
  res_2.xyz = tmpvar_50;
  lowp vec3 c_51;
  c_51 = _LightColor.xyz;
  lowp float tmpvar_52;
  tmpvar_52 = dot (c_51, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_53;
  tmpvar_53 = (tmpvar_49 * tmpvar_52);
  res_2.w = tmpvar_53;
  highp float tmpvar_54;
  tmpvar_54 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_55;
  tmpvar_55 = (res_2 * tmpvar_54);
  res_2 = tmpvar_55;
  tmpvar_1 = tmpvar_55.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;


uniform highp vec4 _ProjectionParams;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_2;
  xlv_TEXCOORD1 = mix (((gl_ModelViewMatrix * _glesVertex).xyz * vec3(-1.00000, -1.00000, 1.00000)), _glesNormal, vec3(float((_glesNormal.z != 0.000000))));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapFade;
uniform highp vec4 _ZBufferParams;
uniform highp vec3 _WorldSpaceCameraPos;
uniform samplerCube _ShadowMapTexture;
uniform highp vec4 _ProjectionParams;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform highp vec4 _LightShadowData;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightPos;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _LightColor;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  highp float atten_5;
  mediump vec3 lightDir_6;
  highp float depth_7;
  mediump vec3 normal_8;
  mediump vec4 nspec_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraNormalsTexture, tmpvar_10);
  nspec_9 = tmpvar_11;
  normal_8 = normalize(((nspec_9.xyz * 2.00000) - 1.00000));
  lowp float tmpvar_12;
  tmpvar_12 = texture2D (_CameraDepthTexture, tmpvar_10).x;
  depth_7 = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = (1.0/(((_ZBufferParams.x * depth_7) + _ZBufferParams.y)));
  depth_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * tmpvar_13);
  highp vec3 tmpvar_15;
  tmpvar_15 = (_CameraToWorld * tmpvar_14).xyz;
  highp vec3 p_16;
  p_16 = (tmpvar_15 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_17;
  tmpvar_17 = mix (tmpvar_14.z, sqrt(dot (p_16, p_16)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_18;
  tmpvar_18 = (tmpvar_15 - _LightPos.xyz);
  highp vec3 tmpvar_19;
  tmpvar_19 = -(normalize(tmpvar_18));
  lightDir_6 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = (dot (tmpvar_18, tmpvar_18) * _LightPos.w);
  lowp float tmpvar_21;
  tmpvar_21 = texture2D (_LightTextureB0, vec2(tmpvar_20)).w;
  atten_5 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = ((sqrt(dot (tmpvar_18, tmpvar_18)) * _LightPositionRange.w) * 0.970000);
  mediump vec4 shadows_23;
  highp vec4 shadowVals_24;
  highp vec3 vec_25;
  vec_25 = (tmpvar_18 + vec3(0.00781250, 0.00781250, 0.00781250));
  highp vec4 packDist_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = textureCube (_ShadowMapTexture, vec_25);
  packDist_26 = tmpvar_27;
  shadowVals_24.x = dot (packDist_26, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_28;
  vec_28 = (tmpvar_18 + vec3(-0.00781250, -0.00781250, 0.00781250));
  highp vec4 packDist_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_ShadowMapTexture, vec_28);
  packDist_29 = tmpvar_30;
  shadowVals_24.y = dot (packDist_29, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_31;
  vec_31 = (tmpvar_18 + vec3(-0.00781250, 0.00781250, -0.00781250));
  highp vec4 packDist_32;
  lowp vec4 tmpvar_33;
  tmpvar_33 = textureCube (_ShadowMapTexture, vec_31);
  packDist_32 = tmpvar_33;
  shadowVals_24.z = dot (packDist_32, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  highp vec3 vec_34;
  vec_34 = (tmpvar_18 + vec3(0.00781250, -0.00781250, -0.00781250));
  highp vec4 packDist_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = textureCube (_ShadowMapTexture, vec_34);
  packDist_35 = tmpvar_36;
  shadowVals_24.w = dot (packDist_35, vec4(1.00000, 0.00392157, 1.53787e-005, 6.22737e-009));
  bvec4 tmpvar_37;
  tmpvar_37 = lessThan (shadowVals_24, vec4(tmpvar_22));
  highp vec4 tmpvar_38;
  tmpvar_38 = _LightShadowData.xxxx;
  highp float tmpvar_39;
  if (tmpvar_37.x) {
    tmpvar_39 = tmpvar_38.x;
  } else {
    tmpvar_39 = 1.00000;
  };
  highp float tmpvar_40;
  if (tmpvar_37.y) {
    tmpvar_40 = tmpvar_38.y;
  } else {
    tmpvar_40 = 1.00000;
  };
  highp float tmpvar_41;
  if (tmpvar_37.z) {
    tmpvar_41 = tmpvar_38.z;
  } else {
    tmpvar_41 = 1.00000;
  };
  highp float tmpvar_42;
  if (tmpvar_37.w) {
    tmpvar_42 = tmpvar_38.w;
  } else {
    tmpvar_42 = 1.00000;
  };
  highp vec4 tmpvar_43;
  tmpvar_43.x = tmpvar_39;
  tmpvar_43.y = tmpvar_40;
  tmpvar_43.z = tmpvar_41;
  tmpvar_43.w = tmpvar_42;
  shadows_23 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = dot (shadows_23, vec4(0.250000, 0.250000, 0.250000, 0.250000));
  highp vec4 tmpvar_45;
  tmpvar_45.w = 1.00000;
  tmpvar_45.xyz = tmpvar_15;
  lowp vec4 tmpvar_46;
  highp vec3 P_47;
  P_47 = (_LightMatrix0 * tmpvar_45).xyz;
  tmpvar_46 = textureCube (_LightTexture0, P_47);
  highp float tmpvar_48;
  tmpvar_48 = ((atten_5 * tmpvar_44) * tmpvar_46.w);
  atten_5 = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = max (0.000000, dot (lightDir_6, normal_8));
  highp vec3 tmpvar_50;
  tmpvar_50 = normalize((lightDir_6 - normalize((tmpvar_15 - _WorldSpaceCameraPos))));
  h_4 = tmpvar_50;
  mediump float tmpvar_51;
  tmpvar_51 = pow (max (0.000000, dot (h_4, normal_8)), (nspec_9.w * 128.000));
  spec_3 = tmpvar_51;
  highp float tmpvar_52;
  tmpvar_52 = (spec_3 * clamp (tmpvar_48, 0.000000, 1.00000));
  spec_3 = tmpvar_52;
  highp vec3 tmpvar_53;
  tmpvar_53 = (_LightColor.xyz * (tmpvar_49 * tmpvar_48));
  res_2.xyz = tmpvar_53;
  lowp vec3 c_54;
  c_54 = _LightColor.xyz;
  lowp float tmpvar_55;
  tmpvar_55 = dot (c_54, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_56;
  tmpvar_56 = (tmpvar_52 * tmpvar_55);
  res_2.w = tmpvar_56;
  highp float tmpvar_57;
  tmpvar_57 = clamp ((1.00000 - ((tmpvar_17 * unity_LightmapFade.z) + unity_LightmapFade.w)), 0.000000, 1.00000);
  mediump vec4 tmpvar_58;
  tmpvar_58 = (res_2 * tmpvar_57);
  res_2 = tmpvar_58;
  tmpvar_1 = tmpvar_58.wxyz;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}
}
Program "fp" {
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_OFF" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
"!!GLES"
}
}
 }
}
Fallback Off
}