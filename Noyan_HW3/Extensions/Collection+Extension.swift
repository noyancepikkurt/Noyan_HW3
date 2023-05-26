//
//  Collection+Extension.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import Foundation

extension Collection {
    func nilValuesRemoved<Wrapped>() -> [Wrapped] where Element == Wrapped? {
        self.compactMap { $0 }
    }
}
