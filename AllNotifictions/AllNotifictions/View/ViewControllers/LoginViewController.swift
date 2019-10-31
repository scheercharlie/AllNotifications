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
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var selectedService: NotificationHost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")
        if let selectedService = selectedService {
            print("service passed")
            print(selectedService.title!)
        }
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
            
        print("login was tapped")
    }
    
    
}
