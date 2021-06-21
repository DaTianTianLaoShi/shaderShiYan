// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color",color) = (1,1,1,1)
		_Specular("Specular",color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
	}
		SubShader
		{
			//Tags { "RenderType" = "Opaque" }
			Tags{"LightMode" = "ForwardBase"}
			//LOD 100

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog

				#include "UnityCG.cginc"
				#include "Lighting.cginc"

				struct a2v
				{
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
					float3 normal:NORMAL;
				};

				struct v2f
				{
					float3 worldNormal : TEXCOORD0;
					float3 worldPos:TEXCOORD1;
					float2 uv:TEXCOORD2;
					//UNITY_FOG_COORDS(1)
					float4 pos : SV_POSITION;
				};

				sampler2D _MainTex;
				fixed4  _MainTex_ST;
				float  _Gloss;
				fixed4 _Specular;
				fixed4 _Color;

				v2f vert(a2v v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.worldNormal = UnityObjectToWorldNormal(v.normal);
					o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
					//o.uv = v.texcoord.xy*_MainTex_ST.xy*_MainTex_ST.zw;
					o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target{
				fixed3 wordNormal = normalize(i.worldNormal);
				// apply fog
				fixed3 wordLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb*_Color.rgb;//采样纹理和颜色计算反射值
				//标准计算光照模型
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;
				fixed3 diffuse = _LightColor0.rgb*albedo* max(0,(dot(wordNormal, wordLightDir)));
				//计算lambert反射
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 halfDir = normalize(viewDir + wordLightDir);
				fixed3 specular = _LightColor0.rgb*_Specular.rgb * pow(max(0,dot(wordNormal, halfDir)),_Gloss);
				fixed3 color = ambient+ specular+ diffuse;
				return fixed4(color,1.0);
				//return col;
			    }

			ENDCG
		}
			
		}
			Fallback "Specular"
}