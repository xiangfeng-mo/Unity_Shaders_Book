Shader "practice/diffuse_vertex_light"
{
    Properties
    {
        _diffuseColor("漫反射颜色", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags {"RenderMode" = "ForwardBase"}
        
        Pass
        {
            CGPROGRAM

            #include "Lighting.cginc"

            #pragma vertex vert;
            #pragma fragment frag;

            fixed4 _diffuseColor;

            struct a2v
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(a2v i)
            {
                v2f o;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                float3 normaldir = normalize(mul(i.normal, (float3x3)unity_WorldToObject)); //变换法线需要从模型空间到世界空间的逆转置矩阵
                float3 lightdir = normalize(_WorldSpaceLightPos0.xyz);
                fixed4 clight = _LightColor0;
            
                o.vertex = UnityObjectToClipPos(i.pos);
                fixed3 diffuse = clight.rgb * _diffuseColor.rgb * saturate(dot(normaldir,lightdir));
                o.color = diffuse + ambient;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(i.color, 1.0);
                // return fixed4(1,1,1,1);
            }

            
            ENDCG
        }
    }
}
