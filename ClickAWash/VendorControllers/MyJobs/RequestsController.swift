//
//  RequestsController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth

class RequestsController: UIViewController {
    
    var usersWashBookings   =   [BookWash]()
    static var comingAsAlreadyLoggedInUser:Bool!
    
    @IBOutlet weak var requestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestsTableView.delegate      =   self
        requestsTableView.dataSource    =   self
        
        if RequestsController.comingAsAlreadyLoggedInUser == true{
            
            fetchingWorkerDataForKeepingInReference()
        } else {
            
            fetchingRequestDetails()
        }
    }
    
    func fetchingRequestDetails() {
        
        ServerCommunication.sharedReference.fetchAllUsersBookingsForWorker { (status, message, washBookings) in
            
            if status {
                
                self.usersWashBookings = washBookings!
                self.requestsTableView.reloadData()
                
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
    
    func fetchingWorkerDataForKeepingInReference() {
        
        ServerCommunication.sharedReference.fetchWorkerData(workerID: Auth.auth().currentUser!.uid) { (statusOfWorker, messageReceived, workerDataForKeepingInReference) in
            
            if statusOfWorker {
                
                Worker.workerReference = workerDataForKeepingInReference
                self.fetchingRequestDetails()
            } else {
                
                print(messageReceived)
                
            }
        }
    }
    
    @IBAction func acceptBtnPressed(_ sender: UIButton) {
        
        CustomLoader.instance.showLoaderView()
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.requestsTableView)
        let indexPath = self.requestsTableView.indexPathForRow(at:buttonPosition)
        let cell = self.requestsTableView.cellForRow(at: indexPath!) as! RequestsTableViewCell
        
        ServerCommunication.sharedReference.scheduleWorkersToDoJobs(requestSenderName: cell.userName.text!, requestSenderImage: "\(cell.userImage.sd_imageURL!)", packageName: cell.packageName.text!, packagePrice: cell.packagePrice.text!, bookingDateAndTime: cell.dateAndTime.text!, userId: cell.vendorId.text!, shopName: Worker.workerReference.workerShop, workerID: Worker.workerReference.workerId) { (status, message) in
            
            if status {
                
                CustomLoader.instance.hideLoaderView()
                Alerts.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                    ServerCommunication.sharedReference.deletedRequestDocumentForTodoJobs(documentId: cell.vendorId.text!) { (status, message) in
                        
                        if status {
                            
                            Alerts.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                                
                            }
                            
                        } else {
                            CustomLoader.instance.hideLoaderView()
                            Alerts.showAlert(controller: self, title: "Failed", message: message) { (Ok) in
                                
                            }
                            return
                        }
                    }
                }
                
            } else {
                
                CustomLoader.instance.hideLoaderView()
                Alerts.showAlert(controller: self, title: "Faliure", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
}

extension RequestsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersWashBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestsTableViewCell") as! RequestsTableViewCell
        
        cell.packageName.text           =       usersWashBookings[indexPath.row].packageName
        cell.packagePrice.text          =       usersWashBookings[indexPath.row].packagePrice
        cell.vendorId.text              =       usersWashBookings[indexPath.row].userId
        cell.userName.text              =       usersWashBookings[indexPath.row].userName
        cell.dateAndTime.text           =       "\(usersWashBookings[indexPath.row].bookingDate) - \(usersWashBookings[indexPath.row].bookingTime)"
        
        if let url = URL(string: usersWashBookings[indexPath.row].userImage) {
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        
        return cell
    }
}
