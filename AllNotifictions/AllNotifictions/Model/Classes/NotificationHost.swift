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
    func setDataFromType(_ hostType: HostType) {
        let encoder = PropertyListEncoder()
        let data = try! encoder.encode(hostType)
        
        self.hostType = data
    }
    
    func getTypeFromHostTypeData() -> HostType? {
        //TO DO: Handle try better
        guard let hostTypeData = self.hostType else {
            return nil
        }
        let decoder = PropertyListDecoder()
        let service = try! decoder.decode(HostType.self, from: hostTypeData)
        
        return service
    }

}

extension NotificationHost {
    enum constants {
        static let wordpress = "WordPress"
        static let slack = "Slack"
        static let github = "Github"
        static let serviceKey = "service"
    }
}
