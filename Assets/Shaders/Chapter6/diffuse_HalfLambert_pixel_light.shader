Shader "practice/diffuse_HalfLambert_pixel_light"
{
    Properties
    {
        _diffuseColor("漫反射颜色", Color) = (1,1,1,1)    
    }
    
    SubShader
    {
        Tags{"LightMode" = "ForwardBase"}
        
        Pass
        {
            CGPROGRAM

            #include "Lighting.cginc"

            #pragma vertex vert;
            #pragma fragment frag;

            fixed3 _diffuseColor;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 color : COLOR;
                float3 normal : NORMAL;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                float3 worldNormalDir = normalize(mul(i.normal, (float3x3)unity_WorldToObject));
                float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                float3 clight = _LightColor0.rgb;
                float3 diffuse = clight * _diffuseColor * (0.5 * (dot(worldNormalDir, worldLightDir)) + 0.5);

                return fixed4((diffuse + ambient),1.0);
            }
        
        
            ENDCG
        }
    }
    
    
}
