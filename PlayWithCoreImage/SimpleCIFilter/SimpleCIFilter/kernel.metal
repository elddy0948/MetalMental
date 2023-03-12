#include <metal_stdlib>
#include <CoreImage/CoreImage.h>

using namespace metal;


extern "C" {
  namespace coreimage {
    float4 customTransformation(sample_t s) {
      return s.rbga;
    }
  }
} 
