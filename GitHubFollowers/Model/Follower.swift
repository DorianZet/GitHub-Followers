//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Mateusz Zacharski on 08/11/2020.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String // although originally this property is 'avatar_url' (written in snake case) in JSON, we can write in camel case, as we are able to convert JSON calls from snake and camel cases back and forth.
}
