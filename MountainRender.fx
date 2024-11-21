#include "Common.fxh"

float4x4 WorldViewProj;

DECLARE_TEXTURE(ao0, 0);
DECLARE_TEXTURE(ao1, 1);

uniform float3 fog;
uniform float ease;

//-----------------------------------------------------------------------------
// MOUNTAIN RENDER TECHNIQUE
//-----------------------------------------------------------------------------

struct VS_MountainOut
{
    float4 position : SV_Position;
    float2 texcoord : TEXCOORD0;
    float4 pos : TEXCOORD1;
};

VS_MountainOut VS_Mountain(float4 position : POSITION0, float2 texcoord : TEXCOORD0)
{
    VS_MountainOut output;

    output.position = mul(position, WorldViewProj);
    output.pos = position;
    output.texcoord = texcoord;

    return output;
}

float4 PS_Mountain(float3 color, VS_MountainOut input)
{
	// linear distance from center fade
	float d = max(0, min(1, (length(input.pos.xz) / 18.0 - 0.25) / 0.75));
	color = lerp(color, fog, d);
    return float4(color, 1);
}

float4 PS_Single(VS_MountainOut input) : SV_TARGET0
{
	float3 color = SAMPLE_TEXTURE(ao0, float2(input.texcoord.x, 1 - input.texcoord.y));
	return PS_Mountain(color, input);
}

float4 PS_Easing(VS_MountainOut input) : SV_TARGET0
{
	float3 lightmap0 = SAMPLE_TEXTURE(ao0, float2(input.texcoord.x, 1 - input.texcoord.y));
	float3 lightmap1 = SAMPLE_TEXTURE(ao1, float2(input.texcoord.x, 1 - input.texcoord.y));
	return PS_Mountain(lerp(lightmap0, lightmap1, ease), input);
}

technique Single
{
    pass Base
    {
        VertexShader = compile VS_SHADER_COMPILER VS_Mountain();
        PixelShader = compile PS_3_SHADER_COMPILER PS_Single();
    }
}

technique Easing
{
	pass Base
	{
		VertexShader = compile VS_SHADER_COMPILER VS_Mountain();
		PixelShader = compile PS_3_SHADER_COMPILER PS_Easing();
	}
}