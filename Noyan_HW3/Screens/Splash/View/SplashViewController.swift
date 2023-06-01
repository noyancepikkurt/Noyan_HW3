//
//  SplashViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit

final class SplashViewController: UIViewController, SplashViewModelProtocol {
    private let viewModel = SplashViewModel()
    private var connectionStatus: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.checkInternetStatus()
        
        if connectionStatus {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                let homeViewController = HomeViewController()
                if let navigationController = self.navigationController {
                    navigationController.setViewControllers([homeViewController], animated: true)
                }
            }
        } else {
            UIAlertController.alertMessage(title: AlertMessage.noInternetAlertTitle.rawValue, message: AlertMessage.noInternetAlertMessage.rawValue, vc: self)
        }
    }
    
    func noInternetConnection() {
        connectionStatus = false
    }
}
