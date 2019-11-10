//
//  GithubAPIClient.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

class GithubAPIClient: APIClient {
    struct Auth {
        
    }
    
    enum endpoints {
            
        var stringValue: String {
            switch self {
            
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
}
