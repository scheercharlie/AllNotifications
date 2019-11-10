//
//  WordPressAPIAuthErrorResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/8/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct WordPressAPIAuthErrorResponse: DecodeableError {
    let error: String
    let returnedDescription: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case returnedDescription = "error_description"
    }
}
