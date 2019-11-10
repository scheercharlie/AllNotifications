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
    let notes: [Notes]
}

struct Notes: Decodable {
    let id: Int
    let type: String
    let read: Int
    let timeStamp: String
    let url: String
    let subject: [Subject]
    let body: [Body]
    let title: String
    let meta: [Meta]
}

struct Subject: Decodable {
    let text: String
    let ranges: [Ranges]
}

struct Ranges: Decodable {
    let type: String
    let url: String
    let siteId: Int
    let email: String
    let id: Int
}

struct Body: Decodable {
    let text: String
    let ranges: [Ranges]
}

struct Meta: Decodable {
    let ids: [String: Int]
    let links: [String: String]
    let title: String
}
