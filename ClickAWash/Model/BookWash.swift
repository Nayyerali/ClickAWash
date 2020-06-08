//
//  BookWash.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/24/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation

struct BookWash {
    
    var packageName             :   String
    var packageDescription      :   String
    var packageDetails          :   String
    var packagePrice            :   String
    var bookingTime             :   String
    var bookingDate             :   String
    var bookingStatus           :   String
    var discountCode            :   String
    var shopName                :   String
    var userId                  :   String
    var userName                :   String
    var userImage               :   String
    
    init (packageName:String, packageDescription:String, packageDetails:String, packagePrice:String, bookingTime:String, bookingDate:String, bookingStatus:String, discountCode:String, userId:String, shopName:String, userName:String, userImage:String){
        
        self.packageName           =   packageName
        self.packageDescription    =   packageDescription
        self.packageDetails        =   packageDetails
        self.packagePrice          =   packagePrice
        self.bookingTime           =   bookingTime
        self.bookingDate           =   bookingDate
        self.bookingStatus         =   bookingStatus
        self.discountCode          =   discountCode
        self.userId                =   userId
        self.shopName              =   shopName
        self.userName              =   userName
        self.userImage             =   userImage
    }
    
    init (packageDict:[String:Any]) {
        
        self.packageName           =   packageDict[FirebaseKeys.PackageName.rawValue] as! String
        self.packageDescription    =   packageDict[FirebaseKeys.PckageDescription.rawValue] as! String
        self.packageDetails        =   packageDict[FirebaseKeys.PackageDetails.rawValue] as! String
        self.packagePrice          =   packageDict[FirebaseKeys.PackagePrice.rawValue] as! String
        self.bookingTime           =   packageDict[FirebaseKeys.BookingTime.rawValue] as! String
        self.bookingDate           =   packageDict[FirebaseKeys.BookingDate.rawValue] as! String
        self.bookingStatus         =   packageDict[FirebaseKeys.BookingStatus.rawValue] as! String
        self.discountCode          =   packageDict[FirebaseKeys.DiscountCode.rawValue] as! String
        self.userId                =   packageDict[FirebaseKeys.UserId.rawValue] as! String
        self.shopName              =   packageDict[FirebaseKeys.ShopName.rawValue] as! String
        self.userName              =   packageDict[FirebaseKeys.UserName.rawValue] as! String
        self.userImage             =   packageDict[FirebaseKeys.UserImage.rawValue] as! String
    }
    
    enum FirebaseKeys:String {
        
        case PackageName           =   "PackageName"
        case PckageDescription     =   "PckageDescription"
        case PackageDetails        =   "PackageDetails"
        case PackagePrice          =   "PackagePrice"
        case BookingTime           =   "BookingTime"
        case BookingDate           =   "BookingDate"
        case BookingStatus         =   "BookingStatus"
        case DiscountCode          =   "DiscountCode"
        case UserId                =   "UserId"
        case ShopName              =   "ShopName"
        case UserName              =   "UserName"
        case UserImage             =   "UserImage"
    }
    
    func packageDictionary()->[String:Any] {
        
        return [
            FirebaseKeys.PackageName.rawValue:self.packageName,
            FirebaseKeys.PckageDescription.rawValue:self.packageDescription,
            FirebaseKeys.PackageDetails.rawValue:self.packageDetails,
            FirebaseKeys.PackagePrice.rawValue:self.packagePrice,
            FirebaseKeys.BookingTime.rawValue:self.bookingTime,
            FirebaseKeys.BookingDate.rawValue:self.bookingDate,
            FirebaseKeys.BookingStatus.rawValue:self.bookingStatus,
            FirebaseKeys.DiscountCode.rawValue:self.discountCode,
            FirebaseKeys.ShopName.rawValue:self.shopName,
            FirebaseKeys.UserName.rawValue:self.userName,
            FirebaseKeys.UserImage.rawValue:self.userImage,
            FirebaseKeys.UserId.rawValue:self.userId]
    }
}
