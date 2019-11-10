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
        case getNotifications
        
        var stringValue: String {
            switch self {
            case .authentication: return "https://public-api.wordpress.com/oauth2/authorize?client_id=\(Auth.clientId)&redirect_uri=\(Auth.redirectURI)&response_type=code"
            case .codeAuthentication: return "https://public-api.wordpress.com/oauth2/token"
            case .getNotifications: return "https://public-api.wordpress.com/rest/v1.1/notifications/"
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
        print("is WordPress auth")
        guard let queryItems = components.queryItems, let code  = queryItems[0].value else {
            print("couldn't get code")
            return nil
        }
        
        return code
    }
    
    
    private static func codeAuthenticationPostRequest(code: String, host: NotificationHost, completion: @escaping (Bool, Error?) -> Void) {
        let authRequest = WordPressAPIAuthRequest(clientId: Auth.clientId,
                                                  redirectURI: Auth.redirectURI,
                                                  clientSecret: Auth.clientSecret,
                                                  code: code,
                                                  grantType: "authorization_code")
        
        guard let stringData = authRequest.getAuthStringAsData() else {
            print("couldn't convert string to data")
            return
        }
        
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
                        
                        host.token = data.accessToken
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
        let headers = [HTTPHeaders(value: "Bearer \(token)", field: "Authorization"), HTTPHeaders(value: "application/json", field: "Content-Type")]
        
        ApiTaskRequestWithHeaders(url: endpoints.getNotifications.url, method: "GET", responseType: WordPressAPINotificationResponse.self, body: nil, headers: headers, errorType: WordPressAPINotificationErrorResponse.self) { (data, error) in
            if let notes = data?.notes {
                for note in notes {
                    let newNotification = Notification(context: DataController.shared.viewContext)
                    newNotification.setupNewWordPressNotificationFrom(note, host: host)
                    

                    
                }
                
                do {
                    try DataController.shared.backgroundContext.save()
                    print("did save")
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                } catch {
                    print("Couldn't save WordPress notifications")
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            }
        }
    }
}
