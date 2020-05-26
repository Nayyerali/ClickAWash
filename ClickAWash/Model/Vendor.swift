//
//  Vendor.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/15/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation

struct Vendor {
    
    var name        :   String
    var subText     :   String
    var email       :   String
    var phoneNumber :   String
    var location    :   String
    var timings     :   String
    var vendorId    :   String
    
    init (name:String, subText:String, email:String, phoneNumber:String, location:String, timings:String, vendorId:String){
        
        self.name           =   name
        self.subText        =   subText
        self.email          =   email
        self.phoneNumber    =   phoneNumber
        self.location       =   location
        self.timings        =   timings
        self.vendorId       =   vendorId
    }
    
    init (vendorDict:[String:Any]) {
        
        self.name           =   vendorDict[FirebaseKeys.Name.rawValue] as! String
        self.subText        =   vendorDict[FirebaseKeys.SubText.rawValue] as! String
        self.email          =   vendorDict[FirebaseKeys.Email.rawValue] as! String
        self.phoneNumber    =   vendorDict[FirebaseKeys.PhoneNumber.rawValue] as! String
        self.location       =   vendorDict[FirebaseKeys.Location.rawValue] as! String
        self.timings        =   vendorDict[FirebaseKeys.Timings.rawValue] as! String
        self.vendorId       =   vendorDict[FirebaseKeys.VendorId.rawValue] as! String
    }
    
    enum FirebaseKeys:String {
        
        case Name           =   "Name"
        case SubText        =   "Subtext"
        case Email          =   "Email"
        case PhoneNumber    =   "PhoneNumber"
        case Location       =   "Location"
        case Timings        =   "Timings"
        case VendorId       =   "VendorId"
    }
    
    func vendorDictionary()->[String:Any] {
        
        return [
            FirebaseKeys.Name.rawValue:self.name,
            FirebaseKeys.SubText.rawValue:self.subText,
            FirebaseKeys.Email.rawValue:self.email,
            FirebaseKeys.PhoneNumber.rawValue:self.phoneNumber,
            FirebaseKeys.Location.rawValue:self.location,
            FirebaseKeys.Timings.rawValue:self.timings,
            FirebaseKeys.VendorId.rawValue:self.vendorId]
    }
}
