//
//  WordPressAPIAuthRequest.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/8/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct WordPressAPIAuthRequest: Codable {
    let clientId: String
    let redirectURI: String
    let clientSecret: String
    let code: String
    let grantType: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case redirectURI = "redirect_uri"
        case clientSecret = "client_secret"
        case code = "code"
        case grantType = "grant_type"
    }
}
