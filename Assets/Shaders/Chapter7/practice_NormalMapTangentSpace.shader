// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 7/Practice/NormalMapTangentSpace" {
	Properties
	{
		_MainTex("Main Tex", 2D) = "white"{}
		_BumpMap("Bump Map", 2D) = "white"{}
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
			float _Gloss;

			struct a2v
			{
				float4 pos : POSITION;
				float3 normal : NORMAL;
				float3 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 bumpUV : TEXCOORD1;
			};

			v2f vert(a2v i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.pos);
				o.uv = i.pos * _MainTex_ST.xy + _MainTex_ST.zw;

				float3 normal = normalize(i.normal);
				float3 tangent = normalize(i.tangent);
				float3 biTangent = cross(normal, tangent);

				matrix objectToTangent = (normal, tangent, biTangent, 1);
				float4 tangentPos = mul(objectToTangent, i.pos);
				o.bumpUV = tangentPos * _BumpMap_ST.xy + _BumpMap_ST.zw;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				
			}
			

			
			ENDCG
		}
	}
	
	
	
	
	
	
	
}
