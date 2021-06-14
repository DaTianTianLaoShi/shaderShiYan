Shader "Unlit/DiffuseShader"
{
    //像素光照模型
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
	    _Diffuse("diffuse",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "Lighting.cginc"
            struct appdata
            {
				float4 normal:NORMAL;
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
				float3 normal:NORMAL;
				float4 pos:SV_POSITION;
                float4 uv1 : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Diffuse;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.normal =UnityObjectToWorldNormal(v.normal).xyz;
				//o.vu1 = UntiyObectWorldNormal(v.);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
			    fixed3 worldnormal =normalize( i.normal);
				fixed3 worldlightdir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(worldnormal,worldlightdir));
				fixed3 color = ambient + diffuse;

				return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
