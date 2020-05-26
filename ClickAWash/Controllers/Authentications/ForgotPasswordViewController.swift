//
//  ForgotPasswordViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/19/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendPasswordRequestBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sendPasswordRequest(_ sender: Any) {
        
        sendPasswordRequestBtn.isEnabled = false
        
        if emailField.text == "" {
            Alerts.showAlert(controller: self, title: "Error", message: "Please Enter Your Email") { (Ok) in
                self.sendPasswordRequestBtn.isEnabled = true
                
            }
            return
        } else if EmailAndPasswordValidation.isEmailValid(emailField.text!) == false {
            Alerts.showAlert(controller: self, title: "Email Error", message: "Email is not typed correctly") { (Ok) in
                self.sendPasswordRequestBtn.isEnabled = true
            }
            return
        } else {
            Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
                if error == nil {
                    Alerts.showAlert(controller: self, title: "Email Sent", message: "Password recovery email is sent to your Email Address") { (ok) in
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                        
                    }
                }
            }
        }
    }
}
