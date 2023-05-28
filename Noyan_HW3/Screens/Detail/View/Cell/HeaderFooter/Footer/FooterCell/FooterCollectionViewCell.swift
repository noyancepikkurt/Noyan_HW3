//
//  FooterCollectionViewCell.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 28.05.2023.
//

import UIKit
import DictionaryAPI

final class FooterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var synonymLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.cornerRadius = 20
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setup(_ synonymWord: String) {
        synonymLabel.text = synonymWord
    }
}
