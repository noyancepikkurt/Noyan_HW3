//
//  HomeViewModel.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
    func fetchedWord()
    func didOccurError(_ error: Error)
}

final class HomeViewModel{
    weak var delegate: HomeViewModelProtocol?
    
    func set(searchedWord: String) {
        NetworkService.shared.fetchWord(pathUrl: "https://api.dictionaryapi.dev/api/v2/entries/en/\(searchedWord)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.delegate?.fetchedWord()
                print(success)
            case .failure(let error):
                self.delegate?.didOccurError(error)
                break
            }
        }
    }
}
