import Moya
import Foundation

enum MoyaExampleService {
  case getFirstUrlData, getSecondUrlData, getThirdUrlData
}

extension MoyaExampleService: TargetType {
  var baseURL: URL { return URL(string: "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json")! }
  
  var path: String {
    switch self {
    case .getFirstUrlData:
      return "/generated-01.json"
    case .getSecondUrlData:
      return "/generated-02.json"
    case .getThirdUrlData:
      return "/generated-03.json"
    }
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var parameters: [String: Any]? {
    return nil
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var parameterEncoding: ParameterEncoding {
    return URLEncoding.default
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    return .requestPlain
  }
}
