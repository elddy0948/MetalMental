import UIKit

final class ViewController: UIViewController {
  private let imageTableView = UITableView()
  private var images = [Image]()
  
  private var dataSource: UITableViewDiffableDataSource<Section, Image>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    layout()
    
    createMockDataSources()
    
    createDataSource()
    imageTableView.reloadData()
    
  }
  
  private func createDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, Image>(
      tableView: imageTableView) { tableView, indexPath, itemIdentifier in
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: ImageCell.reuseIdentifier,
          for: indexPath) as? ImageCell else {
          return UITableViewCell()
        }
        cell.backgroundColor = .systemRed
        return cell
      }
    
    var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
    snapshot.appendSections([.main])
    snapshot.appendItems(images)
    dataSource?.apply(snapshot)
  }
  
  private func createMockDataSources() {
    guard let modelPath = Bundle.main.url(forResource: "images", withExtension: "json") else {
      return
    }
    
    do {
      let data = try Data(contentsOf: modelPath)
      let decodedData = try JSONDecoder().decode([Image].self, from: data)
      self.images = decodedData
    } catch {
      print(error)
    }
  }
}


extension ViewController {
  private func configureViews() {
    view.backgroundColor = .systemBackground
    
    imageTableView.delegate = self
    
    imageTableView.register(ImageCell.self,
                            forCellReuseIdentifier: ImageCell.reuseIdentifier)
  }
  
  private func layout() {
    view.addSubview(imageTableView)
    imageTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      imageTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      imageTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      imageTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
