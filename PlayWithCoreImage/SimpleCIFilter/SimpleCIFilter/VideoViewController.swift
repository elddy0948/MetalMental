import AVKit
import AVFoundation
import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

final class VideoViewController: UIViewController {
  private let stackView = UIStackView()
  private let filteredVideoView = UIView()
  private let originalVideoView = UIView()
  
  private var filteredVideoPlayer: AVQueuePlayer?
  private var filteredVideoLooper: AVPlayerLooper?
  private var originalVideoPlayer: AVQueuePlayer?
  private var originalVideoLooper: AVPlayerLooper?
  
  private lazy var timer: Timer = {
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
      self.filterIndex += 1
      self.filterIndex = self.filterIndex % self.filters.count
    })
  }()
  
  private var filterIndex = 0
  
  private lazy var filters: [CIFilter] = {
    var filters = [CIFilter]()
    filters.append(CustomFilter())
    filters.append(CIFilter.colorMonochrome())
    
    let falseColor = CIFilter.falseColor()
    
    falseColor.color0 = .blue
    falseColor.color1 = .yellow
    
    filters.append(falseColor)
    
    return filters
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    layout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let videoURL = Bundle.main.url(forResource: "video", withExtension: "MOV")!
    let asset = AVAsset(url: videoURL)
    
    configureFilteredView(with: asset)
    configureOriginalView(with: asset)
    
    timer.fire()
  }
  
  private func configureFilteredView(with asset: AVAsset) {
    let playerItem = AVPlayerItem(asset: asset)
    playerItem.videoComposition = buildComposition(for: asset)
    
    let player = AVQueuePlayer(playerItem: playerItem)
    self.filteredVideoPlayer = player
    self.filteredVideoLooper = AVPlayerLooper(player: player, templateItem: playerItem)
    
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspect
    filteredVideoView.layer.addSublayer(playerLayer)
    playerLayer.frame = filteredVideoView.frame
//    playerLayer.frame = view.bounds
    player.play()
  }
  
  private func configureOriginalView(with asset: AVAsset) {
    let playerItem = AVPlayerItem(asset: asset)
    let player = AVQueuePlayer(playerItem: playerItem)
    
    self.originalVideoPlayer = player
    self.originalVideoLooper = AVPlayerLooper(player: player, templateItem: playerItem)
    
    let playerLayer = AVPlayerLayer(player: player)
    playerLayer.videoGravity = .resizeAspect
    originalVideoView.layer.addSublayer(playerLayer)
    playerLayer.frame = originalVideoView.bounds
    player.play()
  }
  
  private func buildComposition(for asset: AVAsset) -> AVVideoComposition? {
    return AVVideoComposition(asset: asset) { request in
      let sourceImage = request.sourceImage.clampedToExtent()
      let filter = self.filters[self.filterIndex]
      filter.setValue(sourceImage, forKeyPath: kCIInputImageKey)
      request.finish(with: filter.outputImage!, context: nil)
    }
  }
}

extension VideoViewController {
  private func configureViews() {
    view.backgroundColor = .systemBackground
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
  }
  
  private func layout() {
    view.addSubview(stackView)
    
    stackView.addArrangedSubview(filteredVideoView)
    stackView.addArrangedSubview(originalVideoView)
    
    filteredVideoView.translatesAutoresizingMaskIntoConstraints = false
    originalVideoView.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
