//
//  MyBookingsViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/21/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Firebase

class MyBookingsViewController: UIViewController {

    @IBOutlet weak var scheduledContainerView: UIView!
    @IBOutlet weak var completedContainerView: UIView!
    @IBOutlet weak var segmentedControlOut: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControlOut.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentedControlSelected(_ sender: Any) {
        
        if segmentedControlOut.selectedSegmentIndex == 0 {
            scheduledContainerView.alpha = 1
            completedContainerView.alpha = 0
        } else {
            scheduledContainerView.alpha = 0
            completedContainerView.alpha = 1
        }
    }
}
