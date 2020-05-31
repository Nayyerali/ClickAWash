//
//  BaseNavigationController.swift
//  The Court Lawyer
//
//  Created by Ahmed Shahid on 5/3/18.
//  Copyright © 2018 Ahmed Shahid. All rights reserved.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationBar.barTintColor         = .white
        self.navigationBar.shadowImage          = UIImage()
        self.navigationBar.tintColor            = UIColor.black
        self.navigationBar.titleTextAttributes  = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.navigationBar.isTranslucent        = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
