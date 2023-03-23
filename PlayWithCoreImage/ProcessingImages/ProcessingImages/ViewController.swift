import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import MetalKit

enum ImageError: Error {
  case invalidURL
  case failedToCreateCIImage
}

final class ViewController: UIViewController {
  
//  private let imageView = UIImageView()
  private let imageView = MetalView(frame: .zero, device: nil)
  private var image: CIImage? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    layout()
    
    imageView.delegate = self
    
    do {
      let image = try fetchImage()
      self.image = image
    } catch {
      print(error)
    }
  }
  
  private func fetchImage() throws -> CIImage {
    guard let url = Bundle.main.url(forResource: "pen", withExtension: "jpeg") else {
      throw ImageError.invalidURL
    }
    
    guard let ciImage = CIImage(contentsOf: url) else {
      throw ImageError.failedToCreateCIImage
    }
    
    return ciImage
  }
  
  private func renderingWithAutomaticContext(image: CIImage) {
    let context = CIContext()
    
    let filter = CIFilter.sepiaTone()
    filter.inputImage = image
    filter.intensity = 5.0
    
    guard let output = filter.outputImage else { return }
    
    guard let cgImage = context.createCGImage(output, from: output.extent) else { return }

//    imageView.image = UIImage(cgImage: cgImage)
  }
}

extension ViewController {
  private func setupViews() {
    view.backgroundColor = .systemBackground
  }
  
  private func layout() {
    view.addSubview(imageView)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}


extension ViewController: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
  }
  
  func draw(in view: MTKView) {
    guard let metalView = view as? MetalView else { return }
    guard let image = image else { return }
    let size = self.view.bounds.size
    let commandBuffer = metalView.commandQueue.makeCommandBuffer()!
    
    let renderDestination = CIRenderDestination(
      width: Int(size.width),
      height: Int(size.height),
      pixelFormat: .rgba16Float,
      commandBuffer: commandBuffer) { () -> MTLTexture in
        return view.currentDrawable!.texture
      }
    
    do {
      try metalView.context.startTask(toRender: image, from: image.extent, to: renderDestination, at: CGPoint(x: 50, y: 150))
      commandBuffer.present(metalView.currentDrawable!)
      commandBuffer.commit()
    } catch {
      print(error)
    }
  }
}
