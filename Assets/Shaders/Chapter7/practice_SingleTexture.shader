// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/Practice/SingleTexture" {
	Properties {
		_DiffuseColor ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_Gloss ("Gloss", Range(0,1)) = 0.5
	}
	
	SubShader
	{
		Tags{ "RenderMode" = "FowardBase" }
		
		Pass
		{
			CGPROGRAM

			#include "Lighting.cginc"

			#pragma vertex vert;
			#pragma fragment frag;

			fixed4 _DiffuseColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _SpecularColor;
			float _Gloss;
			
			struct a2v
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};

			v2f vert(a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.pos);
				o.worldNormal = UnityObjectToWorldNormal(i.normal);
				o.worldPos = mul(unity_ObjectToWorld, i.pos);
				o.uv = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _DiffuseColor.rgb;
				fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(worldNormal, worldLightDir));
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
				float3 halfDir = normalize( viewDir + worldLightDir);

				fixed3 specular = _LightColor0.rgb * _SpecularColor * pow(max(0, dot(worldNormal, halfDir)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1);
			}
			
			ENDCG
		}
		
	}
	
	
	
	FallBack "Specular"
}
