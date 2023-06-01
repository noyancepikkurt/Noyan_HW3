//
//  LoadingShowable.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 29.05.2023.
//

import UIKit

protocol LoadingShowable where Self: DetailViewController {
    func showLoading()
    func hideLoading()
}

extension LoadingShowable {
    func showLoading() {
        LoadingView.shared.startLoading()
    }
    
    func hideLoading() {
        LoadingView.shared.hideLoading()
    }
}
