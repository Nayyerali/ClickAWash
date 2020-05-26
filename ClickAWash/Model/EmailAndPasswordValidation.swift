//
//  EmailAndPasswordValidation.swift
//  MyExpenditures
//
//  Created by Nayyer Ali on 5/4/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation

class EmailAndPasswordValidation {
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordFormat = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        
        return passwordPredicate.evaluate(with: password)
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: email)
    }
}
