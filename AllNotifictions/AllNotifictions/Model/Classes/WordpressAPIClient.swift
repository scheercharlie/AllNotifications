//
//  GithubAPIClient.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/2/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

class WordpressAPIClient: APIClient {
    struct Auth {
        static let clientId = "67280"
        static let redirectURI = "https://allnotifications.app/wordpress"
        static let clientSecret = "k8drmcBfAureFkOPivu3v8QKCbNUY72Z9puTlAZk3fyjWXlFgDBtPaEzp7V9Y33h"
    }
    
    
    enum endpoints {
        
        case authentication
        case codeAuthentication
        
        var stringValue: String {
            switch self {
            case .authentication: return "https://public-api.wordpress.com/oauth2/authorize?client_id=\(Auth.clientId)&redirect_uri=\(Auth.redirectURI)&response_type=code"
            case .codeAuthentication: return "https://public-api.wordpress.com/oauth2/token"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    static func authenticate(components: URLComponents) {
        guard let code = handleAuthenticationResponse(components: components) else {
            print("no auth code")
            return
        }
        
        codeAuthenticationPostRequest(code: code)
    }
    
    
    private static func handleAuthenticationResponse(components: URLComponents) -> String? {
        print("is WordPress auth")
        guard let queryItems = components.queryItems, let code  = queryItems[0].value else {
            print("couldn't get code")
            return nil
        }
        
        return code
    }
    
    
    private static func codeAuthenticationPostRequest(code: String) {
        print(code)
        let url = URL(string: "https://public-api.wordpress.com/oauth2/token")
        var request = URLRequest(url: url!)
        
        let body = WordPressAPIAuthRequest(clientId: Auth.clientId, redirectURI: Auth.redirectURI, clientSecret: Auth.clientSecret, code: code, grantType: "authentication-type")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(body)
        
        request.httpMethod = "POST"
        request.httpBody = data
        
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
        }
        session.resume()
    }
}
