//
//  SettingsTableView.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 11/07/2020.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class SettingsTableView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row {
            
        case 0:
            let destinationController = storyBoard.instantiateViewController(identifier: "ChangePassword") as! ChangePassword
            self.navigationController?.pushViewController(destinationController, animated: true)
            case 1:
                let destinationController = storyBoard.instantiateViewController(identifier: "Language") as! Language
                self.navigationController?.pushViewController(destinationController, animated: true)
            case 2:
                let destinationController = storyBoard.instantiateViewController(identifier: "AboutUs") as! AboutUs
                self.navigationController?.pushViewController(destinationController, animated: true)
            case 3:
                let destinationController = storyBoard.instantiateViewController(identifier: "PrivacyPolicy") as! PrivacyPolicy
                self.navigationController?.pushViewController(destinationController, animated: true)
            case 4:
                let destinationController = storyBoard.instantiateViewController(identifier: "TermsAndConditions") as! TermsAndConditions
                self.navigationController?.pushViewController(destinationController, animated: true)
            
        default:
            break
        }
    }
}

