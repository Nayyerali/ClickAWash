//
//  User.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation

struct User {
    
    static var userReference:User!
    
    var userName        :   String
    var email           :   String
    var referralCode    :   String
    var location        :   String
    var userId          :   String
    var imageURL        :   String
    
    init(userName:String, email:String, referralCode:String, location:String, userId:String, imageURL:String) {
        
        self.userName       =   userName
        self.email          =   email
        self.referralCode   =   referralCode
        self.location       =   location
        self.userId         =   userId
        self.imageURL       =   imageURL
    }
    
    init (userDict:[String:Any]) {
        
        self.userName       =   userDict[FirebaseKeys.UserName.rawValue] as! String
        self.email          =   userDict[FirebaseKeys.Email.rawValue] as! String
        self.referralCode   =   userDict[FirebaseKeys.referralCode.rawValue] as! String
        self.location       =   userDict[FirebaseKeys.location.rawValue] as! String
        self.userId         =   userDict[FirebaseKeys.userId.rawValue] as! String
        self.imageURL       =   userDict[FirebaseKeys.imageURL.rawValue] as! String
    }
    
    enum FirebaseKeys:String {
        
        case UserName       =   "UserName"
        case Email          =   "Email"
        case referralCode   =   "ReferralCode"
        case location       =   "Location"
        case userId         =   "UserId"
        case imageURL       =   "ImageURL"
    }
    
    func userDictionary()->[String:Any] {
        
        return [
            FirebaseKeys.UserName.rawValue:self.userName,
            FirebaseKeys.Email.rawValue:self.email,
            FirebaseKeys.referralCode.rawValue:self.referralCode,
            FirebaseKeys.location.rawValue:self.location,
            FirebaseKeys.userId.rawValue:self.userId,
            FirebaseKeys.imageURL.rawValue:self.imageURL]
    }
}
