//
//  LocationViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    var segueIdentifier = "LocationToHomeViewController"
    var userCurrentLocation:String!
    var userSearchedLocation:String!
    var locationManager = CLLocationManager()
    var usingCurrentLocation:Bool!
    var usingSearchedLocation:Bool!
    
    @IBOutlet weak var enterLocationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageLocationManager()
    }
    
    @IBAction func goWithSearchedLocation(_ sender: Any) {
        
        usingSearchedLocation = true
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: Any) {
        
        usingCurrentLocation = true
        self.dismiss(animated: true) {
            
        }
    }
    
    func manageLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        } else {
            Alerts.showAlert(controller: self, title: "Device Location is off!", message: "Please turn on device location") { (Ok) in
                
            }
        }
    }
    
        //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation :CLLocation = locations[0] as CLLocation

        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            
            if (error != nil){
                
                print("error in reverseGeocode")
            }
            
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count>0{
                
                let placemark = placemarks![0]

                self.userCurrentLocation = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                print (self.userCurrentLocation!)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error \(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdentifier && usingCurrentLocation == true {
            
            let destination = segue.destination as! HomeViewController
            destination.userLocation = userCurrentLocation
            print (userCurrentLocation!)
        } else if segue.identifier == segueIdentifier && usingSearchedLocation == true {
            
            let destination = segue.destination as! HomeViewController
            destination.userLocation = userSearchedLocation
        }
    }
}
