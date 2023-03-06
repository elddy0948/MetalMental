#  Donut Practice

## Export Asset

```swift
let asset = MDLAsset()
asset.add(mdlMesh)

// export .obj format
let fileExtension = "obj"
guard MDLAsset.canExportFileExtension(fileExtension) else {
  fatalError("Cannot export a .\(fileExtension) format")
}

do {
  // Save at document directory
  guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Failed to create url")
  }
  let urlToSave = url.appending(path: "test_primitive.\(fileExtension)")
  try asset.export(to: urlToSave)
} catch {
  // Handle error
}
```
