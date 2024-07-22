//
//  NetworkManager.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 15.07.2024.
//

import UIKit

enum ErrorMessage: String, Error {
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case serverError = "Unable to complete your request. Please check your connection."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}

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
                
                let user = try decoder.decode(User.self, from: data)
                
                completion(.success(user))
                
            } catch {
                completion(.failure(.invalidData))
            }
             
        }
        .resume()
    }
}
