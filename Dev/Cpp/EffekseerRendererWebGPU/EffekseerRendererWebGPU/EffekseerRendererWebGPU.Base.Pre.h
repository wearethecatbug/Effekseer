
#ifndef __EFFEKSEERRENDERER_WEBGPU_BASE_PRE_H__
#define __EFFEKSEERRENDERER_WEBGPU_BASE_PRE_H__

/**
 * EffekseerRendererWebGPU - WebGPU Backend for Effekseer
 * 
 * This renderer provides WebGPU support via LLGI abstraction layer.
 * Supports:
 * - Native platforms via Dawn (Windows, macOS, Linux)
 * - Web browsers via Emscripten + emdawnwebgpu
 */

#include <Effekseer.h>

// WebGPU headers
#ifdef __EMSCRIPTEN__
#include <webgpu/webgpu.h>
#else
// Dawn native
#include <webgpu/webgpu.h>
#endif

namespace EffekseerRendererWebGPU
{

} // namespace EffekseerRendererWebGPU

#endif // __EFFEKSEERRENDERER_WEBGPU_BASE_PRE_H__
