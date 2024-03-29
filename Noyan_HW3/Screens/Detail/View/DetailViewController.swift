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
    private let viewModel: DetailViewModel
    private var headerView: DetailHeaderView?
    private var headerVM: DetailHeaderViewModel?
    
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
        guard let meaningModel = viewModel.wordDetail?.meanings else { return }
        guard let phoneticsModel = viewModel.wordDetail?.phonetics else { return }
        self.headerVM = DetailHeaderViewModel(meaningModel: meaningModel, phoneticModel: phoneticsModel)
        guard let headerVM else { return }
        self.headerView = DetailHeaderView(viewModel: headerVM)
        self.hideLoading()
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(cellType: DetailTableViewCell.self, indexPath: indexPath) as DetailTableViewCell
        cell.selectionStyle = .none
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
        headerView?.delegate = self
        headerView?.wordLabel.text = viewModel.selectedWord.capitalized
        headerView?.pronounceLabel.text = viewModel.wordDetail?.phonetic
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = DetailFooterView()
        footer.delegate = self
        let sortedArray = viewModel.sortSynonymTopFiveScores()
        footer.configure(sortedArray)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
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
                UIAlertController.alertMessage(title: AlertMessage.ifNoSearchedWordTitle.rawValue,
                                               message: AlertMessage.ifNoSearchedWordMessage.rawValue,
                                               vc: self)
            }
        }
    }
}

extension DetailViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backButtonImage = UIImage(named: Icons.backButtonIcon.rawValue)
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray
    }
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
