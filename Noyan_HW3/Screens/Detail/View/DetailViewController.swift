//
//  DetailViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit
import DictionaryAPI

final class DetailViewController: UIViewController {
    @IBOutlet private var detailTableView: UITableView!
    private let header = DetailHeaderView()
    private let viewModel: DetailViewModel
    private var meaningModel = [Meaning]()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchWordDetails()
        viewModel.delegate = self
        detailTableViewConfig()
    }
    
    private func detailTableViewConfig() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.bounces = false
        detailTableView.register(cellType: DetailTableViewCell.self)
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 100
    }
}

extension DetailViewController: DetailViewModelProtocol {
    func fetchedWordDetail() {
        meaningModel = (viewModel.wordDetail?.meanings)!
        detailTableView.reloadData()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var meaningCount = 0
        meaningModel.forEach { meaning in
            guard let definitions = meaning.definitions else { return }
            meaningCount += definitions.count
        }
        return meaningCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(cellType: DetailTableViewCell.self, indexPath: indexPath) as DetailTableViewCell
        cell.setup(meaningModel, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        header.wordLabel.text = viewModel.selectedWord.capitalized
        header.pronounceLabel.text = viewModel.wordDetail?.phonetic
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
}
