//
//  User.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 15.07.2024.
//

import Foundation

//Optional variables must be var not let

struct User: Codable {
    
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
 
