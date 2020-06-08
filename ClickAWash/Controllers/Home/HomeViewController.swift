//
//  HomeViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/14/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: BaseController {
    
    var vendors = [Vendor]()
    var specialOffer = true
    
    @IBOutlet weak var tableViewOut: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // presentLocationViewController()
        tableViewOut.delegate = self
        tableViewOut.dataSource = self
        fetchingVendorsData()
        
    }
    
    func presentLocationViewController() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "LocationViewController") as! LocationViewController
        controller.present(controller, animated: true){
            
        }
    }
    
    func fetchingVendorsData () {
        
        ServerCommunication.sharedReference.fetchVendorsData { (status, message, vendor) in
            
            if status {
                self.vendors = vendor!
                self.tableViewOut.reloadData()
                print (Auth.auth().currentUser!.uid)
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            
            let nearByCell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell") as! NearByTableViewCell
            
            nearByCell.shopNameLabel.text       =   vendors[indexPath.row].name
            nearByCell.shopSubTextLabel.text    =   vendors[indexPath.row].subText
            nearByCell.emailLabel.text          =   vendors[indexPath.row].email
            nearByCell.phoneNumberLabel.text    =   vendors[indexPath.row].phoneNumber
            nearByCell.shopLocationLabel.text   =   vendors[indexPath.row].location
            nearByCell.timingLabel.text         =   vendors[indexPath.row].timings
            
            return nearByCell
            
        } else {
            
            let specialOfferCell = tableView.dequeueReusableCell(withIdentifier: "SpecialOffersTableViewCell") as! SpecialOffersTableViewCell
            
            specialOfferCell.shopNameLabel.text     =   vendors[indexPath.row].name
            specialOfferCell.shopSubTextLabel.text  =   vendors[indexPath.row].subText
            specialOfferCell.emailLabel.text        =   vendors[indexPath.row].email
            specialOfferCell.phoneNumberLabel.text  =   vendors[indexPath.row].phoneNumber
            specialOfferCell.shopLocationLabel.text =   vendors[indexPath.row].location
            specialOfferCell.timingLabel.text       =   vendors[indexPath.row].timings
            
            return specialOfferCell
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        CustomLoader.instance.showLoaderView()
        
        let vendorID = vendors[indexPath.row].vendorId
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let bookWashController = storyBoard.instantiateViewController(identifier: "BookCarWashViewController") as! BookCarWashViewController
        
        ServerCommunication.sharedReference.fetchVendorDataWithID(vendorID: vendorID) { (status, message, vendor) in
            
            if status{
                CustomLoader.instance.hideLoaderView()
                bookWashController.vendorDataForAboutView = vendor
                self.navigationController?.pushViewController(bookWashController, animated: true)
                
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                CustomLoader.instance.hideLoaderView()
                }
                return
            }
        }
    }
}
