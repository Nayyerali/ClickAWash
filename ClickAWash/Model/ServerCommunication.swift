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
    
    // MARK: Upload User Data while signing Up
    
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
    
    // MARK: Fetch User booking for showing in details controller of Done Job
        
        func fetchUsersDataWithUserNameAndShopName(requestSenderName:String, completion:@escaping(_ status:Bool, _ message:String, _ bookings:[BookWash]?) -> Void){
        
        firebaseFiretore.collection("WashBookings").whereField("RequestSenderName", isEqualTo: requestSenderName).getDocuments { (snapshot, error) in
            
            if error == nil {
                // User's Booking Data is Fetched
                if let washBookingDocumentsForDetails = snapshot?.documents {
                    // Got all Documents
                    
                    var washBookingsForDetails = [BookWash]()
                    
                    for documentsForDetails in washBookingDocumentsForDetails {
                        
                        let washBookingsDataForDetails    =   documentsForDetails.data()
                        let packageNameForDetails         =   washBookingsDataForDetails["PackageName"] as! String
                        let packageDescriptionForDetails  =   washBookingsDataForDetails["PckageDescription"] as! String
                        let packageDetailsForDetails      =   washBookingsDataForDetails["PackageDetails"] as! String
                        let packagePriceForDetails        =   washBookingsDataForDetails["PackagePrice"] as! String
                        let bookingDateForDetails         =   washBookingsDataForDetails["BookingDate"] as! String
                        let bookingTimeForDetails         =   washBookingsDataForDetails["BookingTime"] as! String
                        let bookingStatusForDetails       =   washBookingsDataForDetails["BookingStatus"] as! String
                        let discoutCodeForDetails         =   washBookingsDataForDetails["DiscountCode"] as! String
                        let userIdForDetails              =   washBookingsDataForDetails["UserId"] as! String
                        let shopNameForDetails            =   washBookingsDataForDetails["ShopName"] as! String
                        let userNameForDetails            =   washBookingsDataForDetails["RequestSenderName"] as! String
                        let userImageForDetails           =   washBookingsDataForDetails["RequestSenderImage"] as! String
                        
                        let userWashBookingForDetails = BookWash(packageName: packageNameForDetails, packageDescription: packageDescriptionForDetails, packageDetails: packageDetailsForDetails, packagePrice: packagePriceForDetails, bookingTime: bookingTimeForDetails, bookingDate: bookingDateForDetails, bookingStatus: bookingStatusForDetails, discountCode: discoutCodeForDetails, userId: userIdForDetails, shopName: shopNameForDetails, userName: userNameForDetails, userImage: userImageForDetails)
                        
                        if userWashBookingForDetails.userName == requestSenderName && userWashBookingForDetails.shopName == Worker.workerReference.workerShop {

                            washBookingsForDetails.append(userWashBookingForDetails)
                            print (washBookingsForDetails)
                            
                        } else {
                            completion(false, "Could not find user booking as per details", nil)
                        }
                    }
                    completion(true, "Got User Wash Bookings For Details", washBookingsForDetails)
                    
                } else {
                    
                    completion(false, "Unable to fetch User Bookings For Details", nil)
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
            }
        }
    }
    
    // MARK: Upload Worker Data while signing Up
    
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
    
    // MARK: Schedule Workers ToDo Tasks
    
    func scheduleWorkersToDoJobs(requestSenderName:String, requestSenderImage:String, packageName:String, packagePrice:String, bookingDateAndTime:String, userId:String, shopName:String,workerID:String, completion:@escaping(_ status:Bool,_ message:String) -> Void) {
        
        let toDoTasksReference = firebaseFiretore.collection("Todo").document()
        
        toDoTasksReference.setData([
            "RequestSenderName"     :   requestSenderName,
            "RequestSenderImage"    :   requestSenderImage,
            "PackageName"           :   packageName,
            "PackagePrice"          :   packagePrice,
            "BookingDateAndTime"    :   bookingDateAndTime,
            "UserId"                :   userId,
            "ShopName"              :   shopName,
            "WorkerID"              :   workerID
            
        ]) { (error) in
            
            if error == nil {
                
                completion(true, "Booking is accepted for Wash")
                
            } else {
                
                completion(false, "Found error while accepting Booking for Wash")
            }
        }
    }
    
    // MARK: Schedule worker's OnGoing Jobs
    
    func scheduleWorkersOnGoingJobs(requestSenderName:String, requestSenderImage:String, packageName:String, packagePrice:String, bookingDateAndTime:String, userId:String, shopName:String,workerID:String, completion:@escaping(_ status:Bool,_ message:String) -> Void) {
        
        let onGoingTaskReference = firebaseFiretore.collection("OnGoing").document()
        
        onGoingTaskReference.setData([
            "RequestSenderName"     :   requestSenderName,
            "RequestSenderImage"    :   requestSenderImage,
            "PackageName"           :   packageName,
            "PackagePrice"          :   packagePrice,
            "BookingDateAndTime"    :   bookingDateAndTime,
            "UserId"                :   userId,
            "ShopName"              :   shopName,
            "WorkerID"              :   workerID
            
        ]) { (error) in
            
            if error == nil {
                
                completion(true, "Task is accepted for Wash")
                
            } else {
                
                completion(false, "Found error while accepting Task for Wash")
            }
        }
    }
    
    // MARK: Schedule worker's Done Jobs
    
    func scheduleWorkersDoneJobs(requestSenderName:String, requestSenderImage:String, packageName:String, packagePrice:String, bookingDateAndTime:String, userId:String, shopName:String,workerID:String, completion:@escaping(_ status:Bool,_ message:String) -> Void) {
        
        let doneJobReference = firebaseFiretore.collection("Done").document()
        
        doneJobReference.setData([
            "RequestSenderName"     :   requestSenderName,
            "RequestSenderImage"    :   requestSenderImage,
            "PackageName"           :   packageName,
            "PackagePrice"          :   packagePrice,
            "BookingDateAndTime"    :   bookingDateAndTime,
            "UserId"                :   userId,
            "ShopName"              :   shopName,
            "WorkerID"              :   workerID
            
        ]) { (error) in
            
            if error == nil {
                
                completion(true, "Task is completed")
                
            } else {
                
                completion(false, "Found error while completing task")
            }
        }
    }
    
     // MARK: Delete Document From OnGoing Collection once user has started done task
    
    func deletedOnGoingJobDocumentForOnDoneJobs(documentId:String, completion:@escaping (_ status:Bool, _ message:String) -> Void){
        
        firebaseFiretore.collection("OnGoing").document(documentId).delete { (error) in
            
            if error == nil {
                
                completion(true, "Succefully moved to Done")
                
            } else {
                
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    // MARK: Schedule Wash Booking
    
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
    
    // MARK: Fetch User Data while logging in to manage User profile
    
    func fetchUserData(userID:String,completion:@escaping(_ status:Bool,_ message:String,_ user:User?) -> Void) {
        
        firebaseFiretore.collection("Users").document(userID).getDocument { (snapshot, error) in
            
            if let snapshot = snapshot {
                
                if let userDic = snapshot.data() {
                    
                    let user = User(userDict: userDic)
                    
                    completion(true, "Got User Data", user)
                    
                } else {
                    
                    completion(false, "Unable to get personal data", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    // MARK: Fetch Worker Data while logging in to manage worker profile
    
    func fetchWorkerData(workerID:String,completion:@escaping(_ status:Bool,_ message:String,_ worker:Worker?) -> Void) {
        
        firebaseFiretore.collection("Workers").document(workerID).getDocument { (snapshot, error) in
            
            if let snapshot = snapshot {
                
                if let workerDic = snapshot.data() {
                    
                    let worker = Worker(workerDict: workerDic)
                    
                    completion(true, "Got Worker Data", worker)
                    
                } else {
                    
                    completion(false, "Unable to get personal data", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    // MARK: Upload User Image
    
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
    
    // MARK: Upload Worker Image
    
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
    
    //MARK: Fetch Workers Todo Jobs
    
    func fetchWorkersTodoJobs (completion:@escaping(_ status:Bool, _ message:String, _ todoTasks:[BookWash]?) -> Void) {
        
        firebaseFiretore.collection("Todo").whereField("WorkerID", isEqualTo: Worker.workerReference.workerId).getDocuments { (snapshot, error) in
            //whereField("WorkerId", isEqualTo: Worker.workerReference.workerId)
            if error == nil {
                
                if let todoTasksDocuments = snapshot?.documents {
                    
                    var todoTasks = [BookWash]()
                    
                    for documents in todoTasksDocuments {
                        
                        let todoTasksData = documents.data()
                        // MARK: using document ID to remove selected document while starting wash
                        let documentID = documents.documentID
                        let requestSenderName       =   todoTasksData["RequestSenderName"] as! String
                        let requestSenderImage      =   todoTasksData["RequestSenderImage"] as! String
                        let packageName             =   todoTasksData["PackageName"] as! String
                        let packagePrice            =   todoTasksData["PackagePrice"] as! String
                        let bookingDateAndTime      =   todoTasksData["BookingDateAndTime"] as! String
                        //let userId                  =   todoTasksData["UserId"] as! String
                        let shopName                =   todoTasksData["ShopName"] as! String
                        
                        let todoTask    =   BookWash(packageName: packageName, packageDescription: "", packageDetails: "", packagePrice: packagePrice, bookingTime: bookingDateAndTime, bookingDate: bookingDateAndTime, bookingStatus: "", discountCode: "", userId: documentID, shopName: shopName, userName: requestSenderName, userImage: requestSenderImage)
                        
                        todoTasks.append(todoTask)
                    }
                    
                    completion(true, "Todo Tasks are fetched successfully", todoTasks)
                    
                } else {
                    completion(false, "Unable to fetch Todo tasks", nil)
                }
            } else {
                completion(false, error!.localizedDescription, nil)
            }
        }
    }
    
    //MARK: Fetch Worker's OnGoing Jobs
    
    func fetchWorkersOnGoingJobs (completion:@escaping(_ status:Bool, _ message:String, _ onGoingjobs:[BookWash]?) -> Void) {
        
        firebaseFiretore.collection("OnGoing").whereField("ShopName", isEqualTo: Worker.workerReference.workerShop).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                if let onGoingJobsDocuments = snapshot?.documents {
                    
                    var onGoingJobs = [BookWash]()
                    
                    for documents in onGoingJobsDocuments {
                        
                        let onGoingJobsData = documents.data()
                        // MARK: using document ID to remove selected document while starting wash
                        let documentID = documents.documentID
                        let requestSenderName       =   onGoingJobsData["RequestSenderName"] as! String
                        let requestSenderImage      =   onGoingJobsData["RequestSenderImage"] as! String
                        let packageName             =   onGoingJobsData["PackageName"] as! String
                        let packagePrice            =   onGoingJobsData["PackagePrice"] as! String
                        let bookingDateAndTime      =   onGoingJobsData["BookingDateAndTime"] as! String
                        //let userId                  =   todoTasksData["UserId"] as! String
                        let shopName                =   onGoingJobsData["ShopName"] as! String
                        
                        let onGoingJob    =   BookWash(packageName: packageName, packageDescription: "", packageDetails: "", packagePrice: packagePrice, bookingTime: bookingDateAndTime, bookingDate: bookingDateAndTime, bookingStatus: "", discountCode: "", userId: documentID, shopName: shopName, userName: requestSenderName, userImage: requestSenderImage)
                        
                        onGoingJobs.append(onGoingJob)
                    }
                    
                    completion(true, "OnGoing Jobs are fetched successfully", onGoingJobs)
                    
                } else {
                    completion(false, "Unable to fetch OnGoing Jobs", nil)
                }
            } else {
                completion(false, error!.localizedDescription, nil)
            }
        }
    }
    
    //MARK: Fetch Worker's Done Jobs
    
    func fetchWorkersDoneJobs (completion:@escaping(_ status:Bool, _ message:String, _ onGoingjobs:[BookWash]?) -> Void) {
        
        firebaseFiretore.collection("Done").whereField("ShopName", isEqualTo: Worker.workerReference.workerShop).getDocuments { (snapshot, error) in
            
            if error == nil {
                
                if let doneJobsDocuments = snapshot?.documents {
                    
                    var doneJobs = [BookWash]()
                    
                    for documents in doneJobsDocuments {
                        
                        let doneJobsData = documents.data()
                        let documentID = documents.documentID
                        let requestSenderName       =   doneJobsData["RequestSenderName"] as! String
                        let requestSenderImage      =   doneJobsData["RequestSenderImage"] as! String
                        let packageName             =   doneJobsData["PackageName"] as! String
                        let packagePrice            =   doneJobsData["PackagePrice"] as! String
                        let bookingDateAndTime      =   doneJobsData["BookingDateAndTime"] as! String
                        //let userId                  =   todoTasksData["UserId"] as! String
                        let shopName                =   doneJobsData["ShopName"] as! String
                        
                        let doneJob    =   BookWash(packageName: packageName, packageDescription: "", packageDetails: "", packagePrice: packagePrice, bookingTime: bookingDateAndTime, bookingDate: bookingDateAndTime, bookingStatus: "", discountCode: "", userId: documentID, shopName: shopName, userName: requestSenderName, userImage: requestSenderImage)
                        
                        doneJobs.append(doneJob)
                    }
                    
                    completion(true, "Done Jobs are fetched successfully", doneJobs)
                    
                } else {
                    
                    completion(false, "Unable to fetch Done Jobs", nil)
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
            }
        }
    }
    
    // MARK: Delete Document From TODO COllection once user has started wash
    
    func deletedTodoJobsDocumentForOnGoingJobs(documentId:String, completion:@escaping (_ status:Bool, _ message:String) -> Void){
        
        firebaseFiretore.collection("Todo").document(documentId).delete { (error) in
            if error == nil {
                
                completion(true, "Succefully moved to OnGoing")
            } else {
                completion(false, error!.localizedDescription)
            }
        }
    }
    
    // MARK: Fetch User's all Bookings
    
    func fetchUserBookings(userId:String, completion:@escaping(_ status:Bool, _ message:String, _ bookings:[BookWash]?) -> Void){
        
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
    
    // MARK: Fetch All Users Bookings For Worker
    
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
                        
                        // MARK: Changed in at 03:41 Am on friday 09Jul
                        let userId              =   documents.documentID
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
    
        // MARK: Deleted Request from Request collection and move to TODO Collection
    
        func deletedRequestDocumentForTodoJobs(documentId:String, completion:@escaping (_ status:Bool, _ message:String) -> Void){
    
            firebaseFiretore.collection("WashBookings").document(documentId).delete { (error) in
                
                if error == nil {
    
                    completion(true, "Succefully moved to Todo")
                } else {
                    completion(false, error!.localizedDescription)
                }
            }
        }
    
    // MARK: Fetch Users Completed Bookings
    
    func fetchUsersCompletedBookings(userId:String, completion:@escaping(_ status:Bool, _ message:String, _ bookings:[BookWash]?) -> Void){
        
        firebaseFiretore.collection("Users").whereField("UserId", isEqualTo: userId).getDocuments { (snapshot, error) in
            
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
    
    // MARK: Fetch Vendor's Data For Showing In Services View & Home View
    
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
    
    func fetchVendorsDataForWorker (completion:@escaping(_ status:Bool, _ message:String, _ vendors:[Vendor]?)-> Void) {
        
        firebaseFiretore.collection("Vendor").whereField("Name", isEqualTo: Worker.workerReference.workerShop).getDocuments { (snapshot, error) in
            
            if error == nil {
                // Vendor Data is Fetched
                if let vendorsDocumentsForWorker = snapshot?.documents {
                    // Got Documents
                    var vendorsForWorker = [Vendor]()
                    
                    for documentsForWorker in vendorsDocumentsForWorker {
                        
                        let vendorDataForWorker  =   documentsForWorker.data()
                        let name        =   vendorDataForWorker["Name"] as! String
                        let subtext     =   vendorDataForWorker["Subtext"] as! String
                        let email       =   vendorDataForWorker["Email"] as! String
                        let phoneNumber =   vendorDataForWorker["PhoneNumber"] as! String
                        let location    =   vendorDataForWorker["Location"] as! String
                        let timings     =   vendorDataForWorker["Timings"] as! String
                        let vendorId    =   vendorDataForWorker["VendorId"] as! String
                        
                        let vendorForWorker = Vendor(name: name, subText: subtext, email: email, phoneNumber: phoneNumber, location: location, timings: timings, vendorId: vendorId)
                        
                        vendorsForWorker.append(vendorForWorker)
                    }
                    completion(true, "Got Vendors Data", vendorsForWorker)
                    
                } else {
                    
                    completion(false, "Vendors data not found", nil)
                    
                }
            } else {
                
                completion(false, error!.localizedDescription, nil)
                
            }
        }
    }
    
    // MARK: Fetch Vendor's Packages For Showing In Services View & User's Home View
    
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
    
    // MARK: Fetch Vendor Data With ID For Showing in About View
    
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
