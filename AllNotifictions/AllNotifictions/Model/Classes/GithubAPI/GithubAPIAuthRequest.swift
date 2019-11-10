//
//  GithubAPIAuthRequest.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPIAuthRequest: Codable {
    let clientId: String
    let redirectURI: String
    let login: String
    let scope: String
    let state: String
    let allowSignup: Bool
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case redirectURI = "redirect_uri"
        case login
        case scope
        case state
        case allowSignup = "allow_signup"
    }
}
