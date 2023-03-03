import Cocoa
import MetalKit

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let device = MTLCreateSystemDefaultDevice() else {
      fatalError("Cannot find device!")
    }
    
    let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    let view = MTKView(frame: frame, device: device)
    
    view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)
    
    let allocator = MTKMeshBufferAllocator(device: device)
    let mdlMesh = MDLMesh(
      sphereWithExtent: [0.75, 0.75, 0.75],
      segments: [100, 100],
      inwardNormals: false,
      geometryType: .triangles,
      allocator: allocator)
    
    do {
      let mesh = try MTKMesh(mesh: mdlMesh, device: device)
      guard let commandQueue = device.makeCommandQueue() else {
        fatalError("Failed to create command queue")
      }

      
      let library = device.makeDefaultLibrary()
      let vertexFunction = library?.makeFunction(name: "vertex_main")
      let fragmentFunction = library?.makeFunction(name: "fragment_main")
      
      let pipelineDescriptor = MTLRenderPipelineDescriptor()
      pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
      pipelineDescriptor.vertexFunction = vertexFunction
      pipelineDescriptor.fragmentFunction = fragmentFunction
      pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
      
      let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      
      guard let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
        fatalError("Error! while create command buffer")
      }
      
      renderEncoder.setRenderPipelineState(pipelineState)
      renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
      
      guard let submesh = mesh.submeshes.first else { fatalError() }
      
      renderEncoder.drawIndexedPrimitives(
        type: .triangle,
        indexCount: submesh.indexCount,
        indexType: submesh.indexType,
        indexBuffer: submesh.indexBuffer.buffer,
        indexBufferOffset: 0)
      
      renderEncoder.endEncoding()
      
      guard let drawable = view.currentDrawable else { fatalError() }
      
      commandBuffer.present(drawable)
      commandBuffer.commit()
    } catch {
      print(error)
    }
    
    self.view = view
    
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

