//
//  NavigationHelper.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit
final class NavigationHelper {
  static func topViewController() -> UIViewController? {
    guard let navC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController else { return nil }
    return navC.visibleViewController
  }
  static func initializeApp() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let navController = UINavigationController(rootViewController: HomeViewController())
      appDelegate.window?.rootViewController = navController
      appDelegate.window?.makeKeyAndVisible()
    }
  }
}
