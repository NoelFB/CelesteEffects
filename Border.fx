#include "Common.fxh"

//-----------------------------------------------------------------------------
// Globals.
//-----------------------------------------------------------------------------

DECLARE_TEXTURE(text, 0);
float2 pixel;

struct VS_Out
{
	float4 position : SV_Position;
	float4 color : COLOR0;
	float2 uv : TEXCOORD1;
};


//-----------------------------------------------------------------------------
// Vertex Shaders.
//-----------------------------------------------------------------------------

float4x4 MatrixTransform;

VS_Out VS_Function(
	float4 position : POSITION0,
	float4 color    : COLOR0,
	float2 texCoord : TEXCOORD0)
{
	VS_Out vs_out;
	vs_out.position = mul(position, MatrixTransform);
	vs_out.color = color;
	vs_out.uv = texCoord;
	return vs_out;
}

//-----------------------------------------------------------------------------
// Pixel Shaders.
//-----------------------------------------------------------------------------

float4 PS_Function(float4 inPosition : SV_Position, float4 inColor : COLOR0, float2 uv : TEXCOORD0) : SV_TARGET0
{
    float4 current = SAMPLE_TEXTURE(text, uv);

    float visible = 0;
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(pixel.x, 0)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(-pixel.x, 0)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(0, pixel.y)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(0, -pixel.y)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(pixel.x, pixel.y)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(-pixel.x, -pixel.y)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(-pixel.x, pixel.y)).a);
    visible = max(visible, SAMPLE_TEXTURE(text, uv + float2(pixel.x, -pixel.y)).a);

    return visible * float4(current.rgb * current.a, 1);
}

//-----------------------------------------------------------------------------
// Techniques.
//-----------------------------------------------------------------------------

technique Dust
{
    pass
    {
        VertexShader = compile VS_SHADER_COMPILER VS_Function();
        PixelShader = compile PS_3_SHADER_COMPILER PS_Function();
    }
}
