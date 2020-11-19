//
//  User.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 08/11/2020.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String? // as users don't have to put their names in, we have to make it as an optional
    var location: String? // same here.
    var bio: String? // same here.
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
