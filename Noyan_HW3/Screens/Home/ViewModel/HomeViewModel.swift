//
//  HomeViewModel.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import Foundation
import DictionaryAPI

protocol HomeViewModelProtocol where Self: HomeViewController {
    func fetchSuccessWord()
    func didOccurError(_ error: Error)
    func fetchWordFromCoreData()
}

final class HomeViewModel {
    weak var delegate: HomeViewModelProtocol?
    var recentSearchArray = [RecentSearchEntity]()
    var successWord: String?
    
    func checkWordAPI(searchedWord: String) {
        NetworkService.shared.fetchWord(pathUrl: "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchedWord)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.successWord = success.word
                self.delegate?.fetchSuccessWord()
            case .failure(let error):
                self.delegate?.didOccurError(error)
                break
            }
        }
    }
    
    func fetchAllRecentWords() {
        DataPersistenceManager.shared.fetchWord { [weak self] result in
            switch result {
            case .success(let words):
                self?.recentSearchArray = words
                self?.delegate?.fetchWordFromCoreData()
            case .failure(let error):
                print("Error fetching recent search data: \(error)")
            }
        }
    }
    
    func saveAndFetchWord(searchText: String) {
        DataPersistenceManager.shared.saveWord(model: searchText) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchAllRecentWords()
            case .failure(_):
                break
            }
        }
    }
}
