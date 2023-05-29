//
//  HeaderCollectionViewCell.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 28.05.2023.
//

import UIKit
import DictionaryAPI

final class HeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 2 - 5
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setup(_ filterText: String) {
        filterLabel.text = filterText
    }
}
