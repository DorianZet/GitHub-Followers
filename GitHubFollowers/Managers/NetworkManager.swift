//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 08/11/2020.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/" // we can create a baseURL for our convenience, as all the url calls will start with this url.
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) { // the 'GFError' is the enum we created in 'Utilities' folder. The result can be a success - which then returns an array of 'Follower', or a failure - which then returns a GFError (which complies to 'Error' protocol - otherwise we wouldn't be able to use it).
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)" // we make a call for 100 users at once. we can change it to 50 or 60 if need be.
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername)) // if url is nil, it's a failure case and we present an error message attached to that case.
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error { // that means "if the error exists...". if it doesn't 'error' will be nil, as it's an optional.
                completed(.failure(.unableToComplete))
                return // if we get the error, we don't want the rest of the code to execute, so we return.
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { // check if response is nil - and if it isn't, check if its status code is 200 (it means it's OK).
                completed(.failure(.invalidResponse))
                return // if we get the error, we don't want the rest of the code to execute, so we return.
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // we convert the snake case (e.g. 'avatar_url') to camel case ('avatarUrl').
                let followers = try decoder.decode([Follower].self, from: data) // we want an array of Followers, so we try to decode it. We want to create that array of type 'Follower' from 'data', which is above in 'guard let data = data' line above.
                completed(.success(followers)) // if all goes well, we get an array of Followers - we described that in the function parameters 'Result<[Follower]' - which goes for the success case.
            } catch { // catching the error.
                completed(.failure(.invalidData))
            }
        }
        
        task.resume() // starts the network call.
    }
    
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) { // the 'GFError' is the enum we created in 'Utilities' folder. The result can be a success - which then returns a 'User' object, or a failure - which then returns a GFError (note that GFError complies to the 'Error' protocol - otherwise we wouldn't be able to use it).
        let endpoint = baseURL + "\(username)" // the endpoint for fetching a single user info is baseURL + username.
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return //
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
               let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601 // 
                let user = try decoder.decode(User.self, from: data) // we want a single user, so we try to decode it. We want to create that user of type 'User' from 'data', which is in 'guard let data = data' line above.
                completed(.success(user)) // if all goes well, we get a user - we described that in the function parameters 'Result<User' - which goes for the success case.
            } catch { // catching the error.
                completed(.failure(.invalidData))
            }
        }
        
        task.resume() // starts the network call.
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString) // setting the image's cache key, which will be its url string.
        
        if let image = cache.object(forKey: cacheKey) { // if the image is already in the cache, set the avatar image as this image in the cache and return.
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil) // we don't return any error, because when anything fails when getting the image, we have our octocat placeholder to show if an image is unavailable.
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            // As we don't have to deal with any separate error cases (if anything goes wrong, we just get nil in return), we can combine all the conditions in one 'guard' statement by separating them with commas.
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                    completed(nil)
                    return
                  }
                  
            self.cache.setObject(image, forKey: cacheKey) // set the image into the cache (the cache key of the image is the url string from where we get the image)
            
            DispatchQueue.main.async { // because we are on a background thread, we have to update our UI on the main one - this is why the 'completed' closure will take the 'image' object and update the UI with it on a main thread.
                completed(image)
            }
        }
        
        task.resume()
    }
}
