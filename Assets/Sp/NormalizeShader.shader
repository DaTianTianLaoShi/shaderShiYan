Shader "Unlit/NormalizeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
	    _Color("Color",Color) =(1,1,1,1)
		_NormalMap("Normalize",2D) = "normal"{}
		_BumpScale("BumpScale",Float) = 1.0
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8,20))=20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		Tag{"LightModel"="ForwoardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
				TRANSFORM_TEX();
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                return col;
            }
            ENDCG
        }
    }
			Fallback "Specular"
}
