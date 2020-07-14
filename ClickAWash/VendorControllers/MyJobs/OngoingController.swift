//
//  OngoingController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class OngoingController: UIViewController {
    
    var workerOnGoingJobs = [BookWash]()
    
    @IBOutlet weak var onGoingJobsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingWorkersOnGoingJobs()
        onGoingJobsTableView.delegate   =   self
        onGoingJobsTableView.dataSource =   self
        
    }
    
    func fetchingWorkersOnGoingJobs() {
        
        ServerCommunication.sharedReference.fetchWorkersOnGoingJobs { (status, message, onGoingJobs) in
            
            if status {
                
                self.workerOnGoingJobs = onGoingJobs!
                self.onGoingJobsTableView.reloadData()
                
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.onGoingJobsTableView)
        let indexPath = self.onGoingJobsTableView.indexPathForRow(at:buttonPosition)
        let cell = self.onGoingJobsTableView.cellForRow(at: indexPath!) as! OngoingTableViewCell
        
        var documentIdForDeletition = cell.vendorId.text!
        
        ServerCommunication.sharedReference.scheduleWorkersDoneJobs(requestSenderName: cell.userName.text!, requestSenderImage: "\(cell.userImage.sd_imageURL!)", packageName: cell.packageName.text!, packagePrice: cell.packagePrice.text!, bookingDateAndTime: cell.dateAndTime.text!, userId: cell.vendorId.text!, shopName: Worker.workerReference.workerShop, workerID: Worker.workerReference.workerId) { (status, message) in
            
            if status {
                
                CustomLoader.instance.hideLoaderView()
                
                Alerts.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                    
                    ServerCommunication.sharedReference.deletedOnGoingJobDocumentForOnDoneJobs(documentId: documentIdForDeletition) { (status, message) in
                        
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
                Alerts.showAlert(controller: self, title: "Failed", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
}

extension OngoingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workerOnGoingJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OngoingTableViewCell") as! OngoingTableViewCell
        
        cell.dateAndTime.text        =       workerOnGoingJobs[indexPath.row].bookingDate
        cell.userName.text           =       workerOnGoingJobs[indexPath.row].userName
        cell.packagePrice.text       =       workerOnGoingJobs[indexPath.row].packagePrice
        cell.vendorId.text           =       workerOnGoingJobs[indexPath.row].userId
        cell.packageName.text        =       workerOnGoingJobs[indexPath.row].packageName
        
        if let url = URL(string: workerOnGoingJobs[indexPath.row].userImage) {
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        
        return cell
    }
}
