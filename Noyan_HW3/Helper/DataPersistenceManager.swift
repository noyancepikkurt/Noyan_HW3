//
//  DataPersistenceManager.swift
//  Noyan_HW3
//
//  Created by Noyan Çepikkurt on 26.05.2023.
//

import UIKit
import CoreData

final class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    private let maxRecentSearchCount = 5
    
    func saveWord(model: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchWord { result in
            switch result {
            case .success(var recentSearches):
                let existingSearch = recentSearches.first { $0.recentSearchWord == model }
                if let existingSearch = existingSearch {
                    if let index = recentSearches.firstIndex(of: existingSearch) {
                        recentSearches.remove(at: index)
                    }
                    context.delete(existingSearch)
                }
                
                let newSearch = RecentSearchEntity(context: context)
                newSearch.recentSearchWord = model
                
                if recentSearches.count >= self.maxRecentSearchCount {
                    let oldestSearch = recentSearches.removeFirst()
                    context.delete(oldestSearch)
                }
                recentSearches.append(newSearch)
                
                do {
                    try context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchWord(completion: @escaping (Result<[RecentSearchEntity], Error>) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RecentSearchEntity> = RecentSearchEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            var recentSearches = try context.fetch(fetchRequest)
            recentSearches.reverse()
            let limitedRecentSearches = Array(recentSearches.prefix(maxRecentSearchCount))
            completion(.success(limitedRecentSearches))
        } catch {
            completion(.failure(error))
        }
    }
}
