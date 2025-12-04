#!/usr/bin/env python3
"""
Convert Effekseer SPIR-V shader headers to WGSL using naga-cli.

This script:
1. Reads the C header files containing SPIR-V bytecode
2. Extracts the uint32_t array
3. Writes it as a binary .spv file
4. Calls naga to convert to WGSL
"""

import os
import re
import struct
import subprocess
import sys
from pathlib import Path

def extract_spirv_from_header(header_path: Path) -> bytes:
    """Extract SPIR-V bytecode from a C header file."""
    content = header_path.read_text()
    
    # Find the array values: matches hex numbers like 0x07230203
    pattern = r'0x([0-9a-fA-F]+)'
    matches = re.findall(pattern, content)
    
    if not matches:
        raise ValueError(f"No SPIR-V data found in {header_path}")
    
    # Convert hex strings to uint32 values and pack as little-endian bytes
    spirv_bytes = b''.join(struct.pack('<I', int(m, 16)) for m in matches)
    
    # Verify SPIR-V magic number (0x07230203)
    if len(spirv_bytes) >= 4:
        magic = struct.unpack('<I', spirv_bytes[:4])[0]
        if magic != 0x07230203:
            raise ValueError(f"Invalid SPIR-V magic number: 0x{magic:08x}")
    
    return spirv_bytes

def convert_to_wgsl(spv_data: bytes, output_path: Path, shader_name: str) -> bool:
    """Convert SPIR-V binary to WGSL using naga."""
    # Write temporary .spv file
    temp_spv = output_path.parent / f"{shader_name}.spv"
    temp_spv.write_bytes(spv_data)
    
    try:
        # Call naga to convert
        result = subprocess.run(
            ['naga', '--input-kind', 'spv', str(temp_spv), str(output_path)],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            print(f"  Error converting {shader_name}:")
            print(f"    {result.stderr}")
            return False
        
        return True
    finally:
        # Clean up temp file
        if temp_spv.exists():
            temp_spv.unlink()

def main():
    script_dir = Path(__file__).parent
    effekseer_root = script_dir.parent
    
    # Source: Vulkan SPIR-V headers
    vulkan_headers = effekseer_root / "Dev/Cpp/EffekseerRendererVulkan/EffekseerRendererVulkan/ShaderHeader"
    
    # Output: WebGPU WGSL shaders
    webgpu_shaders = effekseer_root / "Dev/Cpp/EffekseerRendererWebGPU/EffekseerRendererWebGPU/Shader"
    webgpu_shaders.mkdir(parents=True, exist_ok=True)
    
    if not vulkan_headers.exists():
        print(f"Error: Vulkan shader headers not found at {vulkan_headers}")
        sys.exit(1)
    
    # Process all .h files
    success_count = 0
    fail_count = 0
    
    for header_file in sorted(vulkan_headers.glob("*.h")):
        shader_name = header_file.stem  # e.g., "sprite_unlit_vs"
        output_file = webgpu_shaders / f"{shader_name}.wgsl"
        
        print(f"Converting {shader_name}...")
        
        try:
            # Extract SPIR-V
            spirv_data = extract_spirv_from_header(header_file)
            print(f"  Extracted {len(spirv_data)} bytes of SPIR-V")
            
            # Convert to WGSL
            if convert_to_wgsl(spirv_data, output_file, shader_name):
                print(f"  -> {output_file.name}")
                success_count += 1
            else:
                fail_count += 1
                
        except Exception as e:
            print(f"  Error: {e}")
            fail_count += 1
    
    print(f"\nDone! Converted {success_count} shaders, {fail_count} failed.")

if __name__ == "__main__":
    main()
