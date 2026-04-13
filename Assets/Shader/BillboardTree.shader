ŽShader "Hidden/TerrainEngine/BillboardTree" {
Properties {
 _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
}
SubShader { 
 Tags { "QUEUE"="Transparent-100" "IGNOREPROJECTOR"="True" "RenderType"="TreeBillboard" }
 Pass {
  Tags { "QUEUE"="Transparent-100" "IGNOREPROJECTOR"="True" "RenderType"="TreeBillboard" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  ColorMask RGB
Program "vp" {
SubProgram "gles " {
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR0;

uniform highp vec4 _TreeBillboardDistances;
uniform highp vec4 _TreeBillboardCameraUp;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardCameraFront;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesColor;
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
  xlv_COLOR0 = _glesColor;
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
varying lowp vec4 xlv_COLOR0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 col_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  col_1.w = tmpvar_2.w;
  col_1.xyz = (tmpvar_2.xyz * xlv_COLOR0.xyz);
  if ((tmpvar_2.w < 0.000000)) {
    discard;
  };
  gl_FragData[0] = col_1;
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
 Tags { "QUEUE"="Transparent-100" "IGNOREPROJECTOR"="True" "RenderType"="TreeBillboard" }
 Pass {
  Tags { "QUEUE"="Transparent-100" "IGNOREPROJECTOR"="True" "RenderType"="TreeBillboard" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  AlphaTest Greater 0
  ColorMask RGB
Program "vp" {
}
  SetTexture [_MainTex] { combine texture * primary, texture alpha }
 }
}
Fallback Off
}