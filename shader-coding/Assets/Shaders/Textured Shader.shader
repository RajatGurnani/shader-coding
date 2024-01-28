Shader "Unlit/Textured Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
        _Frequency ("Frequency", Integer) = 5
        _MipSampleLevel ("MipSampleLevel", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define PI 3.14159265359

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolator
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldCoord : TEXCOORD1;
            }; 

            sampler2D _MainTex; // texture sampler
            sampler2D _Pattern;
            float4 _MainTex_ST; // For tiling and offset
            int _Frequency;
            float _MipSampleLevel;

            Interpolator vert (MeshData v)
            {
                Interpolator o;
                o.worldCoord = mul(UNITY_MATRIX_M,v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float MakeWave(float value){
                float temp = cos((value + _Time.y * 0.1) * 2 * PI * _Frequency) * 0.5 + 0.5;
                return temp * value;
            }

            fixed4 frag (Interpolator i) : SV_Target
            {
                float4 color = tex2D(_MainTex,i.worldCoord.xz);
                float value = tex2D(_Pattern,i.uv).x;
                color = lerp(float4(1,0,0,1),color,value);
                return color;
                return MakeWave(value);
            }
            ENDCG
        }
    }
}
