//
//  InviteFriendsViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/15/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var refferalCode: UILabel!
    @IBOutlet weak var shareBtnOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkLabel.text = "https://www.google.com"
        refferalCode.text = "402198"
        shareBtnOut.layer.cornerRadius = 5
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
    }
}
