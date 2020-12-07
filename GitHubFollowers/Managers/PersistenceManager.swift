//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 02/12/2020.
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
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        retrieveFavorites { (result) in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(favorite) else { // checking if our favorites don't have the user already.
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    retrievedFavorites.append(favorite)
                case.remove:
                    retrievedFavorites.removeAll { $0.login == favorite.login } // anywhere in retrievedFavorites where the login equals the favorite login, remove it from retrievedFavorites.
                }
                
                completed(save(favorites: retrievedFavorites)) // if the update was successful, save the favorites. we can use the save(favorites:) method here, as it returns an error, which is required for this closure.
            
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else { // we have to tell Swift that our object is of a 'Data' type.
            completed(.success([])) // returning an empty array of followers.
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites)) // now, when we use retrieveFavorites in FavoritesListVC and the action is completed, we have favorites - and in the closure we then decide what we want to do with those favorites. Same thing goes for the error. Once we get the error, in our closure we decide what we want to do with it (see 'getFavorites' function in FavoritesListVC to see how we do it).
        } catch {
            completed(.failure(.unableToFavorite)) // it's better to use .unableToRetrieveFavorites error here.
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? { // if saving is successful, the function will return an error as nil.
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    
}
