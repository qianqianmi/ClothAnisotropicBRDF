Shader "Custom/ClothAnisotropic"
{
    Properties
    {
        _Albedo("Albedo", Color) = (0.7, 0.85, 0.9, 1) // 浅蓝布料色
        _RoughnessX("Roughness X (横向)", Range(0.01, 1)) = 0.3
        _RoughnessY("Roughness Y (纵向)", Range(0.01, 1)) = 0.1
        _Transmittance("透光强度", Range(0, 0.5)) = 0.2
    }

        SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "RenderPipeline" = "UniversalPipeline" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // URP核心头文件（适配2022版本）
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float2 uv           : TEXCOORD0;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 uv           : TEXCOORD0;
                float3 positionWS   : TEXCOORD1;
                float3 normalWS     : TEXCOORD2;
                float3 tangentWS    : TEXCOORD3;
                float3 bitangentWS  : TEXCOORD4;
            };

            // 材质参数
            CBUFFER_START(UnityPerMaterial)
            float4 _Albedo;
            float _RoughnessX;
            float _RoughnessY;
            float _Transmittance;
            CBUFFER_END

                // 顶点着色器：坐标/法线转换到世界空间
                Varyings vert(Attributes input)
                {
                    Varyings output;
                    output.positionHCS = TransformObjectToHClip(input.positionOS.xyz);
                    output.positionWS = TransformObjectToWorld(input.positionOS.xyz);
                    output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                    output.tangentWS = TransformObjectToWorldDir(input.tangentOS.xyz);
                    output.bitangentWS = cross(output.normalWS, output.tangentWS) * input.tangentOS.w;
                    output.uv = input.uv;
                    return output;
                }

            // 片元着色器：计算布料BRDF
            half4 frag(Varyings input) : SV_Target
            {
                // 归一化向量
                float3 N = normalize(input.normalWS);
                float3 T = normalize(input.tangentWS);
                float3 B = normalize(input.bitangentWS);
                float3 L = GetMainLight().direction;
                float3 V = normalize(_WorldSpaceCameraPos - input.positionWS);
                float3 H = normalize(L + V);

                // 向量点积（控制范围0-1）
                float NdotL = saturate(dot(N, L));
                float HdotT = saturate(dot(H, T));
                float HdotB = saturate(dot(H, B));

                // 各向异性高光计算
                float aniso = exp(-(pow(HdotT / _RoughnessX, 2) + pow(HdotB / _RoughnessY, 2)));
                // 漫反射 + 高光 + 透光
                float3 diffuse = _Albedo.rgb * NdotL;
                float3 specular = GetMainLight().color * aniso * 0.5;
                float3 transmission = _Albedo.rgb * _Transmittance * (1 - NdotL);

                // 最终颜色
                float3 finalColor = diffuse + specular + transmission;
                return half4(finalColor, 1);
            }
            ENDHLSL
        }
    }
        FallBack "Hidden/Universal Render Pipeline/FallbackError"
}