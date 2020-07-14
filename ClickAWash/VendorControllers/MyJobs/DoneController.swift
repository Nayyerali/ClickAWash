//
//  DoneController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class DoneController: UIViewController {
    
    var workersDonejobs = [BookWash]()
    
    @IBOutlet weak var doneJobsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneJobsTableView.delegate      =   self
        doneJobsTableView.dataSource    =   self
        fetchingWorkersDoneJobs()
    }
    
    func fetchingWorkersDoneJobs() {
        
        ServerCommunication.sharedReference.fetchWorkersDoneJobs { (status, message, doneJob) in
            
            if status {
                
                self.workersDonejobs = doneJob!
                self.doneJobsTableView.reloadData()
                
            } else {
                
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
}

extension DoneController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workersDonejobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneTableViewCell") as! DoneTableViewCell
        
        cell.dateAndTime.text        =       workersDonejobs[indexPath.row].bookingDate
        cell.userName.text           =       workersDonejobs[indexPath.row].userName
        cell.packagePrice.text       =       workersDonejobs[indexPath.row].packagePrice
        cell.vendorId.text           =       workersDonejobs[indexPath.row].userId
        cell.packageName.text        =       workersDonejobs[indexPath.row].packageName
        
        if let url = URL(string: workersDonejobs[indexPath.row].userImage) {
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let storyBoard             =   UIStoryboard(name: "Vendor", bundle: nil)
        let controller             =   storyBoard.instantiateViewController(identifier: "DetailsController") as! DetailsController
        controller.workerJobDetail = workersDonejobs[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
