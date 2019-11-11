//
//  GithubAPINotificationDetailsResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPINotificationsDetailsResponse: Decodable {
    let user: User
    let title: String
    let body: String
    
}

struct User: Decodable {
    let login: String
    
}
