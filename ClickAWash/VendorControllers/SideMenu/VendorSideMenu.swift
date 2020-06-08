//
//  VendorSideMenu.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage
import RESideMenu
import FirebaseAuth

class VendorSideMenu: UITableViewController {
    
    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var workerEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingWorkerData()
        workerImage.roundedImage()
    }
    
    func fetchingWorkerData() {
        
        ServerCommunication.sharedReference.fetchWorkerData(workerID: Auth.auth().currentUser!.uid) { (status, message, workerData) in
            
            if status {
                Worker.workerReference = workerData!
                self.updateWorkerrProfile()
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
            }
        }
    }
    
    func updateWorkerrProfile() {
        
        workerName.text    =    Worker.workerReference.workerName
        workerEmail.text   =    Worker.workerReference.workerEmail
        
        if let url = URL(string: User.userReference.imageURL) {
            self.workerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            let storyboard = UIStoryboard.init(name: "Vendor", bundle: nil)
            let profileViewController = storyboard.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
            self.sideMenuViewController.setContentViewController(profileViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 1:
            let storyboard = UIStoryboard.init(name: "Vendor", bundle: nil)
            let myJobsController = storyboard.instantiateViewController(identifier: "MyJobsController") as! MyJobsController
            self.sideMenuViewController.setContentViewController(myJobsController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 2:
            let storyboard = UIStoryboard.init(name: "Vendor", bundle: nil)
            let companyProfileViewController = storyboard.instantiateViewController(identifier: "CompanyProfileViewController") as! CompanyProfileViewController
            self.sideMenuViewController.setContentViewController(companyProfileViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 3:
            let storyboard = UIStoryboard.init(name: "Vendor", bundle: nil)
            let vendorNotificationsController = storyboard.instantiateViewController(identifier: "VendorNotificationsController") as! VendorNotificationsController
            self.sideMenuViewController.setContentViewController(vendorNotificationsController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 4:
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let settingsViewController = storyboard.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
            self.sideMenuViewController.setContentViewController(settingsViewController, animated: true)
            self.sideMenuViewController.hideViewController()
            
        case 5:
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                User.userReference = nil
                self.navigationController?.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
        default: break
            
        }
    }
}
