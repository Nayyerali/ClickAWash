//
//  PayNowViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/19/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Stripe

class PayNowViewController: UIViewController, STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate {
    
    let cardParams = STPCardParams()
    
    @IBOutlet weak var payNowBtnOut: UIButton!
    @IBOutlet weak var addNewCardBtnOut: UIButton!
    @IBOutlet weak var topViewOut: UIView!
    @IBOutlet weak var addCardNumField: STPPaymentCardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payNowBtnOut.isEnabled = false
        topViewOut.layer.borderWidth = 2
        topViewOut.layer.borderColor = UIColor.black.cgColor
        topViewOut.layer.masksToBounds = false
        topViewOut.alpha = 0
        
    }
    
    @IBAction func addNewCardBtnPressed(_ sender: Any) {
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func payNowBtnPressed(_ sender: Any) {
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
        if let error = error {
        // show the error to the user
        print(error)
            Alerts.showAlert(controller: self, title: "Error", message: error.localizedDescription) { (OK) in
            
            }
        } else if let token = token {
        print(token)
        //Send token to backend for process
            }
        }
    }
    
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func addCardViewController(addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: STPErrorBlock) {
        
        print(token)
        //Use token for backend process
        self.dismiss(animated: true, completion: nil)
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        
        payNowBtnOut.isEnabled = true
        topViewOut.alpha = 1
        
        if payNowBtnOut.isEnabled {
            
            cardParams.number = textField.cardParams.number
        }
    }
}
