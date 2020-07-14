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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoginAsWorker = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    @IBAction func signInAsVendor(_ sender: Any) {
        
        LoginAsWorker = true
        performSegue(withIdentifier: "LogInOptionsViewController", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "LogInOptionsViewController" {
            let destination = segue.destination as! SignInViewController
            destination.isComingFromWorkerLogin = LoginAsWorker
        }
    }
}
