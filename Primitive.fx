#include "Common.fxh"

float4x4 World;

struct VertexShaderInput
{
    float4 Position : POSITION0;
    float4 Color : COLOR0;
};

struct VertexShaderOutput
{
    float4 position : SV_Position;
    float4 color : COLOR0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

    output.position = mul(input.Position, World);
    output.color = input.Color;

    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET0
{
    return input.color;
}

technique NormalTechnique
{
    pass Base
    {
        VertexShader = compile VS_SHADER_COMPILER VertexShaderFunction();
        PixelShader = compile PS_3_SHADER_COMPILER PixelShaderFunction();
    }
}