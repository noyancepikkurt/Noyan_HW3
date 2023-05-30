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
    private var synonymModel = [SynonymModel]()
    private var headerCollectionViewData = [Meaning]()
    private var headerCollectionViewPhonetic = [Phonetic]()
    private var partOfSpeechFilter: String? = nil
    private var filterModel:  [Meaning]? {
        didSet {
            detailTableView.reloadData()
        }
    }
    private var meaningModel: [Meaning]? {
        didSet {
            detailTableView.reloadData()
        }
    }
    
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
    func fetchedSynonymWords() {
        guard let synonymModel = viewModel.synonymWords else { return }
        self.synonymModel = synonymModel
        detailTableView.reloadData()
    }
    
    func fetchedWordDetail() {
        guard let fetchWord = viewModel.wordDetail else { return }
        guard let meaning = fetchWord.meanings else { return }
        guard let phonetics = fetchWord.phonetics else { return }
        meaningModel = meaning
        filterModel = meaning
        headerCollectionViewData = meaning
        headerCollectionViewPhonetic = phonetics
        detailTableView.reloadData()
        self.hideLoading()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var meaningCount = 0
        guard let meaningModel = self.meaningModel else { return 0 }
        meaningModel.forEach { meaning in
            guard let definitions = meaning.definitions else { return }
            meaningCount += definitions.count
        }
        return meaningCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(cellType: DetailTableViewCell.self, indexPath: indexPath) as DetailTableViewCell
        guard let meaningModel = self.meaningModel else { return UITableViewCell() }
        cell.setup(meaningModel, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        header.delegate = self
        header.wordLabel.text = viewModel.selectedWord.capitalized
        header.pronounceLabel.text = viewModel.wordDetail?.phonetic
        header.configure(headerCollectionViewData, headerCollectionViewPhonetic)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sortedArray = synonymModel.sorted { $0.score! > $1.score! }
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
    func didSelectSynonymWord(_ synonymWord: String) {
        let synonymWordByRemovingWhitespaces = synonymWord.replacingOccurrences(of: " ", with: "")
        print(synonymWordByRemovingWhitespaces)
        let viewModel = DetailViewModel(selectedWord: synonymWordByRemovingWhitespaces)
        let detailViewController = DetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didSelectCollectionCell(partOfSpeech: String) {
        guard let meaningModel = self.filterModel else { return }
        if self.partOfSpeechFilter == partOfSpeech {
            self.meaningModel = meaningModel
            self.partOfSpeechFilter = nil
        } else {
            let filteredPartOfSpeech = meaningModel.filter { meaning in
                meaning.partOfSpeech == partOfSpeech
            }
            self.meaningModel = filteredPartOfSpeech
            self.partOfSpeechFilter = partOfSpeech
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
