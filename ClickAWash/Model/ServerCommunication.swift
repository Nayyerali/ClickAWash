//
//  ServerCommunication.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

public class ServerCommunication {
    
    static var sharedReference = ServerCommunication()
    
    var firebaseFiretore:Firestore!
    var firebaseStorage:Storage!
    
    private init () {
        
        firebaseFiretore = Firestore.firestore()
        firebaseStorage = Storage.storage()
    }
    
    func uploadUserData(userData:[String:Any],completion:@escaping(_ status:Bool,_ message:String) -> Void) {
        
        let userId = userData["UserId"] as! String
        firebaseFiretore.collection("Users").document(userId).setData(userData) { (error) in
            
            if error == nil {
                
                completion(true, "User Data Uploaded")
                
            } else {
                
                completion(false, error!.localizedDescription)
                
            }
        }
    }
    
    func uploadWorkerData(workerData:[String:Any],completion:@escaping(_ status:Bool,_ message:String) -> Void) {
        
        let workerId = workerData["WorkerId"] as! String
        firebaseFiretore.collection("Workers").document(workerId).setData(workerData) { (error) in
            
            if error == nil {
                
                completion(true, "Worker Data Uploaded")
                
            } else {
                
                completion(false, error!.localizedDescription)
                
            }
        }
    }
    
    func scheduleWashBooking(requestSenderName:String, requestSenderImage:String, packageName:String, packageDescription:String, packageDetails:String, packagePrice:String, bookingTime:String, bookingDate:String, bookingStatus:String, discountCode:String, userId:String, shopName:String, completion:@escaping(_ status:Bool,_ message:String) -> Void) {
        
        //let washBooking = firebaseFiretore.collection("Users").document(userId).collection("WashBookings").document()
        
        let washBooking = firebaseFiretore.collection("WashBookings").document()
        
        washBooking.setData([
            "RequestSenderName"     :   requestSenderName,
            "RequestSenderImage"    :   requestSenderImage,
            "PackageName"           :   packageName,
            "PckageDescription"     :   packageDescription,
            "PackageDetails"        :   packageDetails,
            "PackagePrice"          :   packagePrice,
            "BookingTime"           :   bookingTime,
            "BookingDate"           :   bookingDate,
            "BookingStatus"         :   bookingStatus,
            "DiscountCode"          :   discountCode,
            "UserId"                :   userId,
            "ShopName"              :   shopName
            
        ]) { (error) in
            
            if error == nil {
                
                completion(true, "Wash Booking is scheduled")
                
            } else {
                
                completion(false, "Unable to schedule booking")
            }
        }
    }
    
    func fetchUserData(userID:String,completion:@escaping(_ status:Bool,_ message:String,_ user:User?) -> Void) {
        
        firebaseFiretore.collection("Users").document(userID).getDocument { (snapshot, error) in
            
            if let snapshot = snapshot {
                
                if let userDic = snapshot.data() {
                    
                    let user = User(userDict: userDic)
                    
                    completion(true, "Got User Data", user)
                    
                } else {
                    
                    completion(false, "Unableto get user data", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func fetchWorkerData(workerID:String,completion:@escaping(_ status:Bool,_ message:String,_ worker:Worker?) -> Void) {
        
        firebaseFiretore.collection("Workers").document(workerID).getDocument { (snapshot, error) in
            
            if let snapshot = snapshot {
                
                if let workerDic = snapshot.data() {
                    
                    let worker = Worker(workerDict: workerDic)
                    
                    completion(true, "Got Worker Data", worker)
                    
                } else {
                    
                    completion(false, "Unableto get worker data", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func uploadImage(image:UIImage,userId:String,completion:@escaping(_ status:Bool,_ response:String)->Void){
        // if status is true then downloadurl will be in response
        
        // Data in memory
        guard let data = image.jpegData(compressionQuality: 0.5) else{
            completion(false,"Unable to get data from image")
            return
        }
        // Create a reference to the file you want to upload
        let riversRef = firebaseStorage.reference().child("images/\(userId).jpg")
        // Upload the file to the path "images/rivers.jpg"
        let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                // Uh-oh, an error occurred!
                completion(false,error!.localizedDescription)
                return
            }
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completion(false,error!.localizedDescription)
                    return
                }
                completion(true,downloadURL.absoluteString)
            }
        }
    }
    
    func uploadWorkerImage(image:UIImage,workerId:String,completion:@escaping(_ status:Bool,_ response:String)->Void){
        // if status is true then downloadurl will be in response
        
        // Data in memory
        guard let data = image.jpegData(compressionQuality: 0.5) else{
            completion(false,"Unable to get data from image")
            return
        }
        // Create a reference to the file you want to upload
        let riversRef = firebaseStorage.reference().child("Workers images/\(workerId).jpg")
        // Upload the file to the path "images/rivers.jpg"
        let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                // Uh-oh, an error occurred!
                completion(false,error!.localizedDescription)
                return
            }
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completion(false,error!.localizedDescription)
                    return
                }
                completion(true,downloadURL.absoluteString)
            }
        }
    }
    
    func fetchUserBookings(userId:String, completion:@escaping(_ status:Bool, _ message:String, _ bookings:[BookWash]?) -> Void){
        
        //        firebaseFiretore.collection("Users").document(userId).collection("WashBookings").getDocuments { (snapshot, error) in
        
        firebaseFiretore.collection("WashBookings").whereField("UserId", isEqualTo: userId).getDocuments { (snapshot, error) in
            
            if error == nil {
                // User's Booking Data is Fetched
                if let washBookingDocuments = snapshot?.documents {
                    // Got all Documents
                    
                    var washBookings = [BookWash]()
                    
                    for documents in washBookingDocuments {
                        let washBookingsData    =   documents.data()
                        let packageName         =   washBookingsData["PackageName"] as! String
                        let packageDescription  =   washBookingsData["PckageDescription"] as! String
                        let packageDetails      =   washBookingsData["PackageDetails"] as! String
                        let packagePrice        =   washBookingsData["PackagePrice"] as! String
                        let bookingDate         =   washBookingsData["BookingDate"] as! String
                        let bookingTime         =   washBookingsData["BookingTime"] as! String
                        let bookingStatus       =   washBookingsData["BookingStatus"] as! String
                        let discoutCode         =   washBookingsData["DiscountCode"] as! String
                        let userId              =   washBookingsData["UserId"] as! String
                        let shopName            =   washBookingsData["ShopName"] as! String
                        let userName            =   washBookingsData["RequestSenderName"] as! String
                        let userImage           =   washBookingsData["RequestSenderImage"] as! String
                        
                        let userWashBooking = BookWash(packageName: packageName, packageDescription: packageDescription, packageDetails: packageDetails, packagePrice: packagePrice, bookingTime: bookingTime, bookingDate: bookingDate, bookingStatus: bookingStatus, discountCode: discoutCode, userId: userId, shopName: shopName, userName: userName, userImage: userImage)
                        
                        washBookings.append(userWashBooking)
                        
                    }
                    completion(true, "Got User Wash Bookings", washBookings)
                    
                } else {
                    
                    completion(false, "Unable to fetch User Bookings", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func fetchAllUsersBookingsForWorker(completion:@escaping(_ status:Bool, _ message:String, _ bookings:[BookWash]?) -> Void){
        
        let workerShopName      =   Worker.workerReference.workerShop
        
        firebaseFiretore.collection("WashBookings").whereField("ShopName", isEqualTo: workerShopName).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                // User's Booking Data is Fetched
                if let washBookingDocuments = snapshot?.documents {
                    
                    // Got all Documents
                    var washBookings        =   [BookWash]()
                    
                    for documents in washBookingDocuments {
                        
                        let washBookingsData    =   documents.data()
                        
                        let packageName         =   washBookingsData["PackageName"] as! String
                        let packageDescription  =   washBookingsData["PckageDescription"] as! String
                        let packageDetails      =   washBookingsData["PackageDetails"] as! String
                        let packagePrice        =   washBookingsData["PackagePrice"] as! String
                        let bookingDate         =   washBookingsData["BookingDate"] as! String
                        let bookingTime         =   washBookingsData["BookingTime"] as! String
                        let bookingStatus       =   washBookingsData["BookingStatus"] as! String
                        let discoutCode         =   washBookingsData["DiscountCode"] as! String
                        let userId              =   washBookingsData["UserId"] as! String
                        let shopName            =   washBookingsData["ShopName"] as! String
                        let userName            =   washBookingsData["RequestSenderName"] as! String
                        let userImage           =   washBookingsData["RequestSenderImage"] as! String
                        
                        let userWashBooking = BookWash(packageName: packageName, packageDescription: packageDescription, packageDetails: packageDetails, packagePrice: packagePrice, bookingTime: bookingTime, bookingDate: bookingDate, bookingStatus: bookingStatus, discountCode: discoutCode, userId: userId, shopName: shopName, userName: userName, userImage: userImage)
                        
                        washBookings.append(userWashBooking)
                    }
                    
                    completion(true, "Got Users Wash Bookings", washBookings)
                    
                } else {
                    
                    completion(false, "Unable to fetch Users Bookings", nil)
                    
                }
                
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func fetchUsersCompletedBookings(userId:String, completion:@escaping(_ status:Bool, _ message:String, _ bookings:[BookWash]?) -> Void){
        
        firebaseFiretore.collection("Users").document(userId).collection("WashBookings").getDocuments { (snapshot, error) in
            
            if error == nil {
                // User's Booking Data is Fetched
                if let washBookingDocuments = snapshot?.documents {
                    // Got all Documents
                    
                    var washBookings = [BookWash]()
                    
                    for documents in washBookingDocuments {
                        let washBookingsData    =   documents.data()
                        let packageName         =   washBookingsData["PackageName"] as! String
                        let packageDescription  =   washBookingsData["PckageDescription"] as! String
                        let packageDetails      =   washBookingsData["PackageDetails"] as! String
                        let packagePrice        =   washBookingsData["PackagePrice"] as! String
                        let bookingDate         =   washBookingsData["BookingDate"] as! String
                        let bookingTime         =   washBookingsData["BookingTime"] as! String
                        let bookingStatus       =   washBookingsData["BookingStatus"] as! String
                        let discoutCode         =   washBookingsData["DiscountCode"] as! String
                        let userId              =   washBookingsData["UserId"] as! String
                        let shopName            =   washBookingsData["ShopName"] as! String
                        let userName            =   washBookingsData["RequestSenderName"] as! String
                        let userImage           =   washBookingsData["RequestSenderImage"] as! String
                        
                        let userWashBooking = BookWash(packageName: packageName, packageDescription: packageDescription, packageDetails: packageDetails, packagePrice: packagePrice, bookingTime: bookingTime, bookingDate: bookingDate, bookingStatus: bookingStatus, discountCode: discoutCode, userId: userId, shopName: shopName, userName: userName, userImage: userImage)
                        
                        if userWashBooking.bookingStatus == "Completed" {
                            washBookings.append(userWashBooking)
                        }
                    }
                    
                    completion(true, "Got User Wash Bookings", washBookings)
                    
                } else {
                    
                    completion(false, "Unable to fetch User Bookings", nil)
                    
                }
                
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func fetchVendorsData (completion:@escaping(_ status:Bool, _ message:String, _ vendors:[Vendor]?)-> Void) {
        
        firebaseFiretore.collection("Vendor").getDocuments { (snapshot, error) in
            
            if error == nil {
                // Vendor Data is Fetched
                if let vendorsDocuments = snapshot?.documents {
                    // Got Documents
                    var vendors = [Vendor]()
                    for documents in vendorsDocuments {
                        let vendorData  =   documents.data()
                        let name        =   vendorData["Name"] as! String
                        let subtext     =   vendorData["Subtext"] as! String
                        let email       =   vendorData["Email"] as! String
                        let phoneNumber =   vendorData["PhoneNumber"] as! String
                        let location    =   vendorData["Location"] as! String
                        let timings     =   vendorData["Timings"] as! String
                        let vendorId    =   vendorData["VendorId"] as! String
                        
                        let vendor = Vendor(name: name, subText: subtext, email: email, phoneNumber: phoneNumber, location: location, timings: timings, vendorId: vendorId)
                        
                        vendors.append(vendor)
                    }
                    completion(true, "Got Vendors Data", vendors)
                    
                } else {
                    
                    completion(false, "Vendors data not found", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func fetchPackages(vendorID:String,completion:@escaping(_ status:Bool, _ message:String, _ packages:[Packages]?) -> Void ) {
        
        firebaseFiretore.collection("Vendor").document(vendorID).collection("Packages").getDocuments { (snapshot, error) in
            
            if error == nil {
                // Got Packages
                if let packageDocuments = snapshot?.documents {
                    var packages = [Packages]()
                    for documents in packageDocuments {
                        let packagesData        =   documents.data()
                        let packageName         =   packagesData["PackageName"] as! String
                        let packageDescription  =   packagesData["PackageDescription"] as! String
                        let packagePrice        =   packagesData["PackagePrice"] as! String
                        
                        let package = Packages(packageName: packageName, packageDescription: packageDescription, packagePrice: packagePrice)
                        
                        packages.append(package)
                        
                    }
                    completion(true, "Got Packages", packages)
                    
                } else {
                    
                    completion(false, "Unable to find any Package", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    func fetchVendorDataWithID(vendorID:String,completion:@escaping(_ status:Bool,_ message:String,_ vendor:Vendor?)->Void){
        
        firebaseFiretore.collection("Vendor").document(vendorID).getDocument { (snapshot, error) in
            
            if let snapshot = snapshot{
                // you get some data
                if let vendorDic    =   snapshot.data(){
                    let vendor      =   Vendor(vendorDict: vendorDic)
                    completion(true, "Got Vendor Data", vendor)
                    
                } else {
                    
                    completion(false, "Unable to get Vendor data", nil)
                }
            } else {
                // you get an error
                completion(false, error!.localizedDescription, nil)
            }
        }
    }
}
