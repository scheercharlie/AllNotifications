//
//  GithubAPIAuthTokenResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPIAuthTokenResponse: Decodable {
    let token: String
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case scope
        case tokenType = "token_type"
    }
}

