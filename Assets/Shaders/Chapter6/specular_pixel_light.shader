Shader "practice/specular_pixel_light"
{
    Properties
    {
        _diffuseColor("漫反射颜色", Color) = (1,1,1,1)
        _specularColor("高光反射颜色", Color) = (1,1,1,1)
        _gloss("光泽度", float) = 20
    }
    
    SubShader
    {
        Tags{"LightModel" = "ForwardBase"}
        
        Pass
        {
            CGPROGRAM

            #include "Lighting.cginc"

            #pragma vertex vert;
            #pragma fragment frag;

            fixed4 _diffuseColor;
            fixed4 _specularColor;
            float _gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldViewDir : TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                float3 worldVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldViewDir = normalize((_WorldSpaceCameraPos.xyz - worldVertexPos));

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 h = normalize(worldLightDir + i.worldViewDir);
                
                fixed3 diffuse = _LightColor0.rgb * _diffuseColor.rgb * saturate(dot(i.worldNormal, worldLightDir));
                // float3 worldReflecDir = normalize(reflect(-worldLightDir, i.worldNormal));
                fixed3 specular = _LightColor0.rgb * _specularColor.rgb * pow(saturate(dot(i.worldNormal, h)), _gloss);
                fixed3 color = ambient + diffuse + specular;

                return fixed4(color, 1);
            }

            
            ENDCG
        }
    }
}
