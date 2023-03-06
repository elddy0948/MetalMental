#  Not Donut it's Car!

## Export Asset

```swift
private func exportAsset(_ mesh: MDLMesh, fileExtension: String, fileName: String) throws {
  let asset = MDLAsset()
  asset.add(mesh)
  
  guard MDLAsset.canExportFileExtension(fileExtension) else {
    throw MetalError.invalidFileExtension
  }
  
  do {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      throw MetalError.failedToGetDocumentDirectoryURL
    }
    let absoluteURL = url.appending(path: "\(fileName).\(fileExtension)")
    try asset.export(to: absoluteURL)
  } catch {
    throw error
  }
}
```
