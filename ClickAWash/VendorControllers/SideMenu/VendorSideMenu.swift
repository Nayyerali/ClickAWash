//
//  VendorSideMenu.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SideMenu
import SDWebImage
import FirebaseAuth

class VendorSideMenu: UITableViewController {
    
    static var comingDirectlyAsAlreadyLoggedInUser:Bool!
    
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
        
        if let url = URL(string: Worker.workerReference.imageURL) {
            self.workerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 0:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "ProfileViewController", sender: nil)
            
        case 1:
            //self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "ToJob", sender: nil)
            
        case 2:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "CompanyProfileViewController", sender: nil)
            
        case 3:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "VendorNotificationsController", sender: nil)
            
        case 4:
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "WorkerSettings", sender: nil)
            
        case 5:
            
            if VendorSideMenu.comingDirectlyAsAlreadyLoggedInUser == true {
                
                Alerts.showLogOutAlert(controller: self, title: "Logout", message: "Are you sure you want to logout", actiontitle: "Logout") { (okBtnPressed) in
                    
                    if okBtnPressed {
                        
                        let firebaseAuth = Auth.auth()
                        
                        do {
                            try firebaseAuth.signOut()
                            Worker.workerReference = nil
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let signUpViewController = storyboard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
                            let nav = UINavigationController(rootViewController: signUpViewController)
                            nav.navigationItem.backBarButtonItem?.tintColor = UIColor.black
                            UIApplication.shared.keyWindow?.rootViewController = nav
                            
                        } catch let signOutError as NSError {
                            
                            print ("Error signing out: %@", signOutError)
                        }
                        
                    } else {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                
                Alerts.showLogOutAlert(controller: self, title: "Logout", message: "Are you sure you want to logout", actiontitle: "Logout") { (okBtnPressed) in
                    
                    if okBtnPressed {
                        
                        let firebaseAuth = Auth.auth()
                        
                        do {
                            try firebaseAuth.signOut()
                            Worker.workerReference = nil
                            self.performSegue(withIdentifier: "unwindToSignUpFromWorker", sender: self)
                            
                        } catch let signOutError as NSError {
                            
                            print ("Error signing out: %@", signOutError)
                        }
                        
                    } else {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        default: break
            
        }
    }
}


