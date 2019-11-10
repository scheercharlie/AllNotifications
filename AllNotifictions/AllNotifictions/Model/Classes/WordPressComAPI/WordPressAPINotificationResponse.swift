//
//  WordPressAPINotificationResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct WordPressAPINotificationResponse: Decodable {
    let lastSeenTime: String
    let number: Int
    let notes: [WordPressNote]
    
    enum CodingKeys: String, CodingKey {
        case lastSeenTime = "last_seen_time"
        case number
        case notes
    }
}

struct WordPressNote: Decodable {
    let id: Int
    let type: String
    let read: Int
    let timestamp: String
    let url: String
    
    let subject: [Subject]
    let body: [Body]
    let meta: Meta?
    let title: String
}

struct Subject: Decodable {
    let text: String
    let ranges: [Ranges]?
}

struct Ranges: Decodable {
    let type: String
    let url: String
    let siteId: Int?
    
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case url
        case siteId = "site_id"
        
        case id
    }
}

struct Body: Decodable {
    let text: String
    let ranges: [Ranges]?
}

struct Meta: Decodable {
    let ids: Ids
    let links: Links
}

struct Ids: Decodable {
    let site: Int
}

struct Links: Decodable {
    let site: String
}
