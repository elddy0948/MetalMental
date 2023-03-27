#  MyImageThread

## Downsample Image

```swift
private func downsample(image: Image, to pointSize: CGSize, scale: CGFloat) -> CGImage? {
  guard let url = Bundle.main.url(forResource: image.imageName, withExtension: "jpeg") else { return nil }
  let options = [kCGImageSourceShouldCache: false] as CFDictionary
  guard let cgImage = CGImageSourceCreateWithURL(url as CFURL, options) else { return nil }
  let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale

  let downsampleOptions = [
    kCGImageSourceCreateThumbnailFromImageAlways: true,
    kCGImageSourceShouldCacheImmediately: true,
    kCGImageSourceCreateThumbnailWithTransform: true,
    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
  ] as CFDictionary

  guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(cgImage, 0, downsampleOptions) else { return nil }
  return downsampledImage
}
```
