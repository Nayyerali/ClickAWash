//
//  DetailsController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsController: UIViewController {
    
    var workerJobDetail:BookWash!
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTableView.delegate   =   self
        detailsTableView.dataSource =   self
        fetchingUserWashBookingInitiatedByUser()
    }
    
    func fetchingUserWashBookingInitiatedByUser () {
        
        ServerCommunication.sharedReference.fetchUsersDataWithUserNameAndShopName(requestSenderName: workerJobDetail.userName) { (status, message, userWashBooking) in
            
            if status {
                
            } else {
                
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
}

extension DetailsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell") as! DetailsTableViewCell
        
        cell.userName.text              =   workerJobDetail.userName
        cell.packagePrice.text          =   workerJobDetail.packagePrice
        cell.vendorId.text              =   workerJobDetail.userId
        cell.dateAndTime.text           =   workerJobDetail.bookingDate
        cell.emailAddress.text          =   ""
        cell.phoneNumber.text           =   ""
        cell.packageDescription.text    =   ""
        cell.serviceDetails.text        =   ""
        
        if let url = URL(string: workerJobDetail.userImage) {
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        return cell
    }
}
