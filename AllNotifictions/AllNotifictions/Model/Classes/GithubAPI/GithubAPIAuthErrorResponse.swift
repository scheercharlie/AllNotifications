//
//  GithubAPIAuthErrorResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPIAuthErrorResponse: DecodeableError {
    let error: String
    let returnedDescription: String
    let errorUri: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case returnedDescription = "error_description"
        case errorUri = "error_uri"
    }
}
