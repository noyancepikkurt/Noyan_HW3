//
//  HomeViewController.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    @IBOutlet private var searchTextField: CustomTextField!
    @IBOutlet private var recentSearchTableView: UITableView!
    @IBOutlet private var searchViewButton: UIView!
    @IBOutlet private var searchViewConst: NSLayoutConstraint!
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        searchTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        viewModel.fetchAllRecentWords()
        searchViewButtonSetUp()
        tableViewConfig()
        searchViewButtonConfig()
    }
    
    private func tableViewConfig() {
        recentSearchTableView.register(cellType: HomeTableViewCell.self)
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
    }
    
    private func searchViewButtonConfig() {
        searchTextField.returnKeyType = .search
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchViewTapped))
        searchViewButton.isUserInteractionEnabled = true
        searchViewButton.addGestureRecognizer(gestureRecognizer)
    }
    
    private func searchViewButtonSetUp() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func searchViewTapped() {
        if searchTextField.text != "" {
            guard let searchText = searchTextField.text else { return }
            viewModel.checkWordAPI(searchedWord: searchText)
        } else {
            UIAlertController.alertMessage(title: AlertMessage.ifNoSearchedWordTitle.rawValue, message: AlertMessage.ifSearchTextIsEmpty.rawValue, vc: self)
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if searchTextField.isEditing  {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.searchViewConst, keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.searchViewConst, keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0)
            let bottomConstant: CGFloat = 0
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        }else {
            viewBottomConstraint.constant = 0
        }
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedWord = viewModel.recentSearchArray[indexPath.row]
        guard let recentSearchWord = selectedWord.recentSearchWord else { return }
        let detailViewModel = DetailViewModel(selectedWord: recentSearchWord)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        searchTextField.text = ""
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: HomeViewModelProtocol {
    func fetchSuccessWord() {
        guard let searchText = searchTextField.text else { return }
        viewModel.saveAndFetchWord(searchText: searchText)
        guard let successWord = viewModel.successWord else { return }
        let detailViewModel = DetailViewModel(selectedWord: successWord)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
        searchTextField.text = ""
    }
    
    func fetchWordFromCoreData() {
        self.recentSearchTableView.reloadData()
    }
    
    func didOccurError(_ error: Error) {
        UIAlertController.alertMessage(title: AlertMessage.ifNoSearchedWordTitle.rawValue,
                                       message: AlertMessage.ifNoSearchedWordMessage.rawValue,
                                       vc: self)
        searchTextField.text = ""
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchViewTapped()
        return true
    }
}
