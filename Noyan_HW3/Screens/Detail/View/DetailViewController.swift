//
//  DetailViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private var detailTableView: UITableView!
    private let header = DetailHeaderView()
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
        viewModel.fetchWordDetails()
        viewModel.delegate = self
        detailTableViewConfig()
    }
    
    private func detailTableViewConfig() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.bounces = false
    }
}

extension DetailViewController: DetailViewModelProtocol {
    func fetchedWordDetail() {
//        print(viewModel.wordDetail)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "5"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        header
        return header
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}
