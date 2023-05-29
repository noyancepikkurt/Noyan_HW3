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
    private var filteredArray =  [Meaning]()
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
        viewModel.delegate = self
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

extension DetailViewController: HeaderViewDelegate {
    func didSelectCollectionCell(partOfSpeech: String) {
        guard let meaningModel = self.meaningModel else { return }
        if filteredArray.isEmpty == true {
            let filteredPartOfSpeech =  meaningModel.filter { meaning in
                meaning.partOfSpeech == partOfSpeech
            }
            filteredArray.append(filteredPartOfSpeech[0])
            self.meaningModel = filteredArray
        } else {
            self.meaningModel = meaningModel
            filteredArray.removeAll()
        }
        
        print("TEST\(meaningModel)")
    }
}
