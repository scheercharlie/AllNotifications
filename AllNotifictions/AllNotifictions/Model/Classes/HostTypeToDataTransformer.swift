//
//  HostTypeToDataTransformer.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import CoreData

class HostTypeToDataTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        let hostType = try! NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: true)
        return hostType
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        let hostTypeData = value as! Data
        let hostType = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [HostType.self], from: hostTypeData)
        return (hostType as! [HostType])
    }
}
