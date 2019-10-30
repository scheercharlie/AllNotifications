//
//  LoginViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    var selectedService: NotificationHost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        if let selectedService = selectedService {
            print("service passed")
            print(selectedService.title!)
        }
    }
}
