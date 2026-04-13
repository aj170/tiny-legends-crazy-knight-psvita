Shader "Devil/Shader_Character" {
Properties {
 _MainTex ("MainTex", 2D) = "" {}
 _Color ("Main Color", Color) = (0,0,0,1)
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Tags { "RenderType"="Opaque" }
  Color [_Color]
  Fog { Mode Off }
  SetTexture [_MainTex] { combine texture + primary }
 }
}
Fallback Off
}