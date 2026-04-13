Shader "Crazy/LightMap" {
Properties {
 _Color ("Main Color", Color) = (1,1,1,1)
 _texBase ("MainTex", 2D) = "" {}
 _texLightmap ("LightMap", 2D) = "" {}
}
SubShader { 
 Pass {
  BindChannels {
   Bind "vertex", Vertex
   Bind "texcoord", TexCoord0
   Bind "texcoord1", TexCoord1
  }
  Color [_Color]
  ZWrite Off
  SetTexture [_texBase] { ConstantColor [_Color] combine texture * constant }
  SetTexture [_texLightmap] { combine texture * previous }
 }
}
}