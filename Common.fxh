// Platform-Specific Definitions
// for XNA/FNA/MonoGame:

#define DECLARE_TEXTURE(Name, index) \
    texture Name: register(t##index); \
    sampler Name##Sampler: register(s##index)

#define SAMPLE_TEXTURE(Name, texCoord) tex2D(Name##Sampler, texCoord)

#define PS_3_SHADER_COMPILER ps_3_0
#define PS_2_SHADER_COMPILER ps_2_0
#define VS_SHADER_COMPILER vs_3_0
#define VS_2_SHADER_COMPILER vs_2_0

#define SV_TARGET0 COLOR0
#define SV_TARGET1 COLOR1
#define SV_TARGET2 COLOR2