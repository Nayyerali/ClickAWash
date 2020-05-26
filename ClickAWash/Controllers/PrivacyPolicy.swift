//
//  PrivacyPolicy.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/19/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class PrivacyPolicy: UIViewController {

    @IBOutlet weak var privacyPolicyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        privacyPolicyTextView.isEditable = false
        privacyPolicyTextView.text = "This is privacy policy for using this application"
    }
}
