//
//  ScheduleSummary.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/25/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth

class ScheduleSummary: UIViewController {
    
    var servicesSummary:BookWash!
    
    @IBOutlet weak var confirmBtnOut: UIButton!
    @IBOutlet weak var scheduleSummaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleSummaryTableView.delegate = self
        scheduleSummaryTableView.dataSource = self
        confirmBtnOut.layer.cornerRadius = 5
    }
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        CustomLoader.instance.showLoaderView()
        
        ServerCommunication.sharedReference.scheduleWashBooking(packageName: servicesSummary.packageName, packageDescription: servicesSummary.packageDescription, packageDetails: servicesSummary.packageDetails, packagePrice: servicesSummary.packagePrice, bookingTime: servicesSummary.bookingTime, bookingDate: servicesSummary.bookingDate, bookingStatus: "Pending", discountCode: servicesSummary.discountCode, userId: servicesSummary.userId) { (status, message) in
            
            if status {
                
                CustomLoader.instance.hideLoaderView()
                Alerts.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                    self.performSegue(withIdentifier: "MyBookingsViewController", sender: nil)
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

extension ScheduleSummary: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleSummaryTableViewCell") as! ScheduleSummaryTableViewCell
        
        cell.packageNameLabel.text          =   servicesSummary.packageName
        cell.packageDescriptionLabel.text   =   servicesSummary.packageDescription
        cell.packageDetailsLabel.text       =   servicesSummary.packageDetails
        cell.packageAmountLabel.text        =   servicesSummary.packagePrice
        cell.dateAndTImeLabel.text          =   "\(servicesSummary.bookingDate) - \(servicesSummary.bookingTime)"
        // MARK: Have to add coupon and wallet instances in model and firebase
        cell.couponAmountLabel.text         =   "$0"
        cell.walletAmountLabel.text         =   "$0"
        cell.totalAmountLabel.text          =   servicesSummary.packagePrice
        
        return cell
    }
}
