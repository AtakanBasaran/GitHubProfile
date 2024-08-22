//
//  NetworkManager.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 15.07.2024.
//

import UIKit

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    
    let cache = NSCache<NSString, UIImage>() //we use cache to store images for short term in network manager class rather than writing in FollowerCell file is in every cell creation, the cache will be created again but since network manager class is singleton, we can use one instance of cache everywhere
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], ErrorMessage>) -> () ) {
        
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let followers = try decoder.decode([Follower].self, from: data)
                
                completion(.success(followers))
                
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        .resume()
    }
    
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, ErrorMessage>) -> () ) {
        
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601 //if we use this, we turn date into the date format we use named iso8601
                
                let user = try decoder.decode(User.self, from: data)
                
                completion(.success(user))
                
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        .resume()
    }
    
    
    // We make our network code here instead of Network Manager file because we do not show any error, we do not pass result type because we need to pass error type either but we do not have anything to do with errors since we use placeholder in case of error
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> () ) { //we do not show any error to the user because we use placeholder image
        
        let cacheKey = NSString(string: urlString) //we use urlString as identifier for each cache value since they are unique
        
        if let image = cache.object(forKey: cacheKey) { //
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                      completion(nil)
                      return
                }
            
            cache.setObject(image, forKey: cacheKey) //we save our image to cache
            
            completion(image)
        }
        
        task.resume()
        
    }
}
