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
        let params: [String: String] = ["client_id": Auth.clientId, "redirect_uri": Auth.redirectURI, "client_secret": Auth.clientSecret,"code": code, "grant_type": "authorization_code"]
        
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        let postString = data.map { String($0) }.joined(separator: "&")
        
        guard let stringData = postString.data(using: .utf8) else {
            print("couldn't convert string to data")
            return
        }
        print(postString)
        
        ApiTaskRequest(url: endpoints.codeAuthentication.url,
                       method: "POST",
                       responseType: WordPressAPIAuthResponse.self,
                       body: stringData,
                       errorType: WordPressAPIAuthErrorResponse.self) {
                        (data, error) in
                  
                        if let error = error as? WordPressAPIAuthErrorResponse {
                            print(error.returnedDescription)
                        }
                        guard let data = data else {
                            print("no data returned")
                            return
                        }
                        print(data.accessToken)
                        print(data.blogId)
                        print(data.blogURL)
                        print(data.tokenType)
        }
    }
}
