//
//  LogInOptionsViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/31/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class LogInOptionsViewController: UIViewController {

    var LoginAsWorker = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInAsVendor(_ sender: Any) {
        
        performSegue(withIdentifier: "LogInOptionsViewController", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "LogInOptionsViewController" {
            let _ = segue.destination as! SignInViewController
            SignInViewController.isComingFromWorkerLogin = LoginAsWorker
        }
    }
}
