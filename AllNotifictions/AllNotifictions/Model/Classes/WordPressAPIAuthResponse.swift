//
//  WordPressAPIAuthResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/8/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct WordPressAPIAuthResponse: Decodable {
    let accessToken: String
    let blogId: String
    let blogURL: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case blogId = "blog_id"
        case blogURL = "blog_url"
        case tokenType = "token_type"
    }
}
