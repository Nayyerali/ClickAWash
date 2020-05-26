//
//  AboutUs.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/19/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class AboutUs: UIViewController {

    @IBOutlet weak var aboutUsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutUsTextView.isEditable = false
        aboutUsTextView.text = "This is about us description of our application"
    }
}
