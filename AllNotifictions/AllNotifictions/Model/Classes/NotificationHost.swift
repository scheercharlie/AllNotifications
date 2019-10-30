//
//  NotificationService.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import CoreData

extension NotificationHost {
    
    func getHostTitle() -> String? {
        if let hostType = self.hostType {
            switch hostType.type {
            case .github:
                return "Github"
            case .wordpress:
                return "WordPress"
            case .slack:
                return "Slack"
            default:
                return nil
            }
        }
    }
}
