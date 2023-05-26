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
        recentSearchTableView.register(cellType: HomeTableViewCell.self)
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        viewModel.delegate = self
        searchViewButtonConfig()
    }
    
    private func searchViewButtonConfig() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(search))
        searchViewButton.isUserInteractionEnabled = true
        searchViewButton.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func search() {
        viewModel.set(searchedWord: searchTextField.text ?? "testttt")
        navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
    private func searchViewButtonSetUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recentSearchTableView.dequeueReusableCell(cellType: HomeTableViewCell.self, indexPath: indexPath)
        return cell
    }
    
}

extension HomeViewController: HomeViewModelProtocol {
    func fetchedWord() {
        //tableview reload
        // coredata'ya eklenecek 
        print("data geldi")
    }
    
    
    func didOccurError(_ error: Error) {
        // böyle bir kelime yok
        print("data gelmedi")
    }
    
    
}
