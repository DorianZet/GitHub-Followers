//
//  GFError.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 21/11/2020.
//

import Foundation

enum GFError: String, Error { // it has a raw value of string and confirms to 'Error' protocol - now we can use it in 'Result' type.
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must really like them!"
}
