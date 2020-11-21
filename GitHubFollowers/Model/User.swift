//
//  User.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 08/11/2020.
//

import Foundation
// As our app deals only with DISPLAYING the users info, not CHANGING anything in them, we don't have to make the user properties 'var' - except for the optionals, as those might or might not be there.
struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String? // as users don't have to put their names in, we have to make it as an optional
    var location: String? // same here.
    var bio: String? // same here.
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
