import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    let vc = RequsetProvider().usersTableVC
    let navVC = UINavigationController(rootViewController: vc)
    window.rootViewController = navVC
        
    if
      let countOfUsers = try? AppDatabase.shared.getCountOfUsers(),
      countOfUsers == 0 {
      
      vc.firstLoadingIndicator.startAnimating()
      vc.handleRefreshControl()
    }
    
    self.window = window
    window.makeKeyAndVisible()
  }
}

