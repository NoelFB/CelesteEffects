#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

float glitch;
float seed;
float timer;
float amplitude;
float minimum;
float2 dimensions;

DECLARE_TEXTURE(text, 0);

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float rand(float2 co)
{
    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

float4 PS_Glitch(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    // get the multiplier (based on "chunk")
    float mult = abs(max(minimum, sin(timer + uv.y * amplitude))) * glitch;

    float pixelSize = max(1, floor(16.0 * mult));
    float offset = rand(float2(seed, pixelSize));

    float2 org = float2(max(0, min(1, uv.x + (offset * 0.1 - 0.05) * mult)), uv.y);
    float2 size = dimensions.xy / pixelSize;
    float2 xy = floor(org * size) / size + pixelSize / dimensions.xy * 0.5;

    // grab the color
    float4 color = SAMPLE_TEXTURE(text, xy);
    return color + float4(offset, (offset + 0.34) % 1, (offset + 0.66) % 1, 1) * color.a * 0.25 * mult;
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique Glitch
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_Glitch();
    }
}