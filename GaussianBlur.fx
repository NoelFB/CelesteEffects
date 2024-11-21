#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

float2 pixel;
float fade = 0;

DECLARE_TEXTURE(text, 0);

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float4 PS_GaussianBlur_9(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 color = 0;
    float4 center = SAMPLE_TEXTURE(text, float2(uv.x, uv.y));

    color += SAMPLE_TEXTURE(text, uv - pixel * 4) * 0.05f;
    color += SAMPLE_TEXTURE(text, uv - pixel * 3) * 0.09f;
    color += SAMPLE_TEXTURE(text, uv - pixel * 2) * 0.12f;
    color += SAMPLE_TEXTURE(text, uv - pixel * 1) * 0.15f;
    color += center                               * 0.18f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 1) * 0.15f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 2) * 0.12f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 3) * 0.09f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 4) * 0.05f;

    return lerp(color, float4(0,0,0,0), (1.0 - length(uv - 0.5)) * fade);
}

float4 PS_GaussianBlur_5(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
	float4 color = 0;
	float4 center = SAMPLE_TEXTURE(text, float2(uv.x, uv.y));

	color += SAMPLE_TEXTURE(text, uv - pixel * 4) * 0.15f;
	color += SAMPLE_TEXTURE(text, uv - pixel * 2) * 0.20f;
	color += center                               * 0.30f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 2) * 0.20f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 4) * 0.15f;

	return lerp(color, float4(0, 0, 0, 0), (1.0 - length(uv - 0.5)) * fade);
}

float4 PS_GaussianBlur_3(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
	float4 color = 0;
	float4 center = SAMPLE_TEXTURE(text, float2(uv.x, uv.y));

	color += SAMPLE_TEXTURE(text, uv - pixel * 3) * 0.25f;
	color += center                               * 0.50f;
	color += SAMPLE_TEXTURE(text, uv + pixel * 3) * 0.25f;

	return lerp(color, float4(0, 0, 0, 0), (1.0 - length(uv - 0.5)) * fade);
}


//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique GaussianBlur9
{
	pass { PixelShader = compile PS_2_SHADER_COMPILER PS_GaussianBlur_9(); }
}

technique GaussianBlur5
{
	pass { PixelShader = compile PS_2_SHADER_COMPILER PS_GaussianBlur_5(); }
}

technique GaussianBlur3
{
	pass { PixelShader = compile PS_2_SHADER_COMPILER PS_GaussianBlur_3(); }
}