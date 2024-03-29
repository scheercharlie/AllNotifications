//
//  GithubAPIAuthRequest.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPIAuthRequest: Encodable {
    let clientId: String
    let redirectURI: String
    let scope: String
    let allowSignup: Bool
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case redirectURI = "redirect_uri"
        case scope
        case allowSignup = "allow_signup"
    }
}
