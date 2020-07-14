//
//  PackageOrServicesDetail.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/21/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import FirebaseAuth

class PackageOrServicesDetail: UIViewController {
    
    var package = [Packages]()
    var selectedPackageName:String!
    var selectedPackageDescription:String!
    var selectedPackagePrice:String!
    var serviceDetails:BookWash!
    var vendorShopName:String!
    var datePicker: UIDatePicker?
    var timePicker: UIDatePicker?
    
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var packageDescription: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var internelViewOut: UIView!
    @IBOutlet weak var timingField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var dicountCodeField: UITextField!
    @IBOutlet weak var scheduleNowBtnOut: UIButton!
    @IBOutlet weak var packageDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        setUpPackageDetails()
        datePickerViewForDateField()
        datePickerViewForTimeField()
    }
    
    func datePickerViewForDateField() {
        
        datePicker = UIDatePicker()
        let currentDate = Date()
        let oneDay = 24 * 60 * 60
        let minDate = currentDate.addingTimeInterval(TimeInterval(0 * oneDay)) // before 00 days from now
        let maxDate = currentDate.addingTimeInterval(TimeInterval(1000 * oneDay)) // upto 1000 Days from now
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = maxDate
        datePicker?.datePickerMode = .date
        dateField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(PackageOrServicesDetail.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(PackageOrServicesDetail.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGasture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        dateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func datePickerViewForTimeField() {
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timingField.inputView = timePicker
        timePicker?.addTarget(self, action: #selector(PackageOrServicesDetail.timingChanged(datePicker:)), for: .valueChanged)
        
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(PackageOrServicesDetail.viewTappedAfterSelectingTiming(gestureRecognizer:)))
        view.addGestureRecognizer(tapGasture)
        
    }
    
    @objc func viewTappedAfterSelectingTiming(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func timingChanged(datePicker: UIDatePicker){
        let timeFormatter = DateFormatter()
        //        let date = Date()
        timeFormatter.timeZone = .autoupdatingCurrent
        timeFormatter.timeStyle = .short
        timingField.text = timeFormatter.string(from: datePicker.date)
    }
    
    func setUpElements(){
        internelViewOut.layer.cornerRadius      =   10
        internelViewOut.layer.shadowRadius      =   4
        internelViewOut.layer.masksToBounds     =   false
        internelViewOut.layer.shadowColor       =   UIColor.gray.cgColor
        internelViewOut.layer.shadowOffset      =   CGSize(width: 0.0, height: 0.0)
        internelViewOut.layer.shadowOpacity     =   0.7
        scheduleNowBtnOut.layer.cornerRadius    =   4
        packagePrice.layer.cornerRadius         =   4
        packagePrice.layer.masksToBounds        =   false
    }
    
    func setUpPackageDetails (){
        
        packageName.text            =       selectedPackageName
        packageDescription.text     =       selectedPackageDescription
        packagePrice.text           =       selectedPackagePrice
    }
    
    @IBAction func scheduleNowBtn(_ sender: Any) {
        
        
        if timingField.text == nil || dateField.text == "" {
            
            Alerts.showAlert(controller: self, title: "Fields Error", message: "Please fill all fields") { (Ok) in
                
            }
            
            return
            
        } else if dicountCodeField.text == "" {
            
            Alerts.showAlert(controller: self, title: "No Discount Code ?", message: "If you dont have discount  coupon write 0 in the field ") { (Ok) in
                
            }
            
            return
            
        } else {
            
            serviceDetails = BookWash(
                packageName:        self.packageName.text!,
                packageDescription: self.packageDescription.text!,
                packageDetails:     self.packageDetail.text!,
                packagePrice:       self.packagePrice.text!,
                bookingTime:        self.timingField.text!,
                bookingDate:        self.dateField.text!,
                bookingStatus:      "Pending",
                discountCode:       self.dicountCodeField.text!,
                userId:             User.userReference.userId,
                shopName:           vendorShopName,
                userName:           User.userReference.userName,
                userImage:          User.userReference.imageURL
            )
            self.performSegue(withIdentifier: "ScheduleSummary", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScheduleSummary" {
            let destination = segue.destination as! ScheduleSummary
            destination.servicesSummary = serviceDetails
        }
    }
}
