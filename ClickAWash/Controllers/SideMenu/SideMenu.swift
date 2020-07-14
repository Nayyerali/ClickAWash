//
//  ViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/16/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage
import FBSDKLoginKit
import SideMenu

class SideMenu: UITableViewController{
    
    static var isComingFromSocialMediaPlatforms:Bool!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmailAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingUserData()
        userImage.roundedImage()
    }
    
    func fetchingUserData() {
        
        if SideMenu.isComingFromSocialMediaPlatforms == true {
            
            updateUserProfile()
            
        } else {
            
            ServerCommunication.sharedReference.fetchUserData(userID: Auth.auth().currentUser!.uid) { (status, message, userData) in
                
                if status {
                    User.userReference = userData!
                    self.updateUserProfile()
                } else {
                    Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                        
                    }
                }
            }
        }
    }
    
    func updateUserProfile() {
        
        username.text           =   User.userReference.userName
        userEmailAddress.text   =   User.userReference.email
        
        if let url = URL(string: User.userReference.imageURL) {
            
            self.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 1:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "ToHome", sender: nil)
            
        case 2:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "MyBookingsViewController", sender: nil)
            
        case 3:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "RateApplicationViewController", sender: nil)
            
        case 4:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "InviteFriendsViewController", sender: nil)
            
        case 5:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "WalletViewController", sender: nil)
            
        case 6:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "NotificationsViewController", sender: nil)
            
        case 7:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "SubscriptionsViewController", sender: nil)
            
        case 8:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "SettingsViewController", sender: nil)
            
        case 9:
            Alerts.showLogOutAlert(controller: self, title: "Logout", message: "Are you sure you want to logout", actiontitle: "Logout") { (okBtnPressed) in
                
                if okBtnPressed {
                    
                    let firebaseAuth = Auth.auth()
                    
                    do {
                        try firebaseAuth.signOut()
                        User.userReference = nil
                        self.dismiss(animated: false, completion: nil)
                        self.performSegue(withIdentifier: "ToSignUpFromCustomer", sender: self)
                        
                    } catch let signOutError as NSError {
                        
                        print ("Error signing out: %@", signOutError)
                    }
                    
                } else {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        default: break
            
        }
    }
}
