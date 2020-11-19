//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 08/11/2020.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String // although this property is 'avatar_url' (written in snake case) in json, we can write in camel case, as json calls automatically converts snake and camel cases back and forth.
}
