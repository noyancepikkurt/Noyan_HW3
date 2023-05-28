//
//  NetworkService.swift
//  
//
//  Created by Noyan Çepikkurt on 27.05.2023.
//

import Foundation

public protocol NetworkServiceProtocol: AnyObject {
    func fetchWord(pathUrl: String, completion: @escaping (Result<DictionaryModel, Error>) -> Void)
    func fetchSynonymWords(pathUrl: String, completion: @escaping (Result<[SynonymModel], Error>) -> Void)
}

final public class NetworkService: NetworkServiceProtocol {
    static public let shared = NetworkService()
    
    public func fetchWord(pathUrl: String, completion: @escaping (Result<DictionaryModel, Error>) -> Void) {
        NetworkManager.shared.request(pathUrl: pathUrl) { (result: Result<[DictionaryModel], Error>) in
            switch result {
            case .success(let wordModel):
                completion(.success(wordModel[0]))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    public func fetchSynonymWords(pathUrl: String, completion: @escaping (Result<[SynonymModel], Error>) -> Void) {
        NetworkManager.shared.request(pathUrl: pathUrl) { (result: Result<[SynonymModel], Error>) in
            switch result {
            case .success(let synonym):
                completion(.success(synonym))
                print(synonym)
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
