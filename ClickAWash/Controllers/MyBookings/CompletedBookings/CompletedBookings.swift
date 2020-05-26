//
//  CompletedBookings.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/26/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth

class CompletedBookings: UIViewController {
    
    var usersCompletedBookings = [BookWash]()
    
    @IBOutlet weak var completedWashTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completedWashTableView.delegate     =   self
        completedWashTableView.dataSource   =   self
        fetchingUsersCompletedBookings()
    }
    
    func fetchingUsersCompletedBookings() {
        
        ServerCommunication.sharedReference.fetchUsersCompletedBookings(userId: Auth.auth().currentUser!.uid) { (status, message, userBookings) in
            
            if status {
                self.usersCompletedBookings = userBookings!
                self.completedWashTableView.reloadData()
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
            }
        }
    }
}

extension CompletedBookings: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersCompletedBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedWashBookings") as! CompletedWashBookings
        
        cell.completedPackageName.text          =   usersCompletedBookings[indexPath.row].packageName
        cell.completedPackageDescription.text   =   usersCompletedBookings[indexPath.row].packageDescription
        cell.completedPackageDetails.text       =   usersCompletedBookings[indexPath.row].packageDetails
        cell.completedPackagePrice.text         =   usersCompletedBookings[indexPath.row].packagePrice
        cell.completedPackageDateAndTime.text   =   "\(usersCompletedBookings[indexPath.row].bookingDate) - \(usersCompletedBookings[indexPath.row].bookingTime)"
        cell.bookingStatus.text                 =   usersCompletedBookings[indexPath.row].bookingStatus
        // MARK: have to change with booking ID in firebase and model
        cell.completedBookingId.text            =   usersCompletedBookings[indexPath.row].userId
        
        return cell
    }
}
