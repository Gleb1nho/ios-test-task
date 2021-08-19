import Moya
import Foundation

struct RequsetProvider {
  private let provider = MoyaProvider<MoyaExampleService>()
  let usersTableVC = UsersTableViewController()
  
  private func writeResultToDB(users: [User]) {
    users.map {
      var user = UserDBModel(user: $0)
      do {
        try AppDatabase.shared.saveUser(&user)
      }
      catch let dbWriteError {
        print("An error occured while trying to write to db: \(dbWriteError)")
      }
    }
  }
  
  private func handleRequestResult(result: Result<Response, MoyaError>) {
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
      usersTableVC.showErrorToast()
    }
  }
  
  private func getFirstUrlData() {
    provider.request(.getFirstUrlData) { result in
      handleRequestResult(result: result)
      print("First datasource data was delivered and served")
    }
  }
  
  private func getSecondUrlData() {
    provider.request(.getSecondUrlData) { result in
      handleRequestResult(result: result)
      print("Second datasource data was delivered and served")
    }
  }
  
  private func getThirdUrlData() {
    provider.request(.getThirdUrlData) { result in
      handleRequestResult(result: result)
      print("Third datasource data was delivered and served")
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
    flushDatabase()
    getFirstUrlData()
    getSecondUrlData()
    getThirdUrlData()
  }
}
