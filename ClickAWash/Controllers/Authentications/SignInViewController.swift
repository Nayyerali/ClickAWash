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

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    static var isComingFromVendorLogin:Bool!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signInBtnOut: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
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
        
        if SignInViewController.isComingFromVendorLogin == true {
            
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                
                if error == nil {
                    
                    ServerCommunication.sharedReference.fetchUserData(userID: Auth.auth().currentUser!.uid) { (status, message, user) in
                        
                        if status {
                            User.userReference = user
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
                            self.performSegue(withIdentifier: "Identifier", sender: nil)
                            
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
        }
    }
    
    @IBAction func signInWithFacebookBtn(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    Alerts.showAlert(controller: self, title: "Error", message: error.localizedDescription) { (Ok) in
                    }
                    return
                    //                           print("Login error: \(error.localizedDescription)")
                    //                           let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    //                           let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    //                           alertController.addAction(okayAction)
                    //                           self.present(alertController, animated: true, completion: nil)
                    //                           return
                }else {
                    self.currentUserName()
                    // MARK: Have to manage user Reference
                    //User.userReference = user
                    self.performSegue(withIdentifier: "Identifier", sender: nil)
                }
            })
        }
    }
    
    func currentUserName()  {
        if let currentUser = Auth.auth().currentUser {
            
            print(currentUser.displayName!)
        }
    }
    
    @IBAction func signInWithGoogleBtn(_ sender: Any) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {return}
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil {
                // Main Functionality
                // MARK: Have to manage user Reference
                //User.userReference = user
                self.performSegue(withIdentifier: "Identifier", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Identifier" {
            _ = segue.destination as! LocationViewController
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //
    }
}
