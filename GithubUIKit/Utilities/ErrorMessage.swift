//
//  ErrorMessage.swift
//  GithubUIKit
//
//  Created by Atakan Başaran on 3.08.2024.
//

import Foundation

enum ErrorMessage: String, Error {
    
    case invalidUsername = "This username created an invalid request. Please try again."
    case serverError = "Unable to complete your request. Please check your connection."
    case invalidResponse = "Invalid response from server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error adding this user to favorites. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
}
