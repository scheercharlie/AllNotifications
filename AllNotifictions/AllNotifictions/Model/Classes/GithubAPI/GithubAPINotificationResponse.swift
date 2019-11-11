//
//  GithubAPINotificationResponse.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct GithubAPINotificationResponse: Decodable {
    let id: String
    let unread: Bool
    let reason: String
    let updatedAt: String
    let lastReadAt: String?
    let subject: GithubSubject
    let repository: GithubRepository
    let notificationURL: String
    let subscriptionURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case unread
        case reason
        case updatedAt = "updated_at"
        case lastReadAt = "last_read_at"
        case subject
        case repository
        case notificationURL = "url"
        case subscriptionURL = "subscription_url"
    }
    
}

struct GithubSubject: Decodable {
    let title: String
    let url: String
    let latestCommentUrl: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case latestCommentUrl = "latest_comment_url"
        case type
    }
}

struct GithubRepository: Decodable {
    let id: Int
    let nodeId: String
    let name: String
    let fullName: String
    let repoPrivate: Bool
    let repoURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name
        case fullName = "full_name"
        case repoPrivate = "private"
        case repoURL = "html_url"
    }
}
