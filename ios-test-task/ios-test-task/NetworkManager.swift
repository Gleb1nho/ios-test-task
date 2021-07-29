import Foundation
import Alamofire

class NetworkManager {
  
  typealias WebResponse = (Data?, Error?) -> Void
  
  func execute(_ url: URL, completion: @escaping WebResponse) {    
    AF.request(url).validate().responseJSON { res in
      if let error = res.error {
        completion(nil, error)
      } else if let json = res.data {
        completion(json, nil)
      }
//      else if let jsonDict = res.value as? [String:Any] {
//        completion([jsonDict], nil)
//      }
    }
  }
  
}
