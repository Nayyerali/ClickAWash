//
//  CompanyProfileViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/31/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class CompanyProfileViewController: UIViewController {
    
    var vendorDataForWorkerAboutView = [Vendor]()
    var packagesOfVendorsForWorker = [Packages]()
    
    @IBOutlet weak var vendorIdLabel: UILabel!
    @IBOutlet weak var servicesViewForWorker: UIView!
    @IBOutlet weak var aboutViewForWorker: UIView!
    @IBOutlet weak var storeImageViewForWorker: UIImageView!
    @IBOutlet weak var internelViewOutForWorker: UIView!
    @IBOutlet weak var segmentedControlOutForWorker: UISegmentedControl!
    @IBOutlet weak var servicesTableViewForWorker: UITableView!
    @IBOutlet weak var shopNameAboutScreenForWorker: UILabel!
    @IBOutlet weak var shopSubtextAboutScreenForWorker: UILabel!
    @IBOutlet weak var mapViewOutAboutScreenForWorker: MKMapView!
    @IBOutlet weak var shopLocationAboutScreenForWorker: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicesTableViewForWorker.delegate = self
        servicesTableViewForWorker.dataSource = self
        setUpElements()
        fetchingVendorDataForShowingInWorkerAboutView()
    }
    
    func fetchingVendorDataForShowingInWorkerAboutView(){
        
        ServerCommunication.sharedReference.fetchVendorsDataForWorker { (status, message, vendorData) in
            
            if status {
                
                self.vendorDataForWorkerAboutView = vendorData!
                let _ = self.vendorDataForWorkerAboutView.reduce([String: String]()) { (dictionary, vendor) -> [String: String] in
                    
                    var vendorDictionaryForWorker = dictionary
                    
                    vendorDictionaryForWorker[vendor.name]      =   vendor.name
                    vendorDictionaryForWorker[vendor.subText]   =   vendor.subText
                    vendorDictionaryForWorker[vendor.location]  =   vendor.location
                    vendorDictionaryForWorker[vendor.vendorId]  =   vendor.vendorId
                    
                    self.shopNameAboutScreenForWorker.text      =   vendorDictionaryForWorker[vendor.name]
                    self.shopSubtextAboutScreenForWorker.text   =   vendorDictionaryForWorker[vendor.subText]
                    self.shopLocationAboutScreenForWorker.text  =   vendorDictionaryForWorker[vendor.location]
                    self.vendorIdLabel.text                     =   vendorDictionaryForWorker[vendor.vendorId]
                    
                    return vendorDictionaryForWorker
                }
                
            } else {
                
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
    
    func setUpElements(){
        
        internelViewOutForWorker.layer.cornerRadius          =   10
        internelViewOutForWorker.layer.shadowRadius          =   4
        internelViewOutForWorker.layer.masksToBounds         =   false
        internelViewOutForWorker.layer.shadowColor           =   UIColor.gray.cgColor
        internelViewOutForWorker.layer.shadowOffset          =   CGSize(width: 0.0, height: 0.0)
        internelViewOutForWorker.layer.shadowOpacity         =   0.7
        segmentedControlOutForWorker.selectedSegmentIndex    =   0
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        
        if segmentedControlOutForWorker.selectedSegmentIndex == 0 {
            
            aboutViewForWorker.alpha     =   1
            servicesViewForWorker.alpha  =   0
        } else {
            aboutViewForWorker.alpha     =   0
            servicesViewForWorker.alpha  =   1
            self.fetchingPackagesForWorker()
        }
    }
    
    func fetchingPackagesForWorker(){
        
        ServerCommunication.sharedReference.fetchPackages(vendorID: self.vendorIdLabel.text!) { (status, message, packagesForWorker) in
            
            if status {
                self.packagesOfVendorsForWorker = packagesForWorker!
                self.servicesTableViewForWorker.reloadData()
                
            } else {
                Alerts.showAlert(controller: self, title: "Error", message: message) { (Ok) in
                    
                }
                return
            }
        }
    }
}

extension CompanyProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return packagesOfVendorsForWorker.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerPackageDetailsTableViewCell") as! WorkerPackageDetailsTableViewCell
        
        cell.packageNameForWorkerDetails.text           =   packagesOfVendorsForWorker[indexPath.row].packageName
        cell.packageDescriptionForWorkerDetails.text    =   packagesOfVendorsForWorker[indexPath.row].packageDescription
        cell.packagePriceForWorkerDetails.text          =   packagesOfVendorsForWorker[indexPath.row].packagePrice
        
        return cell
    }
}
