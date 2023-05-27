//
//  TableViewCell.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    @IBOutlet  var recentSearchLabel: UILabel!
    
    func setup(_ model: RecentSearchEntity) {
        recentSearchLabel.text = model.recentSearchWord
    }
}
