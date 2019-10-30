//
//  HostType.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

//A class of available Notification Host Services
public class HostType: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    var type: SocialService!

    //Required functions for using with Transformable core data type
    public func encode(with coder: NSCoder) {
        coder.encode(type, forKey: "type")
    }
    
    public required init?(coder: NSCoder) {
        coder.decodeObject(forKey: "type")
    }
    
    //Defined available services
    enum SocialService: Int, CaseIterable, Codable {
        case github = 1, wordpress, slack
    }
    
    
}
