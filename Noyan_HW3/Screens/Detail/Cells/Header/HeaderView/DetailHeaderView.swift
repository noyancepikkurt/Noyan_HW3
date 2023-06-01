//
//  DetailHeaderView.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 27.05.2023.
//

import UIKit
import DictionaryAPI
import AVFoundation
import Alamofire

protocol HeaderViewDelegate: AnyObject {
    func didSelectCollectionCell(partOfSpeech: String)
}

final class DetailHeaderView: UIView {
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
        button.setImage(.init(named: Icons.voiceButtonIcon.rawValue), for: .normal)
        button.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth / 4
        let itemHeight = itemWidth * 0.4
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .systemGray6
        return collection
    }()
    
    private var viewModel: DetailHeaderViewModel
    weak var delegate: HeaderViewDelegate?
    
    private var selectedCellIndexPath: IndexPath? {
        didSet {
            collectionView.reloadData()
        }
    }

    init(viewModel: DetailHeaderViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func audioButtonTapped() {
        guard let audio = viewModel.audioURL else { return }
        viewModel.requestForAudio(audio)
    }
    
    private func delegatesConfig() {
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
    }
    
    private func setupView() {
        delegatesConfig()
        viewModel.findValidAudioURL()
        collectionView.register(cellType: HeaderCollectionViewCell.self)
        addSubview(labelStackView)
        addSubview(audioButton)
        addSubview(collectionView)
        labelStackView.addArrangedSubview(wordLabel)
        labelStackView.addArrangedSubview(pronounceLabel)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            audioButton.centerYAnchor.constraint(equalTo: self.labelStackView.centerYAnchor),
            audioButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            audioButton.heightAnchor.constraint(equalToConstant: 100),
            audioButton.widthAnchor.constraint(equalToConstant: 100),
            
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            labelStackView.heightAnchor.constraint(equalToConstant: 70),
            labelStackView.trailingAnchor.constraint(equalTo: self.audioButton.leadingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2)
        ])
    }
}

extension DetailHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: HeaderCollectionViewCell.self, indexPath: indexPath) as HeaderCollectionViewCell
        guard let partOfSpeech = viewModel.meaningModel[indexPath.row].partOfSpeech?.capitalized else  { return UICollectionViewCell() }
        if indexPath == selectedCellIndexPath {
            cell.contentView.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
        cell.setup(partOfSpeech)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let partOfSpeech = viewModel.meaningModel[indexPath.row].partOfSpeech else { return }
        self.delegate?.didSelectCollectionCell(partOfSpeech: partOfSpeech)
        if indexPath == self.selectedCellIndexPath {
            selectedCellIndexPath = nil
        } else {
            selectedCellIndexPath = indexPath
        }
    }
}

extension DetailHeaderView: HeaderViewModelDelegate {
    func didNotFoundAudioURL() {
        audioButton.isHidden = true
    }
}
