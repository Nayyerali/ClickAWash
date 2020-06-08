//
//  BookCarWashViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/14/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import MapKit

class BookCarWashViewController:  UIViewController {

    var vendorDataForAboutView:Vendor!
    var packagesOfVendors = [Packages]()
    
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var internelViewOut: UIView!
    @IBOutlet weak var segmentedControlOut: UISegmentedControl!
    @IBOutlet weak var servicesTableView: UITableView!
    @IBOutlet weak var shopNameAboutScreen: UILabel!
    @IBOutlet weak var shopSubtextAboutScreen: UILabel!
    @IBOutlet weak var mapViewOutAboutScreen: MKMapView!
    @IBOutlet weak var shopLocationAboutScreen: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        setUpElements()
        fetchingPackages()
        setUpVendorDataInAboutView()

    }
    
    func setUpVendorDataInAboutView(){
        
        self.shopNameAboutScreen.text       =   vendorDataForAboutView.name
        self.shopSubtextAboutScreen.text    =   vendorDataForAboutView.subText
        self.shopLocationAboutScreen.text   =   vendorDataForAboutView.location
    }
    
    func setUpElements(){
        
        internelViewOut.layer.cornerRadius          =   10
        internelViewOut.layer.shadowRadius          =   4
        internelViewOut.layer.masksToBounds         =   false
        internelViewOut.layer.shadowColor           =   UIColor.gray.cgColor
        internelViewOut.layer.shadowOffset          =   CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity         =   0.7
        segmentedControlOut.selectedSegmentIndex    =   0
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        
        if segmentedControlOut.selectedSegmentIndex == 0 {
            
            aboutView.alpha     =   1
            servicesView.alpha  =   0
        } else {
            aboutView.alpha     =   0
            servicesView.alpha  =   1
        }
    }
    
    func fetchingPackages(){
        
        ServerCommunication.sharedReference.fetchPackages(vendorID: vendorDataForAboutView.vendorId) { (status, message, packages) in
            if status {
                self.packagesOfVendors = packages!
                self.servicesTableView.reloadData()
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
}

extension BookCarWashViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return packagesOfVendors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageOrServicesTableViewCell") as! PackageOrServicesTableViewCell
        
        cell.packageName.text           =   packagesOfVendors[indexPath.row].packageName
        cell.packageDescription.text    =   packagesOfVendors[indexPath.row].packageDescription
        cell.packagePrice.text          =   packagesOfVendors[indexPath.row].packagePrice
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let bookWashController = storyBoard.instantiateViewController(identifier: "PackageOrServicesDetail") as! PackageOrServicesDetail
        
        bookWashController.selectedPackageName          =    packagesOfVendors[indexPath.row].packageName
        bookWashController.selectedPackageDescription   =    packagesOfVendors[indexPath.row].packageDescription
        bookWashController.selectedPackagePrice         =    packagesOfVendors[indexPath.row].packagePrice
        bookWashController.vendorShopName               =    vendorDataForAboutView.name
        self.navigationController?.pushViewController(bookWashController, animated: true)
    }
}
