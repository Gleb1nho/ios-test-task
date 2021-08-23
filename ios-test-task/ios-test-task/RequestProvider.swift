import Moya
import Foundation
import Network

struct RequsetProvider {
  let usersTableVC = UsersTableViewController()
  private let provider = MoyaProvider<MoyaExampleService>()
  private let requestQueue = DispatchQueue(label: "Request handling queue", qos: .userInitiated)
  private let requestGroup = DispatchGroup()
  private var users: [User] = []
  
  private func writeResultToDB(users: [User], completion: @escaping () -> ()) {
    do {
      try AppDatabase.shared.saveUsers(users: users)
    }
    catch let err {
      print(err)
    }
    completion()
  }
  
  private func handleRequestResult(result: Result<Response, MoyaError>, completion: @escaping (Bool) -> ()) {
    requestQueue.async {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      
      switch result {
      case .success(let response):
        do {
          try writeResultToDB(users: decoder.decode([User].self, from: response.data)) {
            completion(true)
          }
        }
        catch let error {
          print("An error occured while dealing with response: \(error)")
          completion(false)
        }
      case .failure(let requestError):
        print("An error occured while handling request: \(requestError)")
        completion(false)
      }
    }
  }
  
  private func fetchData(request: MoyaExampleService, completion: @escaping (Bool) -> ()) {
    requestGroup.enter()
    
    requestQueue.async {
      provider.request(request) { result in
        handleRequestResult(result: result) { completed in
          requestGroup.leave()
          completion(completed)
        }
      }
    }
  }
  
  private func flushDatabase() {
    do {
      try AppDatabase.shared.deleteAllUsers()
      print("Database was successfully flushed")
    }
    catch let databaseFlushError {
      print("An error occured while flushing database: \(databaseFlushError)")
    }
  }
  
  func updateUsersData(completion: @escaping (Bool) -> ()) {
    var allRequestsDone: Bool = true
    let requests: [MoyaExampleService] = [.getFirstUrlData, .getSecondUrlData, .getThirdUrlData]
    let cache = try? AppDatabase.shared.getAllUsers()
    
    flushDatabase()
    
    requests.forEach { request in
      fetchData(request: request) { completed in
        allRequestsDone = completed && allRequestsDone
      }
    }
    
    requestGroup.notify(queue: requestQueue) {
      if allRequestsDone {
        print("all data loaded")
        completion(true)
      } else {
        print("occured an error while downloading data")
        try? AppDatabase.shared.saveCached(cachedUsers: cache ?? [])
        completion(false)
      }
    }
  }
}
