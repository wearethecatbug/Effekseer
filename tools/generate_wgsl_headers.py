#!/usr/bin/env python3
"""
Generate C++ header files from WGSL shaders for WebGPU backend.

This script reads .wgsl files and generates C++ headers with the shader
source as a character array (similar to how Vulkan stores SPIR-V bytecode).
"""

import os
import re
from pathlib import Path

def escape_for_cpp(content: str) -> str:
    """Escape a string for embedding in C++ as a char array."""
    result = []
    for char in content:
        if char == '\n':
            result.append('\\n')
        elif char == '\r':
            pass  # Skip carriage returns
        elif char == '\\':
            result.append('\\\\')
        elif char == '"':
            result.append('\\"')
        elif char == '\t':
            result.append('\\t')
        else:
            result.append(char)
    return ''.join(result)

def generate_header(shader_name: str, wgsl_content: str) -> str:
    """Generate a C++ header file content for a WGSL shader."""
    escaped = escape_for_cpp(wgsl_content)
    
    # Calculate size (including null terminator)
    size = len(wgsl_content) + 1
    
    header = f"""// Auto-generated from {shader_name}.wgsl
// Do not edit manually

#pragma once

static const char {shader_name}_wgsl[] = 
"{escaped}";

static const int {shader_name}_wgsl_len = {size};
"""
    return header

def main():
    script_dir = Path(__file__).parent
    effekseer_root = script_dir.parent
    
    # Source: WebGPU WGSL shaders
    shader_dir = effekseer_root / "Dev/Cpp/EffekseerRendererWebGPU/EffekseerRendererWebGPU/Shader"
    
    # Output: ShaderHeader directory
    header_dir = effekseer_root / "Dev/Cpp/EffekseerRendererWebGPU/EffekseerRendererWebGPU/ShaderHeader"
    header_dir.mkdir(parents=True, exist_ok=True)
    
    if not shader_dir.exists():
        print(f"Error: Shader directory not found at {shader_dir}")
        return
    
    # Process all .wgsl files
    count = 0
    for wgsl_file in sorted(shader_dir.glob("*.wgsl")):
        shader_name = wgsl_file.stem  # e.g., "sprite_unlit_vs"
        
        print(f"Processing {shader_name}...")
        
        # Read WGSL content
        wgsl_content = wgsl_file.read_text(encoding='utf-8')
        
        # Generate header
        header_content = generate_header(shader_name, wgsl_content)
        
        # Write header file
        header_file = header_dir / f"{shader_name}.h"
        header_file.write_text(header_content, encoding='utf-8')
        
        print(f"  -> {header_file.name}")
        count += 1
    
    print(f"\nGenerated {count} shader headers in {header_dir}")

if __name__ == "__main__":
    main()
