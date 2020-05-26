//
//  SideMenuViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/14/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        switch indexPath.row {
            
        case 2: NotificationCenter.default.post(name: NSNotification.Name("myBookings"), object: nil)
        case 3: NotificationCenter.default.post(name: NSNotification.Name("rateApplication"), object: nil)
        case 4: NotificationCenter.default.post(name: NSNotification.Name("inviteFriends"), object: nil)
        case 5: NotificationCenter.default.post(name: NSNotification.Name("wallet"), object: nil)
        case 6: NotificationCenter.default.post(name: NSNotification.Name("notifications"), object: nil)
        case 7: NotificationCenter.default.post(name: NSNotification.Name("subscriptions"), object: nil)
        case 8: NotificationCenter.default.post(name: NSNotification.Name("settings"), object: nil)
        case 9: NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)

        default: break
            
        }
    }
}
