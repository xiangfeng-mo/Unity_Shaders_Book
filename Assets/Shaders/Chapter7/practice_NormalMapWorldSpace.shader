// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/Practice/NormalMapWorldSpace" {
	Properties
	{
		_MainTex("Main Tex", 2D) = "white"{}
		_BumpMap("Bump Map", 2D) = "white"{}
		_BumpScale ("Bump Scale", Float) = 1.0
		_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	
	SubShader
	{
		Pass
		{
			Tags{ "RenderMode" = "ForwardBase"}
			
			CGPROGRAM
			
			#include "Lighting.cginc"

			#pragma vertex vert;
			#pragma fragment frag;

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			fixed4 _DiffuseColor;
			fixed4 _SpecularColor;
			float _BumpScale;
			float _Gloss;

			struct a2v
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW1: TEXCOOR0;
				float4 TtoW2: TEXCOOR1;
				float4 TtoW3: TEXCOOR2;
			};

			v2f vert(a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.pos);
				o.uv.xy = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = i.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

				float3 normal =  UnityObjectToWorldNormal(i.normal);
				float3 tangent = UnityObjectToWorldDir(i.tangent.xyz);
				float3 biTangent = cross(normal, tangent) * i.tangent.w;
				float3 worldPos = mul(unity_ObjectToWorld, i.pos);

				o.TtoW1 = float4(tangent.x, biTangent.x, normal.x, worldPos.x);
				o.TtoW2 = float4(tangent.y, biTangent.y, normal.y, worldPos.y);
				o.TtoW3 = float4(tangent.z, biTangent.z, normal.z, worldPos.z);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb;
				float4 packedNormal = tex2D(_BumpMap, i.uv.zw);
				float3 tangentNormal;
				tangentNormal.xy = packedNormal.xy * 2 - 1;
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				float3 worldNormal = normalize(float3(dot(i.TtoW1.xyz, tangentNormal), dot(i.TtoW2.xyz, tangentNormal), dot(i.TtoW3.xyz, tangentNormal)));

				
				fixed3 lightColor = _LightColor0.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				float3 worldPos = float3(i.TtoW1.w, i.TtoW2.w, i.TtoW3.w);
				fixed3 worldLightDir = normalize( UnityWorldSpaceLightDir(worldPos));
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir(worldPos));

				fixed3 diffuse = lightColor * albedo * max(0, dot(worldNormal, worldLightDir)) * _DiffuseColor.rgb;

				float3 h = normalize(worldLightDir + worldViewDir);
				fixed3 specular = lightColor * _SpecularColor.rgb * pow(max(0, dot(worldNormal, h)), _Gloss);

				return fixed4(ambient + diffuse + specular, 1);
			}
			

			
			ENDCG
		}
	}
	
	
	
	
	
	
	
}
