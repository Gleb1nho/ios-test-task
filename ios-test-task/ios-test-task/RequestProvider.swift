import Moya
import Foundation
import Network

struct RequsetProvider {
  let usersTableVC = UsersTableViewController()
  private let provider = MoyaProvider<MoyaExampleService>()
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "Monitor")
  private var users: [User] = []
  
  private func writeResultToDB(users: [User]) {
    DispatchQueue.global(qos: .background).async {
      users.forEach {
        var user = UserDBModel(user: $0)
        do {
          try AppDatabase.shared.saveUser(&user)
        }
        catch let dbWriteError {
          print("An error occured while trying to write to db: \(dbWriteError)")
        }
      }
    }
  }
  
  private func handleRequestResult(result: Result<Response, MoyaError>) {
    DispatchQueue.global(qos: .background).async {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601

      switch result {
      case .success(let response):
        do {
          try writeResultToDB(users: decoder.decode([User].self, from: response.data))
        }
        catch let error {
          print("An error occured while dealing with response: \(error)")
        }
      case .failure(let requestError):
        print("An error occured while handling request: \(requestError)")
        DispatchQueue.main.async {
          usersTableVC.showErrorToast()
        }
      }
    }
  }
  
  private func getFirstUrlData() {
    DispatchQueue.global(qos: .background).async {
      provider.request(.getFirstUrlData) { result in
        handleRequestResult(result: result)
      }
    }
  }
  
  private func getSecondUrlData() {
    DispatchQueue.global(qos: .background).async {
      provider.request(.getSecondUrlData) { result in
        handleRequestResult(result: result)
      }
    }
  }
  
  private func getThirdUrlData() {
    DispatchQueue.global(qos: .background).async {
      provider.request(.getThirdUrlData) { result in
        handleRequestResult(result: result)
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
  
  func updateUsersData() {
    monitor.start(queue: queue)
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        flushDatabase()
        getFirstUrlData()
        getSecondUrlData()
        getThirdUrlData()
      } else {
        DispatchQueue.main.async {
          usersTableVC.showErrorToast()
        }
      }
    }
  }
}
