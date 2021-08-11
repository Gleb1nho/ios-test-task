import Foundation
import GRDB
  
struct User: Codable, Identifiable, Hashable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }
  
  let id: String
  let name: String
  let phone: String
  let height: Float
  let biography: String

  enum Temperament: String, Codable {
    case sanguine
    case choleric
    case phlegmatic
    case melancholic
  }
  let temperament: Temperament

  struct EducationPeriod: Codable, Hashable {
    let start: Date
    let end: Date
  }
  let educationPeriod: EducationPeriod
}

struct UserDBModel: Codable, Identifiable, Hashable {
  var id: String
  var name: String
  var phone: String
  var formattedPhone: String
  var height: Float
  var biography: String
  var temperament: String
  var educationPeriodStart: Date
  var educationPeriodEnd: Date
  
  init(user: User) {
    self.id = user.id
    self.name = user.name
    self.phone = user.phone
    self.formattedPhone = String(self.phone.map { $0.isNumber ? $0 : nil }.compactMap { $0 })
    self.height = user.height
    self.biography = user.biography
    self.temperament = user.temperament.rawValue
    self.educationPeriodStart = user.educationPeriod.start
    self.educationPeriodEnd = user.educationPeriod.end
  }
}

extension UserDBModel: FetchableRecord, MutablePersistableRecord {
  fileprivate enum Columns {
    static let id = Column(CodingKeys.id)
    static let name = Column(CodingKeys.name)
    static let phone = Column(CodingKeys.phone)
    static let formattedPhone = Column(CodingKeys.formattedPhone)
    static let height = Column(CodingKeys.height)
    static let biography = Column(CodingKeys.biography)
    static let temperament = Column(CodingKeys.temperament)
    static let educationPeriodStart = Column(CodingKeys.educationPeriodStart)
    static let educationPeriodEnd = Column(CodingKeys.educationPeriodEnd)
  }
}

extension DerivableRequest where RowDecoder == UserDBModel {
  func orderByName() -> Self {
    let name = UserDBModel.Columns.name
    return order(name.collating(.localizedCaseInsensitiveCompare))
  }
}
