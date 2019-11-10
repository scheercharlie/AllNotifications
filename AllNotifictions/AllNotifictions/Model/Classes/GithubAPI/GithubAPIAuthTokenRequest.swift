//
//  GithubAPIAuthTokenRequest.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPIAuthTokenRequest: Encodable {
    let clientId: String
    let clientSecret: String
    let code: String
    let redirectURI: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
        case redirectURI = "redirect_uri"
        case code
    }
    
    func getAuthStringAsData() -> Data? {
        let params: [String: String] = ["client_id": clientId, "redirect_uri": redirectURI, "client_secret": clientSecret,"code": code]
        
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        let postString = data.map { String($0) }.joined(separator: "&")
        
        guard let stringData = postString.data(using: .utf8) else {
            print("couldn't convert string to data")
            return nil
        }
        
        return stringData
    }
}

