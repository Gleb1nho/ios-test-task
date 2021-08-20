//
//  SceneDelegate.swift
//  ios-test-task
//
//  Created by Gleb Pestretsov on 28.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    let vc = RequsetProvider().usersTableVC
    let navVC = UINavigationController(rootViewController: vc)
    window.rootViewController = navVC
//    RequsetProvider().updateUsersData()
    
    self.window = window
    window.makeKeyAndVisible()
  }

}

