#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

float2 size;
DECLARE_TEXTURE(text, 0);

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------
float bayer4x4(float2 uvScreenSpace)
{
    float2 bayerCoord = floor(uvScreenSpace * size);

    const float4x4 bayerMat = float4x4(
        1, 9, 3, 11,
        13, 5, 15, 7,
        4, 12, 2, 10,
        16, 8, 14, 6) / 16.0;

    return bayerMat[bayerCoord.x % 4][bayerCoord.y % 4];
}


float4 PS_InvertDither(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 color = SAMPLE_TEXTURE(text, uv);
    return (float4(1.0 - color.rgb, color.a) * inColor) + ((bayer4x4(uv) - .5) / 256.0);
}

float4 PS_Dither(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 color = SAMPLE_TEXTURE(text, uv);
    return (color * inColor) + ((bayer4x4(uv) - .5) / 256.0);
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique InvertDither
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_InvertDither();
    }
}

technique Dither
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_Dither();
    }
}