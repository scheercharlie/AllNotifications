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
            case .authentication: return "https://github.com/login/oauth/authorize"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    
    static func authenticate(url: URL, completion: @escaping (Bool, Error?) -> Void) {
        let requestBody = GithubAPIAuthRequest(clientId: Auth.clientId, redirectURI: Auth.redirectURI, scope: "Notifications", allowSignup: false)
        var body = Data()
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(requestBody)
            body = encodedData
        } catch {
            print("Could not encode request")
        }
        
        ApiTaskRequest(url: url, method: "GET", responseType: String.self, body: body, errorType: GithubAPIAuthErrorResponse.self) { (data, error) in
            if error != nil {
                print("failed")
            } else {
                print(data)
            }
        }
    }
    
}
