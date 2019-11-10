//
//  HostType.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

//A class of available Notification Host Services
class HostType: Codable {
    var type: SocialService!
    
    enum CodingKeys: String, CodingKey {
        case type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let typeInt = self.type.rawValue
        try container.encode(typeInt, forKey: .type)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedInt = try values.decode(Int.self, forKey: .type)
        self.type = HostType.SocialService.init(rawValue: decodedInt)
    }
    
    init(type: SocialService) {
        self.type = type
    }
    
    func getHostTitle() -> String? {
        if let hostType = type {
            switch hostType {
            case .github:
                return "Github"
            case .wordpress:
                return "WordPress"
            }
        } else {
            return nil
        }
    }
    
    //Defined available services
    enum SocialService: Int, CaseIterable, Codable {
        case github = 1, wordpress
    }
    
    enum constants {
        static let serviceKey = "service"
    }
    
}
