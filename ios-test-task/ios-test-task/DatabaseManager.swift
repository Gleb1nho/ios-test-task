import GRDB
import Foundation

final class AppDatabase {
  private let dbWriter: DatabaseWriter
  
  private var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    
    #if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
    #endif
    
    migrator.registerMigration("createUser") { db in
      try db.create(table: "userDBModel") { t in
        t.column("id", .text).primaryKey().notNull()
        t.column("name", .text).notNull()
        t.column("phone", .text).notNull()
        t.column("formattedPhone", .text).notNull()
        t.column("height", .double).notNull()
        t.column("biography", .text).notNull()
        t.column("temperament", .text).notNull()
        t.column("educationPeriodStart", .datetime).notNull()
        t.column("educationPeriodEnd", .datetime).notNull()
      }
      try db.create(virtualTable: "nameAndPhone", using: FTS3()) { t in
        t.column("name")
        t.column("phone")
      }
    }
    return migrator
  }
  
  init(_ dbWriter: DatabaseWriter) throws {
    self.dbWriter = dbWriter
    try migrator.migrate(dbWriter)
  }
}

extension AppDatabase {
  func saveUser(_ user: inout UserDBModel) throws {
    try dbWriter.write { db in
      try user.save(db)
    }
  }
  
  func deleteAllUsers() throws {
    try dbWriter.write { db in
      _ = try UserDBModel.deleteAll(db)
    }
  }
  
  func getAllUsers() throws -> [UserDBModel]? {
    try dbWriter.read { db in
      let sortedUsers: [UserDBModel] = try UserDBModel.all()
        .orderByName()
        .fetchAll(db)
      return sortedUsers
    }
  }
  
  func getUsersByQuery(query: String) throws -> [UserDBModel] {
    try dbWriter.read { db -> [UserDBModel] in
      do {
        let sqlForFiltering = "select * from userDBModel where name like '%\(query)%' or formattedPhone like '%\(query)%';"
        let filteredUsers = try UserDBModel.fetchAll(db, sql: sqlForFiltering)
        return filteredUsers
      }
      catch let err {
        print(err)
        return []
      }
    }
  }
}
