//
//  HTTPHeaders.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/2/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

class HTTPHeaders {
    let value: String
    let field: String
    
    init(value: String, field: String) {
        self.value = value
        self.field = field
    }
}
