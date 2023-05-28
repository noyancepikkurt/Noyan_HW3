//
//  SplashViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            let homeViewController = HomeViewController()
            if let navigationController = self.navigationController {
                navigationController.setViewControllers([homeViewController], animated: true)
            }
        }
    }
}
