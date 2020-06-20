//
//  SignInViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import RESideMenu

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    static var isComingFromWorkerLogin:Bool!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signInBtnOut: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var facebookBtnOutlet: UIButton!
    @IBOutlet weak var googleBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text     =   "nayyerali777@yahoo.com"
        passwordField.text  =   "N@yyer@l!777"
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if SignInViewController.isComingFromWorkerLogin == true {
            facebookBtnOutlet.alpha  =  0
            googleBtnOutlet.alpha    =  0
            
        } else {
            
            facebookBtnOutlet.alpha  =  1
            googleBtnOutlet.alpha    =  1
        }
    }
    
    
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        
        
        
    }
    
    @IBAction func signInWithEmailBtn(_ sender: Any) {
        
        signInBtnOut.isEnabled = false
        
        if emailField.text == "" || passwordField.text == "" {
            Alerts.showAlert(controller: self, title: "Fields Error", message: "Please fill all fields") { (Ok) in
                self.signInBtnOut.isEnabled = true
            }
            return
            
        } else if EmailAndPasswordValidation.isEmailValid(emailField.text!) == false {
            Alerts.showAlert(controller: self, title: "Email Error", message: "Email is not typed correctly") { (Ok) in
                self.signInBtnOut.isEnabled = true
            }
            return
        }
        
        CustomLoader.instance.showLoaderView()
        
        if SignInViewController.isComingFromWorkerLogin == true {
            
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                
                if error == nil {
                    
                    ServerCommunication.sharedReference.fetchWorkerData(workerID: Auth.auth().currentUser!.uid) { (status, message, worker) in
                        
                        if status {
                            Worker.workerReference = worker
                            CustomLoader.instance.hideLoaderView()
                            let destinationStoryBoard   =   UIStoryboard(name: "Vendor", bundle: nil)
                            let destinationController   =   destinationStoryBoard.instantiateViewController(identifier: "MyJobsController") as! MyJobsController
                            self.navigationController?.pushViewController(destinationController, animated: true)
                            
                        } else {
                            CustomLoader.instance.hideLoaderView()
                            self.signInBtnOut.isEnabled = true
                            Alerts.showAlert(controller: self, title: "Error", message: "Unable to Sign in") { (Ok) in
                                
                            }
                        }
                    }
                } else {
                    
                    CustomLoader.instance.hideLoaderView()
                    self.signInBtnOut.isEnabled = true
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                        
                    }
                    return
                }
            }
        } else {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                
                if error == nil {
                    
                    ServerCommunication.sharedReference.fetchUserData(userID: Auth.auth().currentUser!.uid) { (status, message, user) in
                        
                        if status {
                            User.userReference = user
                            CustomLoader.instance.hideLoaderView()
                            self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                            
                        } else {
                            CustomLoader.instance.hideLoaderView()
                            self.signInBtnOut.isEnabled = true
                            Alerts.showAlert(controller: self, title: "Error", message: "Unable to Sign in") { (Ok) in

                            }
                        }
                    }
                } else {
                    
                    CustomLoader.instance.hideLoaderView()
                    self.signInBtnOut.isEnabled = true
                    
                    let castedError = error! as NSError
                    let firebaseError = AuthErrorCode(rawValue: castedError.code)
            
                    if firebaseError != nil {
                        
                        Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in

                        }
                        return
                    }
                    
                }
            }
        }
    }
    
    @IBAction func signInWithFacebookBtn(_ sender: Any) {
        
        CustomLoader.instance.showLoaderView()
        
        let loginManager = LoginManager()
        
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                
                CustomLoader.instance.hideLoaderView()
                Alerts.showAlert(controller: self, title: "Error", message: error.localizedDescription) { (Ok) in
                    
                }
                return
                
            } else {
                
                let loginResult = result
                
                if (result?.isCancelled)! {
                    
                    CustomLoader.instance.hideLoaderView()
                    Alerts.showAlert(controller: self, title: "Cancled", message: "User cancled login operation") { (Ok) in
                        
                    }
                    return
                    
                } else if (loginResult?.grantedPermissions.contains("email"))! {
                    
                    self.signInWithReceivedFacebookUserData()
                    
                } else {
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                        
                    }
                    return
                }
            }
        }
    }
    
    func signInWithReceivedFacebookUserData(){
        
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil){
                    
                    let resultData = result as! [String: Any]
                    var userProfileImageURL:String!
                    
                    let userName        =   resultData["name"] as! String
                    let userImage       =   resultData["picture"] as! [String:Any]
                    let image           =   userImage["data"] as! [String:Any]
                    let userEmail       =   resultData["email"] as! String
                    let userId          =   resultData["id"] as! String
                    
                    image.filter { (key: String, value: Any) -> Bool in
                        
                        if key == "url" {
                            
                            userProfileImageURL = (value as! String)
                        }
                        return true
                    }
                    
                    var facebookUser = User(userName: userName, email: userEmail, referralCode: "", location: "", userId: userId, imageURL: userProfileImageURL)
                    
                    //User.userReference  =   facebookUser
                    
                    guard let accessToken = AccessToken.current else {
                        
                        Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                            
                        }
                        print("Failed to get access token")
                        return
                    }
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    
                    // Perform login by calling Firebase APIs
                    
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        
                        if let error = error {
                            
                            CustomLoader.instance.hideLoaderView()
                            Alerts.showAlert(controller: self, title: "Error", message: error.localizedDescription) { (Ok) in
                                
                            }
                            
                            return
                            
                        } else {
                            User.userReference = facebookUser
                            CustomLoader.instance.hideLoaderView()
                            SideMenu.isComingFromSocialMediaPlatforms = true
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let controller = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {return}
                            let leftMenuController = storyboard.instantiateViewController(withIdentifier: "SideMenu")
                            let navController = BaseNavigationController(rootViewController: controller)
                            let sideMenuController = RESideMenu(contentViewController: navController, leftMenuViewController: leftMenuController, rightMenuViewController: nil)
                            self.navigationController?.pushViewController(sideMenuController!, animated: true)
                            //self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func signInWithGoogleBtn(_ sender: Any) {
        
        CustomLoader.instance.showLoaderView()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            
            CustomLoader.instance.hideLoaderView()
            Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                
            }
            return
            
        } else {
            
            guard let authentication = user.authentication else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                
                if error == nil {
                    // Main Functionality
                    // MARK: Have to manage user Reference
                    
                    let newUser = User(userName: user.profile.name, email: user.profile.email, referralCode: "", location: "", userId: user.userID, imageURL: "\(user.profile.imageURL(withDimension: .max)!)")
                    
                    User.userReference = newUser
                    CustomLoader.instance.hideLoaderView()
                    SideMenu.isComingFromSocialMediaPlatforms = true
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let controller = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {return}
                    let leftMenuController = storyboard.instantiateViewController(withIdentifier: "SideMenu")
                    let navController = BaseNavigationController(rootViewController: controller)
                    let sideMenuController = RESideMenu(contentViewController: navController, leftMenuViewController: leftMenuController, rightMenuViewController: nil)
                    self.navigationController?.pushViewController(sideMenuController!, animated: true)
                } else {
                    
                    CustomLoader.instance.hideLoaderView()
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                    }
                    return
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeViewController" {
            _ = segue.destination as! HomeViewController
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //
    }
}
