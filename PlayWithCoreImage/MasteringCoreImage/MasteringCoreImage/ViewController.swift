import UIKit

class ViewController: UIViewController {
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: "sample")
    return imageView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    layout()
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
}

