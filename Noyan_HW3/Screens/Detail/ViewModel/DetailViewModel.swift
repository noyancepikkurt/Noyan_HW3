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
    func didOccurError(_ error: Error)
    func filteredMeanings()
}

final class DetailViewModel {
    var selectedWord: String
    var wordDetail: DictionaryModel?
    var synonymWords: [SynonymModel]?
    weak var delegate: DetailViewModelProtocol?
    
    var filteredMeanings: [Meaning]?
    private var partOfSpeechFilter: String? = nil
    
    init(selectedWord: String) {
        self.selectedWord = selectedWord
    }
    
    func fetchWordDetails(completion: ((Bool) -> Void)? = nil) {
        NetworkService.shared.fetchWord(pathUrl: "\(NetworkURL.dictionaryURL.rawValue)\(selectedWord)") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let wordModel):
                self.wordDetail = wordModel
                self.delegate?.fetchedWordDetail()
                completion?(true)
            case .failure(let error):
                self.delegate?.didOccurError(error)
                completion?(false)
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
    
    func didSelectCollectionCell(partOfSpeech: String) {
        guard let meaningModel = self.wordDetail?.meanings else { return }
        if self.partOfSpeechFilter == partOfSpeech {
            self.filteredMeanings = meaningModel
            self.partOfSpeechFilter = nil
        } else {
            let filteredPartOfSpeech = meaningModel.filter { meaning in
                meaning.partOfSpeech == partOfSpeech
            }
            self.filteredMeanings = filteredPartOfSpeech
            self.partOfSpeechFilter = partOfSpeech
        }
        self.delegate?.filteredMeanings()
    }
    
    func numberOfItems() -> Int {
        var meaningCount = 0
        if let filteredModel = filteredMeanings {
            filteredModel.forEach { meaning in
                guard let definitions = meaning.definitions else { return }
                meaningCount += definitions.count
            }
        } else {
            guard let meaningModel = wordDetail?.meanings else { return 0 }
            meaningModel.forEach { meaning in
                guard let definitions = meaning.definitions else { return }
                meaningCount += definitions.count
            }
        }
        return meaningCount
    }
    
    func sortSynonymTopFiveScores() -> [SynonymModel] {
        let sortedArray = self.synonymWords?.sorted { $0.score! > $1.score! }
        guard let sortedArray else { return [SynonymModel]() }
        let topFiveSynonyms = Array(sortedArray.prefix(5))
        return topFiveSynonyms
    }
}
