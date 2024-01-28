Shader "Unlit/Wave Shader"
{
    Properties
    {
        _Frequency ("Frequency", Integer) =1
        _WaveAmp ("Wave Amplitude",Range(0,0.5))=0.1
    }
    SubShader
    {
        Tags {
             "RenderType"="Opaque"
             "Queue"= "Transparent"
             }

        Pass
        {
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define PI 3.14159265359

            #include "UnityCG.cginc"

            int _Frequency;
            float _WaveAmp;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            float  MakeWave(float2 uv)
            {
                float2 centeredUV = uv*2-1;
                float radialDistance = length(centeredUV);

                float amp = cos((radialDistance + _Time.y * 0.02) * 2 * PI * _Frequency)* 0.5 + 0.5;
                amp = amp * (1 - radialDistance);
                return(saturate(amp));
            }

            struct Interpolator
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL0;
                float2 uv : TEXCOORD0;
            };

            Interpolator vert (MeshData v)
            {
                Interpolator o;
                //v.vertex.y = MakeWave(v.uv)*_WaveAmp;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolator i) : SV_Target
            {
                return MakeWave(i.uv);
            }
            ENDCG
        }
    }
}
