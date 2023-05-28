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
    func fetchedSynonymWords()
}

final class DetailViewModel {
    var selectedWord: String
    var wordDetail: DictionaryModel?
    var synonymWords: [SynonymModel]?
    weak var delegate: DetailViewModelProtocol?
    
    init(selectedWord: String) {
        self.selectedWord = selectedWord
    }
    
    func fetchWordDetails() {
        NetworkService.shared.fetchWord(pathUrl: "\(NetworkURL.dictionaryURL.rawValue)\(selectedWord)") { [weak self] result in
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
    
    func fetchSynonymWord() {
        NetworkService.shared.fetchSynonymWords(pathUrl: "\(NetworkURL.synonymURL.rawValue)\(selectedWord)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let synonym):
                self.synonymWords = synonym
                self.delegate?.fetchedSynonymWords()
            case .failure(_):
                break
            }
        }
    }
}
