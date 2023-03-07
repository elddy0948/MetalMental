#include "Foundation.hpp"
#include "Metal.hpp"
#include "QuartzCore.hpp"

class Renderer {
public:
  Renderer(CA::MetalDrawable* const pDrawable, MTL::Device* const pDevice);
  ~Renderer();
  void draw() const;
  
private:
  CA::MetalDrawable* _pDrawable;
  MTL::Device* const _pDevice;
  MTL::CommandQueue* const _pCommandQueue;
};
