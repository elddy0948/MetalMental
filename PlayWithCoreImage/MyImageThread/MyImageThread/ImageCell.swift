import UIKit

final class ImageCell: UITableViewCell {
  static let reuseIdentifier = String(describing: ImageCell.self)
  
  private let cellImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(_ image: CGImage?) {
    guard let image = image else { return }
    let uiImage = UIImage(cgImage: image)
    self.cellImageView.image = uiImage
  }
  
  private func configureViews() {
    selectionStyle = .none
    cellImageView.contentMode = .scaleAspectFit
  }
  
  private func layout() {
    contentView.addSubview(cellImageView)
    
    cellImageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
}
