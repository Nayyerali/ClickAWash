//
//  ChangePassword.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/19/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChangePassword: UIViewController {
    
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var changePasswordBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func changePasswordBtn(_ sender: Any) {
        
        changePasswordBtnOut.isEnabled = false
        
        if currentPasswordField.text == "" || newPasswordField.text == "" || confirmPasswordField.text == "" {
            Alerts.showAlert(controller: self, title: "Error", message: "Please Fill All Fields") { (OK) in
                self.changePasswordBtnOut.isEnabled = true
            }
            return
        } else if newPasswordField.text != confirmPasswordField.text {
            Alerts.showAlert(controller: self, title: "Error", message: "New Password & Confirm Password Does Not Match") { (OK) in
                self.changePasswordBtnOut.isEnabled = true
            }
            return
        } else if EmailAndPasswordValidation.isPasswordValid(newPasswordField.text!) == false {
            Alerts.showAlert(controller: self, title: "Error", message: "Please make sure your password is at least 8 characters long containing special character and a number.") { (Ok) in
                self.changePasswordBtnOut.isEnabled = true
            }
            return
        } else {
            changePassword(email: (Auth.auth().currentUser?.email)!, currentPassword: currentPasswordField.text!, newPassword: newPasswordField.text!) { (error) in
                if error == nil {
                    Alerts.showAlert(controller: self, title: "Success", message: "Password Changed Successfully") { (Ok) in
                        Alerts.showAlert(controller: self, title: "Confirmation", message: "Please Login With Updated Password") { (Ok) in
                            
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                // User.userSharefReference = nil
                                self.navigationController?.navigationController?.popToRootViewController(animated: true)
                            } catch let signOutError as NSError {
                                print ("Error signing out: %@", signOutError)
                            }
                        }
                    }
                } else {
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                        self.changePasswordBtnOut.isEnabled = true
                    }
                    return
                }
            }
        }
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if let error = error {
                completion(error)
            } else {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    completion(error)
                })
            }
        })
    }
}
