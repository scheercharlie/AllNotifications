//
//  NotificationListViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit

class NotificationListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: AppConstants.isFinishedLoggingIn)
        print(UserDefaults.standard.bool(forKey: AppConstants.isFinishedLoggingIn))
        print("button tapped")
        
        let storyboard = UIStoryboard(name: AppConstants.loginStoryboard, bundle: Bundle.main)
        let desitnation = storyboard.instantiateViewController(identifier: AppConstants.loginListVCIdentifier)
            
        self.dismiss(animated: true, completion: nil)
        self.present(desitnation, animated: true, completion: nil)
        
        
    }
    
    
}
