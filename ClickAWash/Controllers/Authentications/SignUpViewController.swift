//
//  SignUpViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/9/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var tempVariable = false
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var referralCodeField: UITextField!
    @IBOutlet weak var signUpBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.roundedImage()
        addGesture()
        addObservsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @IBAction func unwindToSignUpFromCustomer(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func unwindToSignUpFromWorker(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        signUpBtnOut.isEnabled = false
        
        if userNameField.text == "" || emailField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
            Alerts.showAlert(controller: self, title: "Fields Error", message: "Please fill all fields") { (Ok) in
                self.signUpBtnOut.isEnabled = true
            }
            return
            
        } else if passwordField.text != confirmPasswordField.text {
            Alerts.showAlert(controller: self, title: "Password Error", message: "Passwords Does Not Match") { (Ok) in
                self.signUpBtnOut.isEnabled = true
            }
            return
        } else if EmailAndPasswordValidation.isEmailValid(emailField.text!) == false {
            Alerts.showAlert(controller: self, title: "Email Error", message: "Email is not typed correctly") { (Ok) in
                self.signUpBtnOut.isEnabled = true
            }
            return
        } else if EmailAndPasswordValidation.isPasswordValid(passwordField.text!) == false {
            Alerts.showAlert(controller: self, title: "Password Error", message: "Please make sure your password is at least 8 characters long containing special character and a number.") { (Ok) in
                self.signUpBtnOut.isEnabled = true
            }
            return
        }
        
        CustomLoader.instance.showLoaderView()
        
        if tempVariable {
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                
                if error == nil {
                    
                    print ("User Created with ID \(authResult!.user.uid)")
                    
                    ServerCommunication.sharedReference.uploadWorkerImage(image: self.userImage.image!, workerId: (authResult?.user.uid)!) { (status, response) in
                        
                        if status {
                            let newUser = Worker(workerName: self.userNameField.text!, workerEmail: self.emailField.text!, referralCode: self.referralCodeField.text!, location: "", workerId: (authResult?.user.uid)!, imageURL: response, workerShop: "My Shop", phoneNumber: "")
                            
                            Worker.workerReference = newUser
                            
                            ServerCommunication.sharedReference.uploadWorkerData(workerData: newUser.workerDictionary()) { (status, message) in
                                
                                if status {
                                    CustomLoader.instance.hideLoaderView()
                                    self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                                } else {
                                    self.signUpBtnOut.isEnabled = true
                                    CustomLoader.instance.hideLoaderView()
                                    Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                                        
                                    }
                                }
                            }
                        } else {
                            CustomLoader.instance.hideLoaderView()
                            self.signUpBtnOut.isEnabled = true
                            Alerts.showAlert(controller: self, title: "Error", message: response) { (Ok) in
                            }
                            return
                        }
                    }
                } else {
                    
                    CustomLoader.instance.hideLoaderView()
                    self.signUpBtnOut.isEnabled = true
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                    }
                    return
                    print(error!.localizedDescription)
                }
            }
        } else {
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
                
                if error == nil {
                    
                    print ("User Created with ID \(authResult!.user.uid)")
                    
                    ServerCommunication.sharedReference.uploadImage(image: self.userImage.image!, userId: (authResult?.user.uid)!) { (status, response) in
                        
                        if status {
                            let newUser = User(userName: self.userNameField.text!, email: self.emailField.text!, referralCode: self.referralCodeField.text!, location: "", userId: (authResult?.user.uid)!, imageURL: response)
                            
                            User.userReference = newUser
                            
                            ServerCommunication.sharedReference.uploadUserData(userData: newUser.userDictionary()) { (status, message) in
                                
                                if status {
                                    CustomLoader.instance.hideLoaderView()
                                    self.performSegue(withIdentifier: "HomeViewController", sender: nil)
                                } else {
                                    self.signUpBtnOut.isEnabled = true
                                    CustomLoader.instance.hideLoaderView()
                                    Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                                        
                                    }
                                }
                            }
                        } else {
                            CustomLoader.instance.hideLoaderView()
                            self.signUpBtnOut.isEnabled = true
                            Alerts.showAlert(controller: self, title: "Error", message: response) { (Ok) in
                            }
                            return
                        }
                    }
                } else {
                    CustomLoader.instance.hideLoaderView()
                    self.signUpBtnOut.isEnabled = true
                    Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (Ok) in
                                       }
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeViewController" {
            _ = segue.destination as! HomeViewController
        }
    }
    
    func addObservsers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOpen(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardClosed), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardClosed(){
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardOpen(notification:Notification){
        
        _ = getKeyboardHeight(notification: notification)
        
        self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
    }
    
    func getKeyboardHeight(notification:Notification)->CGFloat{
        let info = notification.userInfo
        let keyboardFrame = info![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrame.cgRectValue.size.height
    }
    
    func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        userImage.addGestureRecognizer(gesture)
        userImage.isUserInteractionEnabled = true
    }
    
    @objc func userImageTapped(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (ok) in
            // Camera option tapped
            self.presentImagePicker(type: .camera)
            self.modalPresentationStyle = .fullScreen
        }
        
        let photoGallery = UIAlertAction(title: "Gallery", style: .default) { (gallery) in
            // Gallery option tapped
            self.presentImagePicker(type: .photoLibrary)
            self.modalPresentationStyle = .fullScreen
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            // Cancel Tapped
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoGallery)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func presentImagePicker(type:UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .overFullScreen
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.userImage.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
