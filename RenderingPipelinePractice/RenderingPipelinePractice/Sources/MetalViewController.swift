import UIKit
import MetalKit

final class MetalViewController: UIViewController {
  private var metalView = MTKView()
  private var renderer: Renderer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    layout()
    configureRenderer()
  }
  
  func updateMetalView() {
    
  }
  
  private func configureRenderer() {
    renderer = Renderer(metalView: self.metalView)
  }
}


extension MetalViewController {
  private func configureViews() {
    view.backgroundColor = .systemBackground
  }
  
  private func layout() {
    view.addSubview(metalView)
    
    metalView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      metalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      metalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      metalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      metalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
