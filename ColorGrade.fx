#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

DECLARE_TEXTURE(text, 0);
DECLARE_TEXTURE(gradeFrom, 1)
{
    AddressU = Clamp;
    AddressV = Clamp;
};
DECLARE_TEXTURE(gradeTo, 2)
{
    AddressU = Clamp;
    AddressV = Clamp;
};
float percent;

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

// lerps between 2 color grades (gradeFrom, gradeTo, by percent)
float4 PS_ColorGrade(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 color = SAMPLE_TEXTURE(text, uv) * inColor;
    float size = 16.0;
    float sqrd = size * size;

    float offX = color.x * (1.0 / sqrd) * (size - 1.0) + (1.0 / sqrd) * 0.5;
    float offY = color.y + (1.0 / size) * 0.5;
    float zSlice0 = min(floor(color.z * size), size - 1.0);
    float zSlice1 = min(zSlice0 + 1.0, size - 1.0);

    float2 index0 = float2(offX + zSlice0 / size, offY);
    float2 index1 = float2(offX + zSlice1 / size, offY);
    float3 from0 = SAMPLE_TEXTURE(gradeFrom, index0).xyz;
    float3 from1 = SAMPLE_TEXTURE(gradeFrom, index1).xyz;
    float3 to0 = SAMPLE_TEXTURE(gradeTo, index0).xyz;
    float3 to1 = SAMPLE_TEXTURE(gradeTo, index1).xyz;

    float zOffset = fmod(color.z * size, 1.0);
    float3 from = lerp(from0, from1, zOffset);
    float3 to = lerp(to0, to1, zOffset);

    return float4(lerp(from, to, percent) * color.a, color.a);
}

// samples from a single color grade (gradeFrom)
float4 PS_ColorGrade_Single(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 color = SAMPLE_TEXTURE(text, uv) * inColor;
    float size = 16.0;
    float sqrd = size * size;

    float offX = color.x * (1.0 / sqrd) * (size - 1.0) + (1.0 / sqrd) * 0.5;
    float offY = color.y + (1.0 / size) * 0.5;
    float zSlice0 = min(floor(color.z * size), size - 1.0);
    float zSlice1 = min(zSlice0 + 1.0, size - 1.0);

    float3 sample0 = SAMPLE_TEXTURE(gradeFrom, float2(offX + zSlice0 / size, offY)).xyz;
    float3 sample1 = SAMPLE_TEXTURE(gradeFrom, float2(offX + zSlice1 / size, offY)).xyz;

    return float4(lerp(sample0, sample1, fmod(color.z * size, 1.0)) * color.a, color.a);
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique ColorGrade
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_ColorGrade();
    }
}

technique ColorGradeSingle
{
    pass
    {
        PixelShader = compile PS_2_SHADER_COMPILER PS_ColorGrade_Single();
    }
}
