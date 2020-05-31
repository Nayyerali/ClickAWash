//
//  ScheduledBookings.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/26/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit

class ScheduledBookings: UIViewController {
    
    var userWashBookings = [BookWash]()
    var expandedIndexPath = IndexPath()
    
    @IBOutlet weak var scheduledWashTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledWashTableView.delegate     =   self
        scheduledWashTableView.dataSource   =   self
        fetchingUserWashBookings()
    }
    
    func fetchingUserWashBookings() {
        
        ServerCommunication.sharedReference.fetchUserBookings(userId: User.userReference.userId) { (status, message, userBookings) in
            
            if status {
                self.userWashBookings = userBookings!
                self.scheduledWashTableView.reloadData()
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
            }
        }
    }
}

extension ScheduledBookings: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userWashBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledWashBookings") as! ScheduledWashBookings
        
        cell.scheduledPackageName.text          =   userWashBookings[indexPath.row].packageName
        cell.scheduledPackageDescription.text   =   userWashBookings[indexPath.row].packageDescription
        cell.scheduledPackageDetails.text       =   userWashBookings[indexPath.row].packageDetails
        cell.scheduledPackagePrice.text         =   userWashBookings[indexPath.row].packagePrice
        cell.scheduledPackageDateAndTime.text   =   "\(userWashBookings[indexPath.row].bookingDate) - \(userWashBookings[indexPath.row].bookingTime)"
        cell.bookingStatus.text                 =   userWashBookings[indexPath.row].bookingStatus
        // MARK: have to change with booking ID in firebase and model
        cell.bookingId.text                     =   userWashBookings[indexPath.row].userId
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        
        if indexPath == expandedIndexPath {
            expandedIndexPath = IndexPath()
        } else {
            expandedIndexPath = indexPath
        }
        
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == expandedIndexPath {
            return UITableView.automaticDimension
        }
        return 150
    }
}
