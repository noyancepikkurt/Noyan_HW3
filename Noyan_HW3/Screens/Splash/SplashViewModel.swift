//
//  SplashViewModel.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 1.06.2023.
//

import Foundation

protocol SplashViewModelProtocol: AnyObject {
    func noInternetConnection()
}

final class SplashViewModel {
    weak var delegate: SplashViewModelProtocol?
    
    func checkInternetStatus() {
        NetworkMonitor.shared.isConnected ? nil : self.delegate?.noInternetConnection()
    }
}
