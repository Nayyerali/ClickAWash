//
//  ViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/16/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth
import RESideMenu

class SideMenu: UITableViewController{
 
    @IBOutlet weak var profileTableViewCell: ProfileTableViewCell!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmailAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 1:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            self.sideMenuViewController.setContentViewController(homeViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 2:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let myBookingsViewController = storyboard.instantiateViewController(identifier: "MyBookingsViewController") as! MyBookingsViewController
            self.sideMenuViewController.setContentViewController(myBookingsViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 3:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let rateApplicationViewController = storyboard.instantiateViewController(identifier: "RateApplicationViewController") as! RateApplicationViewController
            self.sideMenuViewController.setContentViewController(rateApplicationViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 4:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let inviteFriendsViewController = storyboard.instantiateViewController(identifier: "InviteFriendsViewController") as! InviteFriendsViewController
            self.sideMenuViewController.setContentViewController(inviteFriendsViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 5:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let walletViewController = storyboard.instantiateViewController(identifier: "WalletViewController") as! WalletViewController
            self.sideMenuViewController.setContentViewController(walletViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 6:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let notificationsViewController = storyboard.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
            self.sideMenuViewController.setContentViewController(notificationsViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 7:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let subscriptionsViewController = storyboard.instantiateViewController(identifier: "SubscriptionsViewController") as! SubscriptionsViewController
            self.sideMenuViewController.setContentViewController(subscriptionsViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 8:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let settingsViewController = storyboard.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
            self.sideMenuViewController.setContentViewController(settingsViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 9:
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                // User.userSharefReference = nil
                self.navigationController?.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        default: break
            
        }
    }
}

