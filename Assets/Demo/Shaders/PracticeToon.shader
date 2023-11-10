Shader "Roystan/Toon Practice"
{
	Properties
	{
		_Color("Color Tint", Color) = (1,1,1,1)
		_Main("Main Tex", 2D) = "white" {}
		_SpecularFactor("Specular Factor", float) = 150
		_AmbientFactor("Ambient Factor", Range(0, 1)) = 0.1
	}
	
	SubShader
	{
		Pass
		{
			Tags{"LightMode" = "ForwardBase" }
			
			CGPROGRAM

			#include "Lighting.cginc"

			#pragma vertex vert
			#pragma fragment frag

			fixed4 _Color;
			sampler2D _Main;
			float _SpecularFactor;
			float _AmbientFactor;

			struct app_data
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD0;
			};

			v2f vert(app_data v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.normal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 normal = normalize(i.normal);

				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.pos));
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float NdotL = dot(normal, lightDir);
				// fixed3 diffuseColor = NdotL > 0 ? _Color : 0;
				fixed3 diffuseColor = smoothstep(0.01, 0.05, NdotL) * _Color;

				fixed3 ambientColor = _AmbientFactor * _Color;

				

				
				return fixed4(ambientColor + diffuseColor, 1); 
			}
			
			ENDCG
		}
	}
	FallBack "Transparent/VertexLit"
}