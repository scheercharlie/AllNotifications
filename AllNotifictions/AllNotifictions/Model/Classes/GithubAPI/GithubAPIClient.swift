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
        static let clientId = "b51ef12b40f4707f19a0"
        static let clientSecret = "4aad21a4460a5467741a9c5f421679b8131b6633"
        static let redirectURI = "https://allnotifications.app/github"
    }
    
    enum endpoints {
        case authentication
        
        var stringValue: String {
            switch self {
            case: .authentication return "https://github.com/login/oauth/authorize"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
}
