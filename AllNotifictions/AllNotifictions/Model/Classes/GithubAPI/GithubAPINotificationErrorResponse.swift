//
//  GithubAPINotificationErrorResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPINotificationErrorResponse: DecodeableError {
    let message: String
    let documentationURL: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case documentationURL = "documentation_url"
    }
}
