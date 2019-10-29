//
//  ViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class LoginListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension LoginListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: constants.cellIdentifier, for: indexPath) as! LoginCell
        
        return tableCell
    }
    
    
}

extension LoginListViewController {
    enum constants {
        static let cellIdentifier = "loginCell"
    }
}
