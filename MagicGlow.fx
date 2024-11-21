#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

DECLARE_TEXTURE(text, 0);
DECLARE_TEXTURE(noise, 1);

float noiseEase;
float alpha;
float2 pixel;
float2 noiseSample;
float2 noiseDistort;
float direction;

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float4 PS_Glow(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    // sample downwards (smoke moves up)
    float4 color = float4(0.0f, 0.0f, 0.0f, 0.0f);
    float4 noiseval = SAMPLE_TEXTURE(noise, uv * noiseSample + float2(0, noiseEase));
    float2 pos = uv + float2(noiseval.g - 0.5, noiseval.b - 0.5) * pixel * noiseDistort * 2;

    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * 0)) * 1.00f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction)) * 0.94f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 2)) * 0.88f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 3)) * 0.82f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 4)) * 0.76f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 5)) * 0.70f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 6)) * 0.64f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 7)) * 0.58f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 8)) * 0.52f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 9)) * 0.46f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 10)) * 0.40f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 11)) * 0.34f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 12)) * 0.28f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 13)) * 0.22f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 14)) * 0.16f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 15)) * 0.10f;
    color += SAMPLE_TEXTURE(text, float2(pos.x, pos.y + pixel.y * direction * 16)) * 0.04f;

    return color * noiseval.r * alpha;
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique Glow
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_Glow();
    }
}
