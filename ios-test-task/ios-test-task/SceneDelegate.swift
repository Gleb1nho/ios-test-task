import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    let vc = RequsetProvider().usersTableVC
    let navVC = UINavigationController(rootViewController: vc)
    window.rootViewController = navVC
    
//    try? AppDatabase.shared.deleteAllUsers()
//    
//    if let dbUsersCount = try? AppDatabase.shared.getCountOfUsers(), dbUsersCount == 0 {
//      vc.handleRefreshControl()
//    }
    
    self.window = window
    window.makeKeyAndVisible()
  }
}

