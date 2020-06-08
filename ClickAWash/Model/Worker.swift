//
//  Worker.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation

struct Worker {
    
    static var workerReference:Worker!
    
    var workerName    :   String
    var workerEmail   :   String
    var referralCode  :   String
    var location      :   String
    var workerId      :   String
    var imageURL      :   String
    var workerShop    :   String
    
    init(workerName:String, workerEmail:String, referralCode:String, location:String, workerId:String, imageURL:String, workerShop:String) {
        
        self.workerName     =   workerName
        self.workerEmail    =   workerEmail
        self.referralCode   =   referralCode
        self.location       =   location
        self.workerId       =   workerId
        self.imageURL       =   imageURL
        self.workerShop     =   workerShop
    }
    
    init (workerDict:[String:Any]) {
        
        self.workerName     =   workerDict[FirebaseKeys.WorkerName.rawValue] as! String
        self.workerEmail    =   workerDict[FirebaseKeys.WorkerEmail.rawValue] as! String
        self.referralCode   =   workerDict[FirebaseKeys.referralCode.rawValue] as! String
        self.location       =   workerDict[FirebaseKeys.location.rawValue] as! String
        self.workerId       =   workerDict[FirebaseKeys.WorkerId.rawValue] as! String
        self.imageURL       =   workerDict[FirebaseKeys.ImageURL.rawValue] as! String
        self.workerShop    =   workerDict[FirebaseKeys.WorkerShop.rawValue] as! String
    }
    
    enum FirebaseKeys:String {
        
        case WorkerName     =   "WorkerName"
        case WorkerEmail    =   "WorkerEmail"
        case referralCode   =   "ReferralCode"
        case location       =   "Location"
        case WorkerId       =   "WorkerId"
        case ImageURL       =   "ImageURL"
        case WorkerShop     =   "WorkerShop"
    }
    
    func workerDictionary()->[String:Any] {
        
        return [
            FirebaseKeys.WorkerName.rawValue:self.workerName,
            FirebaseKeys.WorkerEmail.rawValue:self.workerEmail,
            FirebaseKeys.referralCode.rawValue:self.referralCode,
            FirebaseKeys.location.rawValue:self.location,
            FirebaseKeys.WorkerId.rawValue:self.workerId,
            FirebaseKeys.WorkerShop.rawValue:self.workerShop,
            FirebaseKeys.ImageURL.rawValue:self.imageURL]
    }
}
