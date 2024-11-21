#include "Common.fxh"

DECLARE_TEXTURE(source, 0);
float4x4 World;

struct VertexShaderOutput
{
	float4 position : SV_Position;
	float2 texcoord: TEXCOORD0;
	float4 color : COLOR0;
	float4 mask : COLOR1;
};

VertexShaderOutput VertexShaderFunction(float4 position:POSITION0, float4 color : COLOR0, float4 mask : COLOR1, float2 texcoord:TEXCOORD0)
{
	VertexShaderOutput output;

	output.position = mul(position, World);
	output.texcoord = texcoord;
	output.color = color;
	output.mask = mask;

	return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : SV_TARGET0
{
	float4 value = SAMPLE_TEXTURE(source, input.texcoord) * input.mask;
	float4 alpha = value.r + value.g + value.b + value.a;

	return input.color * alpha;
}


technique LightGradientTechnique
{
	pass Base
	{
		VertexShader = compile VS_SHADER_COMPILER VertexShaderFunction();
		PixelShader = compile PS_3_SHADER_COMPILER PixelShaderFunction();
	}
}