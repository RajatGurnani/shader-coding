Shader "Unlit/Shader1"
{
    Properties
    {
        [PerRendererData]  _ColorA ("Color A",Color ) = (1,1,1,1)
        
        [PerRendererData]  _ColorB ("Color B",Color ) = (1,1,1,1)

        [PerRendererData]  _ValueA ("ValueA",Range(0,1)) = 0
        [PerRendererData]  _ValueB ("ValueB",Range(0,1)) = 0

        [PerRendererData]  _UseNormal ("UseNormal", Integer) = 0
        [PerRendererData]  _Ripples ("Ripples", Integer)=1
    }
    SubShader
    {
        Tags 
        {
             "RenderType" = "Opaque"
             "Queue" = "Geometry"
        }

        Pass
        {
            Cull Back
            // Cull Off
            ZTest LEqual
            ZWrite On
            // Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            #define PI 3.14159265359

            float4 _ColorA;
            float4 _ColorB;
            float _ValueA;
            float _ValueB;

            int _UseNormal;
            int _Ripples;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL0;
                float2 uv : TEXCOORD0;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }
            
            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // float t = abs(sin(i.uv.x*2*PI* _Ripples)*0.5 + cos(i.uv.y*2*PI*_UseNormal)*0.1)*2;
                // float t = sin(i.uv.x*2*PI* _Ripples + sin(i.uv.y*2*PI*_UseNormal))*0.5+0.5;
                float offset = cos(i.uv.x * 2 * PI * _UseNormal) * 0.02;
                float t = cos((i.uv.y + offset - _Time.y * 0.05) * 2 * PI * _Ripples) * 0.5 + 0.5;
                t *= 1 - i.uv.y;
                float4 color = lerp(_ColorA, _ColorB, saturate(InverseLerp(_ValueA,_ValueB,i.uv.y)));
                return t * color * (abs(i.normal.y) < 0.999f);
            }

            ENDCG
        }
    }
}
