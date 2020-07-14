//
//  ProfileViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var workerEmail: UILabel!
    @IBOutlet weak var workerPhoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workerImage.roundedImage()
        settingUpWorkerProfile()
    }
    
    func settingUpWorkerProfile() {
        
        workerName.text             =   Worker.workerReference.workerName
        workerEmail.text            =   Worker.workerReference.workerEmail
        workerPhoneNumber.text      =   Worker.workerReference.phoneNumber
        
        if let url = URL(string: Worker.workerReference.imageURL) {
            workerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
    }
}
