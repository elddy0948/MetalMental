import Cocoa
import MetalKit

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let device = MTLCreateSystemDefaultDevice() else {
      fatalError("Failed to create device")
    }
    
    guard let commandQueue = device.makeCommandQueue() else {
      fatalError("Failed to make command queue")
    }
    
    //MARK: - MTKView
    let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    let mtkView = MTKView(frame: frame, device: device)
    mtkView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
    
    //MARK: - Mesh
    let allocator = MTKMeshBufferAllocator(device: device)
    let mdlMesh = MDLMesh(
      coneWithExtent: [1, 1, 1],
      segments: [10, 10],
      inwardNormals: false,
      cap: true,
      geometryType: .triangles,
      allocator: allocator)
    
    //MARK: - Pipeline
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction = library?.makeFunction(name: "fragment_main")
    
    do {
      let mesh = try MTKMesh(mesh: mdlMesh, device: device)
      let pipelineDescriptor = MTLRenderPipelineDescriptor()
      pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
      pipelineDescriptor.vertexFunction = vertexFunction
      pipelineDescriptor.fragmentFunction = fragmentFunction
      pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
      
      let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      
      guard let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = mtkView.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
        fatalError("Failed to setup command buffer")
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
      
      guard let drawable = mtkView.currentDrawable else { fatalError() }
      
      commandBuffer.present(drawable)
      commandBuffer.commit()
      
      self.view = mtkView
      
    } catch {
      print(error)
    }
    
    //MARK: - Export code
    let asset = MDLAsset()
    asset.add(mdlMesh)
    let fileExtension = "obj"
    
    guard MDLAsset.canExportFileExtension(fileExtension) else {
      fatalError("Cannot export a .\(fileExtension) format")
    }
    
    do {
      guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("Failed to create url")
      }
      let urlToSave = url.appending(path: "test_primitive.\(fileExtension)")
      try asset.export(to: urlToSave)
    } catch {
      print(error)
    }
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
}

