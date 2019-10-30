//
//  HostType.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

public class HostType: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    var type: SocialService!

    
    public func encode(with coder: NSCoder) {
        coder.encode(type, forKey: "type")
    }
    
    public required init?(coder: NSCoder) {
        coder.decodeObject(forKey: "type")
    }

    
    init(type: SocialService) {
        self.type = type
    }
    
    enum SocialService: Int, CaseIterable, Codable {
        case github = 1, wordpress, slack
    }
    
    
}
