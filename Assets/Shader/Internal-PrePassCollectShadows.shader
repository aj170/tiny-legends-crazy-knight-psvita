Ó0Shader "Hidden/Internal-PrePassCollectShadows" {
Properties {
 _ShadowMapTexture ("", any) = "" {}
}
SubShader { 
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  Fog { Mode Off }
Program "vp" {
SubProgram "gles " {
Keywords { "SHADOWS_NONATIVE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _ZBufferParams;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp vec4 _LightShadowData;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp float depth_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x;
  depth_3 = tmpvar_4;
  highp float tmpvar_5;
  tmpvar_5 = (1.0/(((_ZBufferParams.x * depth_3) + _ZBufferParams.y)));
  depth_3 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.00000;
  tmpvar_6.xyz = (xlv_TEXCOORD1 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  mediump float shadow_8;
  highp vec4 zFar_9;
  highp vec4 zNear_10;
  bvec4 tmpvar_11;
  tmpvar_11 = greaterThanEqual (tmpvar_6.zzzz, _LightSplitsNear);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  zNear_10 = tmpvar_12;
  bvec4 tmpvar_13;
  tmpvar_13 = lessThan (tmpvar_6.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_14;
  tmpvar_14 = vec4(tmpvar_13);
  zFar_9 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (zNear_10 * zFar_9);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.00000;
  tmpvar_16.xyz = (((((unity_World2Shadow[0] * tmpvar_7).xyz * tmpvar_15.x) + ((unity_World2Shadow[1] * tmpvar_7).xyz * tmpvar_15.y)) + ((unity_World2Shadow[2] * tmpvar_7).xyz * tmpvar_15.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * tmpvar_15.w));
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_16.z)) {
    tmpvar_18 = _LightShadowData.x;
  } else {
    tmpvar_18 = 1.00000;
  };
  shadow_8 = tmpvar_18;
  res_2.x = shadow_8;
  res_2.y = 1.00000;
  highp vec2 enc_19;
  highp vec2 tmpvar_20;
  tmpvar_20 = fract((vec2(1.00000, 255.000) * (1.00000 - tmpvar_5)));
  enc_19.y = tmpvar_20.y;
  enc_19.x = (tmpvar_20.x - (tmpvar_20.y * 0.00392157));
  res_2.zw = enc_19;
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

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = _glesNormal;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 _ZBufferParams;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform highp mat4 _CameraToWorld;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 res_2;
  highp float depth_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x;
  depth_3 = tmpvar_4;
  highp float tmpvar_5;
  tmpvar_5 = (1.0/(((_ZBufferParams.x * depth_3) + _ZBufferParams.y)));
  depth_3 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.00000;
  tmpvar_6.xyz = (xlv_TEXCOORD1 * tmpvar_5);
  highp vec4 tmpvar_7;
  tmpvar_7 = (_CameraToWorld * tmpvar_6);
  mediump float shadow_8;
  highp vec4 weights_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_14;
  tmpvar_14.x = dot (tmpvar_10, tmpvar_10);
  tmpvar_14.y = dot (tmpvar_11, tmpvar_11);
  tmpvar_14.z = dot (tmpvar_12, tmpvar_12);
  tmpvar_14.w = dot (tmpvar_13, tmpvar_13);
  bvec4 tmpvar_15;
  tmpvar_15 = lessThan (tmpvar_14, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_16;
  tmpvar_16 = vec4(tmpvar_15);
  weights_9 = tmpvar_16;
  weights_9.yzw = clamp ((weights_9.yzw - weights_9.xyz), 0.000000, 1.00000);
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.00000;
  tmpvar_17.xyz = (((((unity_World2Shadow[0] * tmpvar_7).xyz * weights_9.x) + ((unity_World2Shadow[1] * tmpvar_7).xyz * weights_9.y)) + ((unity_World2Shadow[2] * tmpvar_7).xyz * weights_9.z)) + ((unity_World2Shadow[3] * tmpvar_7).xyz * weights_9.w));
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_ShadowMapTexture, tmpvar_17.xy);
  highp float tmpvar_19;
  if ((tmpvar_18.x < tmpvar_17.z)) {
    tmpvar_19 = _LightShadowData.x;
  } else {
    tmpvar_19 = 1.00000;
  };
  shadow_8 = tmpvar_19;
  res_2.x = shadow_8;
  res_2.y = 1.00000;
  highp vec2 enc_20;
  highp vec2 tmpvar_21;
  tmpvar_21 = fract((vec2(1.00000, 255.000) * (1.00000 - tmpvar_5)));
  enc_20.y = tmpvar_21.y;
  enc_20.x = (tmpvar_21.x - (tmpvar_21.y * 0.00392157));
  res_2.zw = enc_20;
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
Fallback Off
}