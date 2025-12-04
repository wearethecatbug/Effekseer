
#ifndef __EFFEKSEERRENDERER_WEBGPU_RENDERER_H__
#define __EFFEKSEERRENDERER_WEBGPU_RENDERER_H__

#include "EffekseerRendererWebGPU.Base.Pre.h"
#include <EffekseerRendererCommon/EffekseerRenderer.Renderer.h>
#include <functional>

namespace EffekseerRendererWebGPU
{

/**
 * Render pass information for WebGPU
 */
struct RenderPassInformation
{
    bool DoesPresentToScreen = false;
    std::array<WGPUTextureFormat, 8> RenderTextureFormats = {};
    int32_t RenderTextureCount = 1;
    WGPUTextureFormat DepthFormat = WGPUTextureFormat_Undefined;
    int32_t SampleCount = 1;
};

/**
 * Create graphics device from WebGPU device/queue
 * 
 * @param device WebGPU device handle
 * @param queue WebGPU queue handle
 * @param swapBufferCount Number of swap chain buffers (typically 2-3)
 * @return Graphics device reference for use with Effekseer
 */
::Effekseer::Backend::GraphicsDeviceRef CreateGraphicsDevice(
    WGPUDevice device, 
    WGPUQueue queue, 
    int32_t swapBufferCount);

/**
 * Create Effekseer renderer from graphics device
 * 
 * @param graphicsDevice Graphics device created with CreateGraphicsDevice
 * @param renderPassInformation Render pass configuration
 * @param squareMaxCount Maximum number of sprites to render
 * @return Renderer reference
 */
::EffekseerRenderer::RendererRef Create(
    ::Effekseer::Backend::GraphicsDeviceRef graphicsDevice, 
    RenderPassInformation renderPassInformation, 
    int32_t squareMaxCount);

/**
 * Create Effekseer renderer directly from WebGPU handles
 * 
 * @param device WebGPU device handle
 * @param queue WebGPU queue handle
 * @param swapBufferCount Number of swap chain buffers
 * @param renderPassInformation Render pass configuration
 * @param squareMaxCount Maximum number of sprites to render
 * @return Renderer reference
 */
::EffekseerRenderer::RendererRef Create(
    WGPUDevice device,
    WGPUQueue queue,
    int32_t swapBufferCount,
    RenderPassInformation renderPassInformation,
    int32_t squareMaxCount);

/**
 * Create texture from external WebGPU texture
 * 
 * @param graphicsDevice Graphics device
 * @param texture WebGPU texture handle
 * @param view WebGPU texture view handle
 * @param format Texture format
 * @param width Texture width
 * @param height Texture height
 * @return Texture reference
 */
Effekseer::Backend::TextureRef CreateTexture(
    ::Effekseer::Backend::GraphicsDeviceRef graphicsDevice,
    WGPUTexture texture,
    WGPUTextureView view,
    WGPUTextureFormat format,
    int32_t width,
    int32_t height);

/**
 * Begin recording commands to a command list
 * Call before rendering Effekseer effects in a frame
 * 
 * @param commandList Effekseer command list
 * @param encoder WebGPU command encoder for this frame
 */
void BeginCommandList(
    Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList, 
    WGPUCommandEncoder encoder);

/**
 * End recording commands to a command list
 * Call after rendering Effekseer effects in a frame
 * 
 * @param commandList Effekseer command list
 */
void EndCommandList(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList);

/**
 * Begin a render pass for Effekseer rendering
 * 
 * @param commandList Effekseer command list
 * @param renderPassEncoder WebGPU render pass encoder
 */
void BeginRenderPass(
    Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList,
    WGPURenderPassEncoder renderPassEncoder);

/**
 * End a render pass for Effekseer rendering
 * 
 * @param commandList Effekseer command list
 */
void EndRenderPass(Effekseer::RefPtr<EffekseerRenderer::CommandList> commandList);

} // namespace EffekseerRendererWebGPU

#endif // __EFFEKSEERRENDERER_WEBGPU_RENDERER_H__
