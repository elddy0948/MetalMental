import MetalKit
import CoreImage

final class MetalView: MTKView {
  var context: CIContext
  var commandQueue: MTLCommandQueue
  
  override init(frame frameRect: CGRect, device: MTLDevice?) {
    let device = device ?? MTLCreateSystemDefaultDevice()!
    self.context = CIContext(mtlDevice: device, options: [.cacheIntermediates : false])
    self.commandQueue = device.makeCommandQueue()!
    
    super.init(frame: frameRect, device: device)
    
    framebufferOnly = false // allow Core Image to use Metal compute.
    colorPixelFormat = MTLPixelFormat.rgba16Float
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
