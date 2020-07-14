//
//  TodoController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/30/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import SDWebImage

class TodoController: UIViewController{
    
    @IBOutlet weak var todoTasksTableView: UITableView!
    
    var todoTasksOfWorker   =   [BookWash]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTasksTableView.delegate     =   self
        todoTasksTableView.dataSource   =   self
        fetchingTodoTasksofWorker()
    }
    
    func fetchingTodoTasksofWorker() {
        
        ServerCommunication.sharedReference.fetchWorkersTodoJobs { (status, message, todoTasks) in
            
            if status {
                
                self.todoTasksOfWorker = todoTasks!
                self.todoTasksTableView.reloadData()
                
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
    
    @IBAction func startServiceBtnPressed(_ sender: UIButton) {
        
        CustomLoader.instance.showLoaderView()
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.todoTasksTableView)
               let indexPath = self.todoTasksTableView.indexPathForRow(at:buttonPosition)
               let cell = self.todoTasksTableView.cellForRow(at: indexPath!) as! TodoTableViewCell
        
        let documentIdForDeletition = cell.vendorId.text!
        
        print (cell.vendorId.text!)
        
        ServerCommunication.sharedReference.scheduleWorkersOnGoingJobs(requestSenderName: cell.userName.text!, requestSenderImage: "\(cell.userImage.sd_imageURL!)", packageName: cell.packageName.text!, packagePrice: cell.packagePrice.text!, bookingDateAndTime: cell.dateAndTime.text!, userId: cell.vendorId.text!, shopName: Worker.workerReference.workerShop, workerID: Worker.workerReference.workerId) { (status, message) in
            
            if status {
                
                CustomLoader.instance.hideLoaderView()
                
                Alerts.showAlert(controller: self, title: "Success", message: message) { (Ok) in
                    
                    ServerCommunication.sharedReference.deletedTodoJobsDocumentForOnGoingJobs(documentId: documentIdForDeletition) { (status, message) in
                        
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

extension TodoController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoTasksOfWorker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell") as! TodoTableViewCell
        
        cell.dateAndTime.text        =       todoTasksOfWorker[indexPath.row].bookingDate
        cell.userName.text           =       todoTasksOfWorker[indexPath.row].userName
        cell.packagePrice.text       =       todoTasksOfWorker[indexPath.row].packagePrice
        cell.vendorId.text           =       todoTasksOfWorker[indexPath.row].userId
        cell.packageName.text        =       todoTasksOfWorker[indexPath.row].packageName
        
        if let url = URL(string: todoTasksOfWorker[indexPath.row].userImage) {
            cell.userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceHolderImage"), options: SDWebImageOptions.continueInBackground) { (image, error, cacheType, url) in
            }
        }
        
        return cell
    }
}
