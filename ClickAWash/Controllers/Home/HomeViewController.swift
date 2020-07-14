//
//  HomeViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/14/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController, ChangeLocationDelegate  {

    var vendors = [Vendor]()
    var specialOffer = true
    static var userLocation:String!
    
    @IBOutlet weak var tableViewOut: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOut.delegate = self
        tableViewOut.dataSource = self
        fetchingVendorsData()
        
        weak var  controller = storyboard?.instantiateViewController(identifier: "LocationViewController") as? LocationViewController
        controller!.modalPresentationStyle = .fullScreen
        present(controller!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = HomeViewController.userLocation
    }
    
    func newLocationDetail(newLocation: String) {
            
        HomeViewController.self.userLocation = newLocation
        print ("New Location is \(HomeViewController.self.userLocation!)")
    }
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func goTomap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SegueToMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToMap" {
            
            let destinationCOntroller = segue.destination as! ChangeLocation
            destinationCOntroller.changeLocationProtocol = self
        }
    }
    
    @IBAction func bookWashFromNearBy(_ sender: UIButton) {
        
        CustomLoader.instance.showLoaderView()
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableViewOut)
        let indexPath = self.tableViewOut.indexPathForRow(at:buttonPosition)
        let _ = tableViewOut.cellForRow(at: indexPath!) as! NearByTableViewCell
        
        let vendorID = vendors[indexPath!.row].vendorId
        
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
    
    @IBAction func bookWashFromSpecialOffers(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableViewOut)
        let indexPath = self.tableViewOut.indexPathForRow(at:buttonPosition)
        let _ = self.tableViewOut.cellForRow(at: indexPath!) as! SpecialOffersTableViewCell
        
        let vendorID = vendors[indexPath!.row].vendorId
        
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        CustomLoader.instance.showLoaderView()
//
//        let vendorID = vendors[indexPath.row].vendorId
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//
//        let bookWashController = storyBoard.instantiateViewController(identifier: "BookCarWashViewController") as! BookCarWashViewController
//
//        ServerCommunication.sharedReference.fetchVendorDataWithID(vendorID: vendorID) { (status, message, vendor) in
//
//            if status{
//                CustomLoader.instance.hideLoaderView()
//                bookWashController.vendorDataForAboutView = vendor
//                self.navigationController?.pushViewController(bookWashController, animated: true)
//
//            } else {
//                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
//                    CustomLoader.instance.hideLoaderView()
//                }
//                return
//            }
//        }
//    }
}
