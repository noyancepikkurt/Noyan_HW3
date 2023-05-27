//
//  DetailViewModel.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import Foundation
import DictionaryAPI

protocol DetailViewModelProtocol where Self: DetailViewController {
    func fetchedWordDetail()
}

final class DetailViewModel {
    var selectedWord: String
    var wordDetail: DictionaryModel?
    weak var delegate: DetailViewModelProtocol?
    
    init(selectedWord: String) {
        self.selectedWord = selectedWord
    }
    
    func fetchWordDetails() {
        NetworkService.shared.fetchWord(pathUrl: "https://api.dictionaryapi.dev/api/v2/entries/en/\(selectedWord)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let wordModel):
                self.wordDetail = wordModel
                self.delegate?.fetchedWordDetail()
            case .failure(_):
                break
            }
        }
    }
}
