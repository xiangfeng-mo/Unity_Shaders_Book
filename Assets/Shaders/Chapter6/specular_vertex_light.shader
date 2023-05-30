Shader "practice/specular_vertex_light"
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
                fixed3 color : COLOR;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                fixed3 diffuse = _LightColor0.rgb * _diffuseColor.rgb * saturate(dot(worldNormal, worldLightDir));

                float3 worldVertexPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldViewDir = normalize((_WorldSpaceCameraPos.xyz - worldVertexPos));
                float3 worldReflecDir = normalize(reflect(-worldLightDir, worldNormal));

                fixed3 specular = _LightColor0.rgb * _specularColor.rgb * pow(saturate(dot(worldViewDir, worldReflecDir)), _gloss);

                o.color = ambient + diffuse + specular;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return fixed4(i.color, 1);
            }

            
            ENDCG
        }
    }
}
