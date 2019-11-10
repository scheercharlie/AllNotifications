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
        static let redirectURI = "https://allnotifications.app/github/"
    }
    
    enum endpoints {
        case authentication
        case tokenAuthentication
        
        var stringValue: String {
            switch self {
            case .authentication: return "https://github.com/login/oauth/authorize" + "?client_id=" + Auth.clientId + "&redirect_uri=" + Auth.redirectURI + "&scope=notifications"
            case .tokenAuthentication: return "https://github.com/login/oauth/access_token"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }

    static func authenticate(components: URLComponents, host: NotificationHost, completion: @escaping (Bool, Error?) -> Void) {
         guard let code = handleAuthenticationResponse(components: components) else {
             print("no auth code")
             return
         }
         
    }
    
    private static func handleAuthenticationResponse(components: URLComponents) -> String? {
        print("is Github auth")
        guard let queryItems = components.queryItems, let code  = queryItems[0].value else {
            print("couldn't get code")
            return nil
        }
        
        return code
    }
    
    
    private static func codeAuthenticationPostRequest(code: String, host: NotificationHost, completion: @escaping (Bool, Error?) -> Void) {
        print(code)
        
        let authRequest = GithubAPIAuthTokenRequest(clientId: Auth.clientId,
                                                    clientSecret: Auth.clientSecret,
                                                    code: code,
                                                    redirectURI: Auth.redirectURI)
        var body = Data()
        
        do {
            let encoder = JSONEncoder()
            let encodedRequest = try encoder.encode(authRequest)
            body = encodedRequest
        } catch {
            print("Could not encode request")
            //TO DO: handle failure
        }
        
        ApiTaskRequest(url: endpoints.tokenAuthentication.url, method: "POST", responseType: GithubAPIAuthTokenResponse.self, body: body, errorType: GithubAPIAuthErrorResponse.self) { (data, error) in
            //Code
        }
    }
}
