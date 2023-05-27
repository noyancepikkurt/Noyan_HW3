//
//  HomeViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var recentSearchTableView: UITableView!
    @IBOutlet private var searchViewButton: UIView!
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        searchViewButtonSetUp()
        tableViewConfig()
        viewModel.delegate = self
        searchViewButtonConfig()
        viewModel.fetchAllRecentWords()
    }
    
    private func tableViewConfig() {
        recentSearchTableView.register(cellType: HomeTableViewCell.self)
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
    }
    
    private func searchViewButtonConfig() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchViewTapped))
        searchViewButton.isUserInteractionEnabled = true
        searchViewButton.addGestureRecognizer(gestureRecognizer)
    }
    
    private func searchViewButtonSetUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func searchViewTapped() {
        viewModel.checkWordAPI(searchedWord: searchTextField.text ?? "testttt")
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               let screenHeight = UIScreen.main.bounds.height
               let bottomViewHeight = searchViewButton.frame.height
               let bottomViewY = screenHeight - keyboardSize.height - bottomViewHeight
               
               if bottomViewY > 0 {
                   searchViewButton.frame.origin.y = bottomViewY
               }
           }
       }
       
       @objc func keyboardWillHide(notification: NSNotification) {
           searchViewButton.frame.origin.y = UIScreen.main.bounds.height - searchViewButton.frame.height
       }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentSearchTableView.dequeueReusableCell(cellType: HomeTableViewCell.self, indexPath: indexPath)
        cell.setup(viewModel.recentSearchArray[indexPath.row])
        return cell
    }
}

extension HomeViewController: HomeViewModelProtocol {
    func fetchSuccessWord() {
        guard let successWord = viewModel.successWord else { return }
        let detailViewModel = DetailViewModel(selectedWord: successWord)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func fetchWordFromCoreData() {
        self.recentSearchTableView.reloadData()
    }
    
    func didOccurError(_ error: Error) {
        UIAlertController.alertMessage(title: "Error", message: "There is no word ", vc: self)
        print("data gelmedi")
    }
    
    
}
