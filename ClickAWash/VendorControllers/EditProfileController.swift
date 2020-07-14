//
//  EditProfileController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class EditProfileController: UIViewController {
    
    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var saveBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workerImage.roundedImage()
        settingUpWorkerProfile()
        addGesture()
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        CustomLoader.instance.showLoaderView()
        
        ServerCommunication.sharedReference.uploadWorkerImage(image: workerImage.image!, workerId: Worker.workerReference.workerId) { (status, imageUrlFromResponse) in
            
            if status {
                
                ServerCommunication.sharedReference.firebaseFiretore.collection("Workers").document(Worker.workerReference.workerId).updateData(["ImageURL":imageUrlFromResponse, "WorkerName":self.nameField.text!, "WorkerPhoneNumber":self.phoneNumberField.text!]) { (error) in
                    
                    if error == nil {
                        
                        CustomLoader.instance.hideLoaderView()
                        Alerts.showAlert(controller: self, title: "Profile Updated", message: "Profile is updated with new details") { (ok) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    } else {
                        CustomLoader.instance.hideLoaderView()
                        Alerts.showAlert(controller: self, title: "Error", message: error!.localizedDescription) { (ok) in
                            
                        }
                        return
                    }
                }
            } else {
                
                CustomLoader.instance.hideLoaderView()
                Alerts.showAlert(controller: self, title: "Error", message: imageUrlFromResponse) { (Ok) in
                    
                }
                return
            }
        }
    }
    
    func settingUpWorkerProfile() {
        
        nameField.text             =   Worker.workerReference.workerName
        phoneNumberField.text      =   Worker.workerReference.phoneNumber
        
        if let url = URL(string: Worker.workerReference.imageURL) {
            
            workerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
    }
    
    func addGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        workerImage.addGestureRecognizer(gesture)
        workerImage.isUserInteractionEnabled = true
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

extension EditProfileController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.workerImage.image = image
        self.dismiss(animated: true, completion: nil)
    }
}
