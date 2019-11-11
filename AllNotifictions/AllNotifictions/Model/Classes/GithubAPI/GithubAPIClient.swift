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
        case getNotifications
        
        var stringValue: String {
            switch self {
            case .authentication: return "https://github.com/login/oauth/authorize" + "?client_id=" + Auth.clientId + "&redirect_uri=" + Auth.redirectURI + "&scope=notifications"
            case .tokenAuthentication: return "https://github.com/login/oauth/access_token"
            case .getNotifications: return "https://api.github.com/notifications"
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
        
        codeAuthenticationPostRequest(code: code, host: host) { (success, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            } else {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
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
        guard let body = authRequest.getAuthStringAsData() else {
            return
        }
        
        ApiTaskRequestWithHeaders(url: endpoints.tokenAuthentication.url,
                                  method: "POST",
                                  responseType: GithubAPIAuthTokenResponse.self,
                                  body: body,
                                  headers: [HTTPHeaders(value: "application/json", field: "Accept")],
                                  errorType: GithubAPIAuthErrorResponse.self) {
                                    (data, error) in
                                    
                                    if let error = error as? WordPressAPIAuthErrorResponse {
                                        print(error.returnedDescription)
                                    }
                                    
                                    guard let data = data else {
                                        return
                                    }
                                    
                                    host.token = data.token
                                    host.tokenType = data.tokenType
                                    host.isLoggedIn = true
                                    
                                    if DataController.shared.backgroundContext.hasChanges {
                                        print("has changes")
                                        
                                        do {
                                            try DataController.shared.backgroundContext.save()
                                            DispatchQueue.main.async {
                                                completion(true, nil)
                                            }
                                        } catch {
                                            print("Save failed")
                                            DispatchQueue.main.async {
                                                completion(false, error)
                                            }
                                        }
                                        
                                    }
                                    
        }
    }
    
    static func getNotifications(token: String, host: NotificationHost, completion: @escaping (Bool, Error?) -> Void) {
        let headers = [HTTPHeaders(value: "token \(token)", field: "Authorization")]
        
        ApiTaskRequestWithHeaders(url: endpoints.getNotifications.url,
                                  method: "GET",
                                  responseType: GithubAPINotificationResponse.self, body: nil, headers: headers, errorType: GithubAPINotificationErrorResponse.self) { (data, error) in
                                    //Add code
        }
    }
}
