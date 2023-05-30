//
//  DetailViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit
import DictionaryAPI

final class DetailViewController: UIViewController, LoadingShowable {
    @IBOutlet private var detailTableView: UITableView!
    private let header = DetailHeaderView()
    private let footer = DetailFooterView()
    private let viewModel: DetailViewModel
    
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        viewModel.fetchWordDetails()
        viewModel.fetchSynonymWord()
        configDelegates()
        detailTableViewConfig()
    }
    
    private func detailTableViewConfig() {
        detailTableView.register(cellType: DetailTableViewCell.self)
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.bounces = false
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 100
    }
    
    private func configDelegates() {
        viewModel.delegate = self
        footer.delegate = self
        navigationController?.delegate = self
    }
}

extension DetailViewController: DetailViewModelProtocol {
    func filteredMeanings() {
        detailTableView.reloadData()
    }
    
    func fetchedSynonymWords() {
        detailTableView.reloadData()
    }
    
    func didOccurError(_ error: Error) {
        self.hideLoading()
    }
    
    func fetchedWordDetail() {
        detailTableView.reloadData()
        self.hideLoading()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(cellType: DetailTableViewCell.self, indexPath: indexPath) as DetailTableViewCell
        if let filteredModel = viewModel.filteredMeanings {
            cell.setup(filteredModel, index: indexPath.row)
        } else {
            guard let meaningModel = viewModel.wordDetail?.meanings else { return UITableViewCell() }
            cell.setup(meaningModel, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        header.delegate = self
        header.wordLabel.text = viewModel.selectedWord.capitalized
        header.pronounceLabel.text = viewModel.wordDetail?.phonetic
        guard let headerCollectionViewData = viewModel.wordDetail?.meanings, let headerCollectionViewPhonetic = viewModel.wordDetail?.phonetics else { return nil}
        header.configure(headerCollectionViewData, headerCollectionViewPhonetic)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sortedArray = viewModel.synonymWords?.sorted { $0.score! > $1.score! }
        guard let sortedArray else { return nil }
        let topFiveSynonyms = Array(sortedArray.prefix(5))
        footer.configure(topFiveSynonyms)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 6
    }
}

extension DetailViewController: HeaderViewDelegate, DetailFooterProtocol {
    func didSelectCollectionCell(partOfSpeech: String) {
        viewModel.didSelectCollectionCell(partOfSpeech: partOfSpeech)
    }
    
    func didSelectSynonymWord(_ synonymWord: String) {
        let synonymWordByRemovingWhitespaces = synonymWord.replacingOccurrences(of: " ", with: "")
        let viewModel = DetailViewModel(selectedWord: synonymWordByRemovingWhitespaces)
        viewModel.fetchWordDetails { value in
            if value {
                let detailViewController = DetailViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(detailViewController, animated: true)
            } else {
                UIAlertController.alertMessage(title: "sorry", message: "no message", vc: self)
            }
        }
    }
}

extension DetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backButtonImage = UIImage(named: "left-arrow")
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray
    }

    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
