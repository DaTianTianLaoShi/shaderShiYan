Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
	    _Color("Color",color)=(1,1,1,1)
		_Specular("Specular",color)=(1,1,1,1)
		_Gloss("Gloss",float)=20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		Tags{"LightMode"="FowardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
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
            float4 _MainTex_ST;
			float _Gloss; 
			fixed4 _Specular;
			fixed4 _Color;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
               // UNITY_TRANSFER_FOG(o,o.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos =mul(unity_ObjectToWorld,v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
               // fixed4 col = tex2D(_MainTex, i.uv);
			    fixed3 wordNormal = normalize(i.worldNormal);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
			    fixed3 wordLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                
				
				
				//return col;
            }
            ENDCG
        }
    }
}
