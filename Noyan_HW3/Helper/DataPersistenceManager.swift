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
    
    func saveNew(model: DictionaryModel, isFavorite: Bool, completion: @escaping ((Result<Void, Error>)->Void)) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchNew { result in
            switch result {
            case .success(var recentSearches):
                let newSearch = RecentSearchEntity(context: context)
                newSearch.recentSearchWord = model.word
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
    
    func fetchNew(completion: @escaping (Result<[RecentSearchEntity], Error>) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RecentSearchEntity> = RecentSearchEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Tarih sırası
        
        do {
            let recentSearches = try context.fetch(fetchRequest)
            
            // Son aramalar
            let limitedRecentSearches = Array(recentSearches.prefix(maxRecentSearchCount))
            
            completion(.success(limitedRecentSearches))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteNew(model: RecentSearchEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
