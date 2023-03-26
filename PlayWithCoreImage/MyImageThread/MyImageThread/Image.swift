import Foundation

enum Section: CaseIterable {
  case main
}

struct Image: Hashable, Equatable, Decodable {
  var id = UUID()
  let imageName: String
  
  enum CodingKeys: CodingKey {
    case imageName
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func ==(lhs: Image, rhs: Image) -> Bool {
    return lhs.id == rhs.id
  }
}
