//
//  RequestsController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class RequestsController: UIViewController {
    
    var usersWashBookings   =   [BookWash]()
    
    @IBOutlet weak var requestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestsTableView.delegate      =   self
        requestsTableView.dataSource    =   self
        fetchingRequestDetails()
    }
    
    func fetchingRequestDetails() {
        
        ServerCommunication.sharedReference.fetchAllUsersBookingsForWorker { (status, message, washBookings) in
            
            if status {
                
                self.usersWashBookings = washBookings!
                self.requestsTableView.reloadData()
                
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
            }
        }
    }
    
    @IBAction func acceptBtnPressed(_ sender: Any) {
        
//        ServerCommunication.sharedReference.scheduleWorkersToDoTasks(requestSenderName: <#T##String#>, requestSenderImage: <#T##String#>, packageName: <#T##String#>, packageDescription: <#T##String#>, packageDetails: <#T##String#>, packagePrice: <#T##String#>, bookingTime: <#T##String#>, bookingDate: <#T##String#>, bookingStatus: <#T##String#>, discountCode: <#T##String#>, userId: <#T##String#>, shopName: <#T##String#>, completion: <#T##(Bool, String) -> Void#>)
//
    }
    
    @IBAction func rejectBtnPressed(_ sender: Any) {
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
        cell.dateAndTime.text           =       "\(usersWashBookings[indexPath.row].bookingDate) - \(usersWashBookings[indexPath.row].bookingTime)"
        cell.vendorId.text              =       usersWashBookings[indexPath.row].userId
        cell.userName.text              =   usersWashBookings[indexPath.row].userName
        
        if let url = URL(string: usersWashBookings[indexPath.row].userImage) {
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        
        return cell
    }
}
