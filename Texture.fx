#include "Common.fxh"

DECLARE_TEXTURE(source, 0);
float4x4 World;

struct VertexShaderOutput
{
    float4 position : SV_Position;
    float2 uv : TEXCOORD0;
    float4 color : COLOR0;
};

VertexShaderOutput VertexShaderFunction(float4 position:POSITION0, float4 color:COLOR0, float2 uv:TEXCOORD0)
{
    VertexShaderOutput output;

    output.position = mul(position, World);
    output.uv = uv;
    output.color = color;

    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET0
{
    return SAMPLE_TEXTURE(source, input.uv) * input.color;
}

technique NormalTechnique
{
    pass Base
    {
        VertexShader = compile VS_SHADER_COMPILER VertexShaderFunction();
        PixelShader = compile PS_3_SHADER_COMPILER PixelShaderFunction();
    }
}