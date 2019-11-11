//
//  Notification.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import CoreData

extension Notification {
    func setupNewWordPressNotificationFrom(_ note: WordPressNote, withHost host: NotificationHost, completion: @escaping (Bool) -> Void) {
        self.id = String(note.id) 
        
        self.title = note.title
        self.type = note.type
        
        if let url = URL(string: note.url) {
            self.url = url
        }
        
        if note.read == 0 {
            self.read = false
        } else {
            self.read = true
        }
        
        if let meta = note.meta {
            self.siteID = String(meta.ids.site)
        }
        
        var bodyText = ""
        for body in note.body {
            bodyText.append(body.text)
        }
        self.body = bodyText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: note.timestamp) {
            self.timeStamp = date
        }
        
        self.notificationsHost = host
        
        DispatchQueue.main.async {
            completion(true)
        }
    }
    
    func setupNewGithubNotifiationFrom(_ note: GithubAPINotificationResponse, withHost host: NotificationHost, completion: @escaping (Bool) -> Void) {
        print("new github notification")
        
        self.id = note.id
        self.read = !note.unread
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: note.updatedAt) {
            self.timeStamp = date
        }
        
        self.title = note.subject.title
        self.type = note.subject.type
        self.url = URL(string: note.notificationURL)
        
        self.notificationsHost = host
        
        getGithubIssueNotificationDetails(url: URL(string: note.subject.url)!, completion: { (success, body) in
            if success {
                if let body = body {
                    self.body = body
                }
                completion(true)
            } else {
                completion(false)
            }
        })
 
    }
    
    func getGithubIssueNotificationDetails(url: URL, completion: @escaping (Bool, String?) -> Void) {
        GithubAPIClient.ApiTaskRequest(url: url, method: "GET", responseType: GithubAPINotificationsDetailsResponse.self, body: nil, errorType: GithubAPINotificationErrorResponse.self) { (data, error) in

            if let data = data {
                let string = data.body
                let lines = string.split { $0.isNewline }
                let result = lines.joined(separator: "\n")
    
                completion(true, result)
            } else {
                completion(false, nil)
            }
        }
    }
}
