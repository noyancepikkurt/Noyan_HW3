//
//  DetailFooterView.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 28.05.2023.
//

import UIKit
import DictionaryAPI

protocol DetailFooterProtocol {
    func didSelectSynonymWord(_ synonymWord: String)
}

final class DetailFooterView: UIView {
    lazy var synonymLabel: UILabel = {
        let label = UILabel()
        label.text = "Synonym"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    var delegate: DetailFooterProtocol?
    
    private var synonymWords: [SynonymModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ model: [SynonymModel]) {
        synonymWords = model
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: FooterCollectionViewCell.self)
        let lineView = UIView()
        addSubview(lineView)
        addSubview(synonymLabel)
        addSubview(collectionView)
        synonymLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        lineView.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: self.topAnchor),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            synonymLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8),
            synonymLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            synonymLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16),
            synonymLabel.heightAnchor.constraint(equalToConstant: 22),
            
            collectionView.topAnchor.constraint(equalTo: self.synonymLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
        ])
    }
}

extension DetailFooterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: FooterCollectionViewCell.self, indexPath: indexPath)
        guard let synonymWord = synonymWords?[indexPath.row].word else { return UICollectionViewCell()}
        cell.setup(synonymWord)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let synonymCount = synonymWords?.count else  { return 0 }
        self.synonymLabel.isHidden = synonymCount == 0 ? true : false
        return synonymCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectSynonymWord(synonymWords?[indexPath.item].word ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = synonymWords?[indexPath.row].word
        label.sizeToFit()
        let desiredWidth = label.frame.width + 25
        return CGSize(width: desiredWidth, height: 40)
    }
}
