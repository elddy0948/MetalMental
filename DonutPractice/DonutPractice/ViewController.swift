import Cocoa
import MetalKit

class ViewController: NSViewController {
  
  private let device: MTLDevice?
  private let commandQueue: MTLCommandQueue?
  
  init() {
    device = MTLCreateSystemDefaultDevice()
    commandQueue = device?.makeCommandQueue()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let device = device,
          let commandQueue = commandQueue else {
      fatalError()
    }
    
    //MARK: - MTKView
    let frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    let mtkView = MTKView(frame: frame, device: device)
    mtkView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
    
    let allocator = MTKMeshBufferAllocator(device: device)
    guard let asset = fetchAsset(allocator, fileName: "Car", fileExtension: "obj") else { fatalError("Failed to fetch asset") }
    let mdlMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
    
    do {
      let mesh = try MTKMesh(mesh: mdlMesh, device: device)
      let pipelineDescriptor = try createPipelineDescriptor(mesh)
      let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      
      guard let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderPassDescriptor = mtkView.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
        fatalError("Failed to setup command buffer")
      }
      renderEncoder.setRenderPipelineState(pipelineState)
      renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
      renderEncoder.setTriangleFillMode(.lines)
      
      for submesh in mesh.submeshes {
        renderEncoder.drawIndexedPrimitives(
          type: .triangle,
          indexCount: submesh.indexCount,
          indexType: submesh.indexType,
          indexBuffer: submesh.indexBuffer.buffer,
          indexBufferOffset: submesh.indexBuffer.offset
        )
      }
      
      renderEncoder.endEncoding()
      
      guard let drawable = mtkView.currentDrawable else { fatalError() }
      
      commandBuffer.present(drawable)
      commandBuffer.commit()
      
      self.view = mtkView
    } catch {
      print(error)
    }
  }
  
  override func loadView() {
    self.view = NSView(frame: NSRect(x: 0, y: 0, width: 600, height: 600))
  }
  
  private func fetchAsset(_ allocator: MTKMeshBufferAllocator,fileName: String, fileExtension: String) -> MDLAsset? {
    guard let assetURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else { return nil }
    let vertexDescriptor = MTLVertexDescriptor()
    vertexDescriptor.attributes[0].format = .float3
    vertexDescriptor.attributes[0].offset = 0
    vertexDescriptor.attributes[0].bufferIndex = 0
    vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
    
    let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
    (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
    
    return MDLAsset(
      url: assetURL,
      vertexDescriptor: meshDescriptor,
      bufferAllocator: allocator)
  }
  
  private func createPipelineDescriptor(_ mesh: MTKMesh) throws -> MTLRenderPipelineDescriptor {
    guard let device = device else { throw MetalError.noDevice }
    let library = device.makeDefaultLibrary()
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction = library?.makeFunction(name: "fragment_main")
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
    
    return pipelineDescriptor
  }
  
  private func exportAsset(_ mesh: MDLMesh, fileExtension: String, fileName: String) throws {
    let asset = MDLAsset()
    asset.add(mesh)
    
    guard MDLAsset.canExportFileExtension(fileExtension) else {
      throw MetalError.invalidFileExtension
    }
    
    do {
      guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        throw MetalError.failedToGetDocumentDirectoryURL
      }
      let absoluteURL = url.appending(path: "\(fileName).\(fileExtension)")
      try asset.export(to: absoluteURL)
    } catch {
      throw error
    }
  }
}

enum MetalError: Error {
  case noDevice
  case invalidFileExtension
  case failedToGetDocumentDirectoryURL
}
