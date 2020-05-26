//
//  Alerts.swift
//  MyExpenditures
//
//  Created by Nayyer Ali on 5/4/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
    
    static func showAlert (controller:UIViewController,title:String,message:String,completion:@escaping(_ okBtnPressed:Bool)->Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            completion(true)
        }
        alertController.addAction(okAction)
        controller.present(alertController, animated: true)
    }
}
