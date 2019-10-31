//
//  LoginViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit


//TO DO: figure out how to require view to be vertical
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
