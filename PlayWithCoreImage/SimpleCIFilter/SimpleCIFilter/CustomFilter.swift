import Foundation
import CoreImage

final class CustomFilter: CIFilter {
  private let kernel: CIColorKernel
  
  @objc dynamic var inputImage: CIImage?
  
  override var outputImage: CIImage? {
    guard let inputImage = inputImage else { return nil }
    return kernel.apply(extent: inputImage.extent, arguments: [inputImage])
  }
  
  override init() {
    let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
    let data = try! Data(contentsOf: url)
    kernel = try! CIColorKernel(functionName: "customTransformation", fromMetalLibraryData: data)
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
