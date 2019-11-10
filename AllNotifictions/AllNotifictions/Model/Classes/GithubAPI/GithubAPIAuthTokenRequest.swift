//
//  GithubAPIAuthTokenRequest.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPIAuthTokenRequest: Encodable {
    let clientId: String
    let clientSecret: String
    let code: String
    let redirectURI: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case code
    }
}
