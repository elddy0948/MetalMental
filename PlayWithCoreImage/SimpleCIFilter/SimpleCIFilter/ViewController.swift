import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class ViewController: UIViewController {
  private let stackView = UIStackView()
  private let originalImageView = UIImageView()
  private let filteredImageView = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    layout()
    
    setImages()
    
  }
  
  private func setImages() {
    guard let imageURL = Bundle.main.url(forResource: "cat", withExtension: ".JPG"),
          let originalImage = CIImage(contentsOf: imageURL) else { return }
    
    originalImageView.image = UIImage(ciImage: originalImage)
    
    let filter = CIFilter.falseColor()
    filter.inputImage = originalImage
    filter.color0 = .blue
    filter.color1 = .red
    
//    let result = filter.outputImage 이 방법은 별로 좋지 않음
    let filter2 = CIFilter.crystallize()
    filter2.inputImage = filter.outputImage // input image에 넣는게 좋다
    filter2.center = .init(x: 0.5, y: 0.5)
    filter2.radius = 50.0
    
    let customFilter = CustomFilter()
    customFilter.inputImage = originalImage
    
    guard let result = customFilter.outputImage else { return }
    filteredImageView.image = UIImage(ciImage: result)
  }
}

extension ViewController {
  private func setupViews() {
    view.backgroundColor = .systemBackground
    
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
  }
  
  private func layout() {
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(originalImageView)
    stackView.addArrangedSubview(filteredImageView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
