#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

DECLARE_TEXTURE(mask, 0);
DECLARE_TEXTURE(source, 1);

float2 pixel;

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float4 PS_Mirrors(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    // get mask texture colors
    float4 maskColor = SAMPLE_TEXTURE(mask, uv);

    // get offset based on mask
    float2 offset = float2(floor(((maskColor.r - 0.5) * pixel.x * 64.0) / pixel.x) * pixel.x, 
                           floor(((maskColor.g - 0.5) * pixel.y * 64.0) / pixel.y) * pixel.y);

    // sample at offset, shift to blue-ish
    float4 reflection = SAMPLE_TEXTURE(source, uv + offset);
    return maskColor.a * float4(reflection.r * 0.75, reflection.g * 0.75, reflection.b * 1.4, reflection.a);
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique Default
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_Mirrors();
    }
}
