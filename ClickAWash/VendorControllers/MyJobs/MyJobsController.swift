//
//  MyJobsController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyJobsController: UIViewController {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var bottomViewForControllers: UIView!
    
    let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Jobs"
        let child = storyBoard.instantiateViewController(identifier: "RequestsController") as! RequestsController
        self.add(child)
    }

    func add(_ child: UIViewController) {
        addChild(child)
        bottomViewForControllers.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    @IBAction func unwindToJob(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func segmentedControllerChanged(_ sender: Any) {
        
        let childControllers = self.children
        for childContoller in childControllers{
            childContoller.willMove(toParent: nil)
            childContoller.view.removeFromSuperview()
            childContoller.removeFromParent()
        }
        
        switch segmentedController.selectedSegmentIndex {
            
        case 0:
            let child = storyBoard.instantiateViewController(identifier: "RequestsController") as! RequestsController
            self.add(child)
        case 1:
            let child = storyBoard.instantiateViewController(identifier: "TodoController") as! TodoController
            self.add(child)
        case 2:
            let child = storyBoard.instantiateViewController(identifier: "OngoingController") as! OngoingController
            self.add(child)
        case 3:
            let child = storyBoard.instantiateViewController(identifier: "DoneController") as! DoneController
            self.add(child)
        default:
            break
        }
    }
}

extension MyJobsController {
    
    func add(_ child: UIViewController, _ view: UIView) {
        view.addSubview(child.view)
        addChild(child)
        child.didMove(toParent: self)
    }
    
    func remove() {
        
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
    }
}
