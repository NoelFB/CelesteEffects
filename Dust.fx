#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

DECLARE_TEXTURE(text, 0);

float3 colors[3];
float noiseEase;
float2 noiseFromPos;
float2 noiseToPos;
float2 pixel;
DECLARE_TEXTURE(noiseFrom, 1);
DECLARE_TEXTURE(noiseTo, 2);

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float4 PS_Dust(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float visible = max(SAMPLE_TEXTURE(text, uv + float2(pixel.x, 0)).a, 
                    max(SAMPLE_TEXTURE(text, uv + float2(-pixel.x, 0)).a, 
                    max(SAMPLE_TEXTURE(text, uv + float2(0, pixel.y)).a, SAMPLE_TEXTURE(text, uv + float2(0, -pixel.y)).a)));

    float2 pfrom = float2((1 + uv.x + noiseFromPos.x) % 1, (1 + uv.y + noiseFromPos.y) % 1);
    float2 pto = float2((1 + uv.x + noiseToPos.x) % 1, (1 + uv.y + noiseToPos.y) % 1);

    float from = SAMPLE_TEXTURE(noiseFrom, pfrom).r;
    float to = SAMPLE_TEXTURE(noiseTo, pto).r;
    float ease = (from + (to - from) * noiseEase);
    
    return float4(colors[floor(ease * 3)], 1) * visible;
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique Dust
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_Dust();
    }
}
