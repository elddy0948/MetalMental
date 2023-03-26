import UIKit

final class ImageCell: UITableViewCell {
  static let reuseIdentifier = String(describing: ImageCell.self)
  
  private let cellImageView = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(image: Image) {
    
  }
  
  private func configureViews() {
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
