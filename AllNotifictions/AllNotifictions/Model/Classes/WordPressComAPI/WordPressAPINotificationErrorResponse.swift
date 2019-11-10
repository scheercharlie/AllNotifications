//
//  WordPressAPINotificationErrorResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct WordPressAPINotificationErrorResponse: DecodeableError {
    let error: String
    let message: String
    
}
