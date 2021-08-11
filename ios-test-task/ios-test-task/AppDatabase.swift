import GRDB
import Foundation

extension AppDatabase {
  static let shared = makeShared()
  
  private static func makeShared() -> AppDatabase {
    do {
      let fileManager = FileManager()
      let folderURL = try fileManager
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("database", isDirectory: true)
      try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
      
      let dbURL = folderURL.appendingPathComponent("db.sqlite")
      let dbPool = try DatabasePool(path: dbURL.path)
      
      let appDatabase = try AppDatabase(dbPool)
      
      return appDatabase
    } catch {
      fatalError("Unresolved error \(error)")
    }
  }
}
