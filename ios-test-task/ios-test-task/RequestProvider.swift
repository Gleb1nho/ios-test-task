import Moya
import Foundation
import Network

struct RequsetProvider {
  let usersTableVC = UsersTableViewController()
  private let provider = MoyaProvider<MoyaExampleService>()
  private let monitor = NWPathMonitor()
  private let monitorQueue = DispatchQueue(label: "Monitor")
  private let requestQueue = DispatchQueue(label: "Request handling quueue", qos: .userInitiated)
  private let requestGroup = DispatchGroup()
  private var users: [User] = []
  
  private func writeResultToDB(users: [User]) {
    requestGroup.enter()
    requestQueue.async {
      users.forEach {
        var user = UserDBModel(user: $0)
        do {
          try AppDatabase.shared.saveUser(&user)
        }
        catch let dbWriteError {
          print("An error occured while trying to write to db: \(dbWriteError)")
        }
      }
      requestGroup.leave()
    }
  }
  
  private func handleRequestResult(result: Result<Response, MoyaError>) {
    requestGroup.enter()
    requestQueue.async {
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
          usersTableVC.showToast(message: "Нет подключения к сети")
        }
      }
      requestGroup.leave()
    }
  }
  
  private func getFirstUrlData() {
    requestGroup.enter()
    requestQueue.async {
      provider.request(.getFirstUrlData) { result in
        handleRequestResult(result: result)
        requestGroup.leave()
      }
    }
  }
  
  private func getSecondUrlData() {
    requestGroup.enter()

    requestQueue.async {
      provider.request(.getSecondUrlData) { result in
        handleRequestResult(result: result)
        requestGroup.leave()
      }
    }
  }
  
  private func getThirdUrlData() {
    requestGroup.enter()

    requestQueue.async {
      provider.request(.getThirdUrlData) { result in
        handleRequestResult(result: result)
        requestGroup.leave()
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
  
  func updateUsersData(completion: @escaping () -> ()) {
    monitor.start(queue: monitorQueue)
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        requestGroup.enter()
        requestQueue.async {
          flushDatabase()
          getFirstUrlData()
          getSecondUrlData()
          getThirdUrlData()
          requestGroup.leave()
        }
        requestGroup.notify(queue: requestQueue) {
          print("all data loaded")
          completion()
        }
      } else {
        DispatchQueue.main.async {
          usersTableVC.showToast(message: "Нет подключения к сети")
        }
      }
    }
  }
}
