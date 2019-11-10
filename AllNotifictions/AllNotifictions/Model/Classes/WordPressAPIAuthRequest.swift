//
//  WordPressAPIAuthRequest.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/8/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

//TO DO: Check if using, if not remove
import Foundation

struct WordPressAPIAuthRequest: Codable {
    let clientId: String
    let redirectURI: String
    let clientSecret: String
    let code: String
    let grantType: String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case redirectURI = "redirect_uri"
        case clientSecret = "client_secret"
        case code = "code"
        case grantType = "grant_type"
    }
    
    func getAuthStringAsData() -> Data? {
        let params: [String: String] = ["client_id": clientId, "redirect_uri": redirectURI, "client_secret": clientSecret,"code": code, "grant_type": grantType]
        
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
