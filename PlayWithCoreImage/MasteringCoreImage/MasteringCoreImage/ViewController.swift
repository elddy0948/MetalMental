import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "sample")
    return imageView
  }()
  
  private let url = Bundle.main.url(forResource: "cat", withExtension: "JPG")!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    layout()
//    processImage()
    builtinFilterImage()
  }
}

extension ViewController {
  private func configureViews() {
    view.backgroundColor = .systemBackground
    title = "Master Core Image!"
  }
  
  private func layout() {
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      imageView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      imageView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func processImage() {
    guard let image = CIImage(contentsOf: url, options: [
      CIImageOption.applyOrientationProperty: true,
    ]) else { return }
    
    guard let filter = CIFilter(name: "CIComicEffect", parameters: ["inputImage" : image]),
          let outputImage = filter.outputImage?.applyingFilter("CIColorInvert").applyingFilter("CIVignette", parameters: [
            "inputIntensity" : 1.0,
            "inputRadius" : 2.0
          ]) else {
      return
    }
    
    guard let cgImage = CIContext(options: nil).createCGImage(outputImage, from: outputImage.extent) else { return }
    
    imageView.image = UIImage(cgImage: cgImage)
  }
  
  private func builtinFilterImage() {
    guard let image = CIImage(contentsOf: url, options: [CIImageOption.applyOrientationProperty : true]) else { return }
    
    let filter = CIFilter.sepiaTone()
    filter.inputImage = image
    filter.intensity = 1.0
    
    let instantFilter = CIFilter.photoEffectInstant()
    instantFilter.inputImage = filter.outputImage
    
    guard let outputImage = instantFilter.outputImage,
          let cgImage = CIContext(options: nil).createCGImage(outputImage, from: outputImage.extent) else { return }
    
    let uiImage = UIImage(cgImage: cgImage)
    imageView.image = uiImage
    saveImageToPhotos(image: uiImage)
  }
  
  private func saveImageToPhotos(image: UIImage) {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
  }
}

