//
//  MyJobsController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class MyJobsController: UIViewController {

    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var doneContainerView: UIView!
    @IBOutlet weak var ongoingContainerView: UIView!
    @IBOutlet weak var todoContainerView: UIView!
    @IBOutlet weak var requestsContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedController.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentedControllerChanged(_ sender: Any) {
        
        switch segmentedController.selectedSegmentIndex {

        case 1:
            requestsContainerView.alpha =   0
            ongoingContainerView.alpha  =   1
            todoContainerView.alpha     =   0
            doneContainerView.alpha     =   0
        case 2:
            requestsContainerView.alpha =   0
            ongoingContainerView.alpha  =   0
            todoContainerView.alpha     =   1
            doneContainerView.alpha     =   0
        case 3:
            requestsContainerView.alpha =   0
            ongoingContainerView.alpha  =   0
            todoContainerView.alpha     =   0
            doneContainerView.alpha     =   1
        default:
            requestsContainerView.alpha =   1
            ongoingContainerView.alpha  =   0
            todoContainerView.alpha     =   0
            doneContainerView.alpha     =   0
        }
    }
}
