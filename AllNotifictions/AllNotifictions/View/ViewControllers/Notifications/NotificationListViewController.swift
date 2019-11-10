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
        self.navigationController?.navigationItem.hidesBackButton = true
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

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.notificationCellIdentifier, for: indexPath) as! NotificationCell
        
        
        return cell
    }
    
    
}

extension NotificationListViewController {
    enum constants {
        static let notificationCellIdentifier = "notificationCell"
    }
}
