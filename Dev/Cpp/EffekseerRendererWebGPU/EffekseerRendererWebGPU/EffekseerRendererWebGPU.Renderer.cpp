/**
 * EffekseerRendererWebGPU - WebGPU Renderer Implementation
 */

#include "EffekseerRendererWebGPU.Renderer.h"
#include "../../3rdParty/LLGI/src/WebGPU/LLGI.CommandListWebGPU.h"
#include "../../3rdParty/LLGI/src/WebGPU/LLGI.GraphicsWebGPU.h"
#include "../../3rdParty/LLGI/src/WebGPU/LLGI.TextureWebGPU.h"
#include <EffekseerRendererLLGI/EffekseerRendererLLGI.RendererImplemented.h>

// WGSL Shader Headers - Basic Sprites
#include "ShaderHeader/sprite_unlit_vs.h"
#include "ShaderHeader/sprite_lit_vs.h"
#include "ShaderHeader/sprite_distortion_vs.h"

// WGSL Shader Headers - Basic Models
#include "ShaderHeader/model_unlit_vs.h"
#include "ShaderHeader/model_unlit_ps.h"
#include "ShaderHeader/model_lit_vs.h"
#include "ShaderHeader/model_lit_ps.h"
#include "ShaderHeader/model_distortion_vs.h"
#include "ShaderHeader/model_distortion_ps.h"

// WGSL Shader Headers - Advanced Sprites
#include "ShaderHeader/ad_sprite_unlit_vs.h"
#include "ShaderHeader/ad_sprite_lit_vs.h"
#include "ShaderHeader/ad_sprite_distortion_vs.h"

// WGSL Shader Headers - Advanced Models
#include "ShaderHeader/ad_model_unlit_vs.h"
#include "ShaderHeader/ad_model_unlit_ps.h"
#include "ShaderHeader/ad_model_lit_vs.h"
#include "ShaderHeader/ad_model_lit_ps.h"
#include "ShaderHeader/ad_model_distortion_vs.h"
#include "ShaderHeader/ad_model_distortion_ps.h"

// WGSL Shader Headers - GPU Particles
#include "ShaderHeader/gpu_particles_clear_cs.h"
#include "ShaderHeader/gpu_particles_spawn_cs.h"
#include "ShaderHeader/gpu_particles_update_cs.h"
#include "ShaderHeader/gpu_particles_render_vs.h"
#include "ShaderHeader/gpu_particles_render_ps.h"

// Macro to create LLGI::DataStructure from WGSL string
#define GENERATE_WGSL_VIEW(x) {{x##_wgsl, x##_wgsl_len}}

namespace EffekseerRendererWebGPU
{

namespace
{

/**
 * Convert WebGPU texture format to LLGI texture format
 */
LLGI::TextureFormatType ConvertFormat(WGPUTextureFormat format)
{
    switch (format)
    {
    case WGPUTextureFormat_RGBA8Unorm:
        return LLGI::TextureFormatType::R8G8B8A8_UNORM;
    case WGPUTextureFormat_BGRA8Unorm:
        return LLGI::TextureFormatType::B8G8R8A8_UNORM;
    case WGPUTextureFormat_RGBA8UnormSrgb:
        return LLGI::TextureFormatType::R8G8B8A8_UNORM_SRGB;
    case WGPUTextureFormat_BGRA8UnormSrgb:
        return LLGI::TextureFormatType::B8G8R8A8_UNORM_SRGB;
    case WGPUTextureFormat_RGBA16Float:
        return LLGI::TextureFormatType::R16G16B16A16_FLOAT;
    case WGPUTextureFormat_RGBA32Float:
        return LLGI::TextureFormatType::R32G32B32A32_FLOAT;
    case WGPUTextureFormat_Depth32Float:
        return LLGI::TextureFormatType::D32;
    case WGPUTextureFormat_Depth24PlusStencil8:
        return LLGI::TextureFormatType::D24S8;
    case WGPUTextureFormat_Depth32FloatStencil8:
        return LLGI::TextureFormatType::D32S8;
    default:
        return LLGI::TextureFormatType::Unknown;
    }
}

/**
 * Create fixed shaders for WebGPU (WGSL format)
 */
void CreateFixedShaderForWebGPU(EffekseerRendererLLGI::FixedShader* shader)
{
    assert(shader);
    if (!shader)
        return;

    // Basic Sprite Vertex Shaders
    shader->SpriteUnlit_VS = GENERATE_WGSL_VIEW(sprite_unlit_vs);
    shader->SpriteLit_VS = GENERATE_WGSL_VIEW(sprite_lit_vs);
    shader->SpriteDistortion_VS = GENERATE_WGSL_VIEW(sprite_distortion_vs);

    // Basic Model Shaders
    shader->ModelUnlit_VS = GENERATE_WGSL_VIEW(model_unlit_vs);
    shader->ModelUnlit_PS = GENERATE_WGSL_VIEW(model_unlit_ps);
    shader->ModelLit_VS = GENERATE_WGSL_VIEW(model_lit_vs);
    shader->ModelLit_PS = GENERATE_WGSL_VIEW(model_lit_ps);
    shader->ModelDistortion_VS = GENERATE_WGSL_VIEW(model_distortion_vs);
    shader->ModelDistortion_PS = GENERATE_WGSL_VIEW(model_distortion_ps);

    // Advanced Sprite Vertex Shaders
    shader->AdvancedSpriteUnlit_VS = GENERATE_WGSL_VIEW(ad_sprite_unlit_vs);
    shader->AdvancedSpriteLit_VS = GENERATE_WGSL_VIEW(ad_sprite_lit_vs);
    shader->AdvancedSpriteDistortion_VS = GENERATE_WGSL_VIEW(ad_sprite_distortion_vs);

    // Advanced Model Shaders
    shader->AdvancedModelUnlit_VS = GENERATE_WGSL_VIEW(ad_model_unlit_vs);
    shader->AdvancedModelUnlit_PS = GENERATE_WGSL_VIEW(ad_model_unlit_ps);
    shader->AdvancedModelLit_VS = GENERATE_WGSL_VIEW(ad_model_lit_vs);
    shader->AdvancedModelLit_PS = GENERATE_WGSL_VIEW(ad_model_lit_ps);
    shader->AdvancedModelDistortion_VS = GENERATE_WGSL_VIEW(ad_model_distortion_vs);
    shader->AdvancedModelDistortion_PS = GENERATE_WGSL_VIEW(ad_model_distortion_ps);

    // GPU Particles
    shader->GpuParticles_Clear_CS = GENERATE_WGSL_VIEW(gpu_particles_clear_cs);
    shader->GpuParticles_Spawn_CS = GENERATE_WGSL_VIEW(gpu_particles_spawn_cs);
    shader->GpuParticles_Update_CS = GENERATE_WGSL_VIEW(gpu_particles_update_cs);
    shader->GpuParticles_Render_VS = GENERATE_WGSL_VIEW(gpu_particles_render_vs);
    shader->GpuParticles_Render_PS = GENERATE_WGSL_VIEW(gpu_particles_render_ps);
}

} // anonymous namespace

::Effekseer::Backend::GraphicsDeviceRef CreateGraphicsDevice(
    WGPUDevice device, 
    WGPUQueue queue, 
    int32_t swapBufferCount)
{
    auto graphics = new LLGI::GraphicsWebGPU(device, queue, swapBufferCount, nullptr);

    auto ret = Effekseer::MakeRefPtr<EffekseerRendererLLGI::Backend::GraphicsDevice>(graphics);
    ES_SAFE_RELEASE(graphics);
    return ret;
}

::EffekseerRenderer::RendererRef Create(
    ::Effekseer::Backend::GraphicsDeviceRef graphicsDevice, 
    RenderPassInformation renderPassInformation, 
    int32_t squareMaxCount)
{
    auto gd = graphicsDevice.DownCast<EffekseerRendererLLGI::Backend::GraphicsDevice>();

    auto renderer = Effekseer::MakeRefPtr<::EffekseerRendererLLGI::RendererImplemented>(squareMaxCount);
    CreateFixedShaderForWebGPU(&renderer->fixedShader_);

    LLGI::RenderPassPipelineStateKey key;
    key.RenderTargetFormats.resize(renderPassInformation.RenderTextureCount);
    key.IsPresent = renderPassInformation.DoesPresentToScreen;
    
    for (size_t i = 0; i < key.RenderTargetFormats.size(); i++)
    {
        key.RenderTargetFormats.at(i) = ConvertFormat(renderPassInformation.RenderTextureFormats.at(i));
    }

    key.DepthFormat = ConvertFormat(renderPassInformation.DepthFormat);
    key.SamplingCount = renderPassInformation.SampleCount;

    if (!renderer->Initialize(gd, key, false))
    {
        return nullptr;
    }

    // WebGPU uses WGSL shaders - set appropriate platform type
    // Note: There's no WGSL material compiler yet, so custom materials won't work
    renderer->platformType_ = Effekseer::CompiledMaterialPlatformType::Vulkan; // Placeholder
    renderer->materialCompiler_ = nullptr; // TODO: Create WebGPU material compiler

    return renderer;
}

::EffekseerRenderer::RendererRef Create(
    WGPUDevice device,
    WGPUQueue queue,
    int32_t swapBufferCount,
    RenderPassInformation renderPassInformation,
    int32_t squareMaxCount)
{
    auto graphicsDevice = CreateGraphicsDevice(device, queue, swapBufferCount);
    
    auto ret = Create(graphicsDevice, renderPassInformation, squareMaxCount);
    
    return ret;
}

Effekseer::Backend::TextureRef CreateTexture(
    ::Effekseer::Backend::GraphicsDeviceRef graphicsDevice,
    WGPUTexture texture,
    WGPUTextureView view,
    WGPUTextureFormat format,
    int32_t width,
    int32_t height)
{
    auto g = static_cast<::EffekseerRendererLLGI::Backend::GraphicsDevice*>(graphicsDevice.Get());
    
    // Pack texture info for LLGI
    struct WebGPUTextureInfo
    {
        WGPUTexture texture;
        WGPUTextureView view;
        WGPUTextureFormat format;
        int32_t width;
        int32_t height;
    };
    
    WebGPUTextureInfo info = {texture, view, format, width, height};
    
    return g->CreateTexture(reinterpret_cast<uint64_t>(&info), [] {});
}

void BeginCommandList(
    Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList, 
    WGPUCommandEncoder encoder)
{
    assert(commandList != nullptr);
    
    auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
    
    // WebGPU uses command encoder passed from platform
    // Begin with platform-specific context
    static_cast<LLGI::CommandListWebGPU*>(c->GetInternal())->BeginWithPlatform(encoder);
}

void EndCommandList(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList)
{
    assert(commandList != nullptr);
    
    auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
    c->GetInternal()->EndWithPlatform();
}

void BeginRenderPass(
    Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList,
    WGPURenderPassEncoder renderPassEncoder)
{
    assert(commandList != nullptr);
    
    auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
    
    // Pass render pass encoder to LLGI
    c->GetInternal()->BeginRenderPassWithPlatformPtr(renderPassEncoder);
}

void EndRenderPass(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList)
{
    assert(commandList != nullptr);
    
    auto c = static_cast<EffekseerRendererLLGI::CommandList*>(commandList.Get());
    c->GetInternal()->EndRenderPassWithPlatformPtr();
}

} // namespace EffekseerRendererWebGPU
