//
//  DetailHeaderView.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 27.05.2023.
//

import UIKit

class DetailHeaderView: UIView {
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .black
        return label
    }()
    
    lazy var pronounceLabel: UILabel = {
        let label = UILabel()
        label.text = "h/(ascad)"
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var audioButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(.init(named: "pronaunciation"), for: .normal)
        return button
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemGray6
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(wordLabel)
        labelStackView.addArrangedSubview(pronounceLabel)
        addSubview(audioButton)
        addSubview(collectionView)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            audioButton.centerYAnchor.constraint(equalTo: self.labelStackView.centerYAnchor),
            audioButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            audioButton.heightAnchor.constraint(equalToConstant: 80),
            audioButton.widthAnchor.constraint(equalToConstant: 80),
            
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelStackView.heightAnchor.constraint(equalToConstant: 82),
            labelStackView.trailingAnchor.constraint(equalTo: self.audioButton.leadingAnchor, constant: -15),
            
            collectionView.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
