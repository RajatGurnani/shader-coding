Shader "Unlit/Healthbar Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Health ("Health",Range(0,1)) = 1
        _StartColor ("Start Color",Color) = (1,1,1,1)
        _EndColor ("End Color",Color) = (1,1,1,1)

        _StartThreshold ("Start Threshold", Range(0,1))=0
        _EndThreshold ("End Threshold", Range(0,1))=1

        _CornerRadius ("Corner Radius",Range(0,0.1)) = 0
        _Thickness ("Thickness",Range(0,0.1))=0
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue" ="Transparent"
        }

        Pass
        {
            //Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #define PI 3.14159265359

            #include "UnityCG.cginc"

            struct Meshdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Inerpolator
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _StartColor;
            float4 _EndColor;
            float _Health;

            float _StartThreshold;
            float _EndThreshold;

            float _CornerRadius;
            float _Thickness;

            Inerpolator vert (Meshdata v)
            {
                Inerpolator o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float InverseLerp(float a ,float b, float v)
            {
                return (v-a)/(b-a);
            }

            float4 frag (Inerpolator i) : SV_Target
            {
                // float value = InverseLerp(_StartThreshold,_EndThreshold,_Health);
                float4 color = tex2D(_MainTex,i.uv);
                // float4 color = lerp(_StartColor,_EndColor,saturate(value));
                color *= (_Health>i.uv.x);
                color = lerp(color, _StartColor, (cos(_Time.y * 2 * PI * 1) * 0.5 + 0.5)*(_Health<_StartThreshold));
                
                // float2 uv = (i.uv *2 - 1);
                // return float4(uv,0,1)*(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   );

                clip(_Health-i.uv.x);
                return color;
            }

            ENDCG
        }
    }
}
