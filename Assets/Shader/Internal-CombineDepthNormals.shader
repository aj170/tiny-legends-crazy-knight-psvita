ßShader "Hidden/Internal-CombineDepthNormals" {
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

varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _CameraNormalsTexture_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 _WorldToCamera;
uniform sampler2D _CameraNormalsTexture;
uniform sampler2D _CameraDepthTexture;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec3 n_2;
  highp float d_3;
  lowp float tmpvar_4;
  tmpvar_4 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x;
  d_3 = tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_5 = ((texture2D (_CameraNormalsTexture, xlv_TEXCOORD0) * 2.00000) - 1.00000).xyz;
  n_2 = tmpvar_5;
  highp float tmpvar_6;
  tmpvar_6 = (1.0/(((_ZBufferParams.x * d_3) + _ZBufferParams.y)));
  d_3 = tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _WorldToCamera[0].xyz;
  tmpvar_7[1] = _WorldToCamera[1].xyz;
  tmpvar_7[2] = _WorldToCamera[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * n_2);
  n_2.xy = tmpvar_8.xy;
  n_2.z = -(tmpvar_8.z);
  highp vec4 tmpvar_9;
  if ((tmpvar_6 < 0.999985)) {
    highp vec4 enc_10;
    enc_10.xy = ((((tmpvar_8.xy / (n_2.z + 1.00000)) / 1.77770) * 0.500000) + 0.500000);
    highp vec2 enc_11;
    highp vec2 tmpvar_12;
    tmpvar_12 = fract((vec2(1.00000, 255.000) * tmpvar_6));
    enc_11.y = tmpvar_12.y;
    enc_11.x = (tmpvar_12.x - (tmpvar_12.y * 0.00392157));
    enc_10.zw = enc_11;
    tmpvar_9 = enc_10;
  } else {
    tmpvar_9 = vec4(0.500000, 0.500000, 1.00000, 1.00000);
  };
  tmpvar_1 = tmpvar_9;
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