Shader "Unlit/PointShader"
{
    Properties
    {
        //顶点着色器，实验记录版本
        _Color("Color",Color) = (1,1,1,1)
    }
        SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            fixed3 _Color;
            // make fog work
            struct appdata
            {
               
                float4 vertex : POSITION;
                float3 normal:NORMAL; 
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 color : COLOR;
            };
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //世界光照方向
                fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT;//入射光线和强度
                fixed3 WordNormal= normalize( UnityObjectToWorldNormal(v.normal)).xyz;
                fixed3 WorldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                //基本光照类型
                fixed3 diffuse = _LightColor0.rgb * _Color.rgb * saturate(dot(WordNormal,WorldLightDir));
                o.color = diffuse + ambient;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
               return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
}
