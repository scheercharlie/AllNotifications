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
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var selectedService: NotificationHost!
    var textFieldDelegate: LoginTextFieldDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if let selectedService = selectedService {
            serviceTitleLabel.text = selectedService.title
        }
        
        textFieldDelegate = LoginTextFieldDelegate()
        usernameTextField.delegate = textFieldDelegate
        passwordTextField.delegate = textFieldDelegate
        
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        print("login was tapped")
    }
    
    
}
