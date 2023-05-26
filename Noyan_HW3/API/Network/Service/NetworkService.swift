//
//  NetworkService.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import Foundation

public protocol NetworkServiceProtocol: AnyObject {
    func fetchWord(pathUrl: String, completion: @escaping (Result<String, Error>) -> Void)
}

final public class NetworkService: NetworkServiceProtocol {
    static public let shared = NetworkService()
    
    public func fetchWord(pathUrl: String, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.request(pathUrl: pathUrl) { (result: Result<[DictionaryModel], Error>) in
            switch result {
            case .success(let success):
                let word = success[0].word
                completion(.success(word ?? ""))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
