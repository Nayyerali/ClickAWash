//
//  TermsAndConditions.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/19/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class TermsAndConditions: UIViewController {

    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termsAndConditionsTextView.isEditable = false
        termsAndConditionsTextView.text = "These are terms and conditions for using this applciation"
    }
}
