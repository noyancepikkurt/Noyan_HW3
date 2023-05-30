//
//  NilorEmpty.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import Foundation

extension Optional where Wrapped == String {
    func isNilOrEmpty() -> Bool {
        if let self = self {
            return self.isEmpty
        }
        return true
    }
}
