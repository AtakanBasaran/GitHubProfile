//
//  PersistenceManager.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 3.08.2024.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (ErrorMessage?) -> () ) { //we combine retrieve and save functions according to action type, we pass error if we fail to remove or add follower
        
        retrieveFavorites { result in
            
            switch result {
                
            case .success(let favorites):
                
                var retrievedFavorites = favorites //we pass to another variable temporarily since favorites come from completion is declared as let
                
                switch actionType {
                    
                case .add:
                    
                    guard !retrievedFavorites.contains(favorite) else { //No adding more than 1 time
                        completion(.alreadyInFavorites)
                        return
                    }
                    
                    retrievedFavorites.append(favorite)

                    
                case .remove:
                    retrievedFavorites.removeAll { $0.login == favorite.login}
                }
                
                completion(save(favorites: retrievedFavorites))
                
                
            case .failure(let error):
                completion(error)
            }
        }
        
    }
    
    
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], ErrorMessage>) -> () ) {
        
        //If we do not have favorite followers in user defaults, we passed completion as empty follower array
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let favorites = try JSONDecoder().decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
            
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> ErrorMessage? {
        
        do {
            let encodedFavorites = try JSONEncoder().encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            
            return nil
            
        } catch {
            return .unableToFavorite
        }
    }
}
