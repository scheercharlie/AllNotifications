//
//  NotificationCell.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: NSLayoutConstraint!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func likeButtonWasTapped(_ sender: Any) {
        print("tapped")
    }
    
    
}
