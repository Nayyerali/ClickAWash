//
//  Packages.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation

struct Packages {
    
    var packageName             :   String
    var packageDescription      :   String
    var packagePrice            :   String
    
    init (packageName:String, packageDescription:String, packagePrice:String){
        
        self.packageName        =   packageName
        self.packageDescription =   packageDescription
        self.packagePrice       =   packagePrice
    }
    
    init (packageDict:[String:Any]) {
        self.packageName        =   packageDict[FirebaseKeys.PackageName.rawValue] as! String
        self.packageDescription =   packageDict[FirebaseKeys.PackageDescription.rawValue] as! String
        self.packagePrice       =   packageDict[FirebaseKeys.PackagePrice.rawValue] as! String
    }
    
    enum FirebaseKeys:String {
        case PackageName        =   "PackageName"
        case PackageDescription =   "PackageDescription"
        case PackagePrice       =   "PackagePrice"
    }
    
    func packageDictionary()->[String:Any] {
        return [
            FirebaseKeys.PackageName.rawValue:self.packageName,
            FirebaseKeys.PackageDescription.rawValue:self.packageDescription,
            FirebaseKeys.PackagePrice.rawValue:self.packagePrice]
    }
}
