//
//  HostType.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

public class HostType: NSObject, Codable {
    let type: SocialService!

    
    init(type: SocialService) {
        self.type = type
    }
    
    enum SocialService: Int, Codable {
        case github = 1, wordpress, slack
    }
    
    
}
