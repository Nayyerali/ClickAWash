//
//  LocationViewController.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 5/10/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

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
            HomeViewController.userLocation = self.userSearchedLocation
        }
    }
    
    @IBAction func enterLocationFieldTapped(_ sender: Any) {
        
        enterLocationField.resignFirstResponder()
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true)
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: Any) {
        
        usingCurrentLocation = true
        self.dismiss(animated: true) {
            HomeViewController.userLocation = self.userCurrentLocation
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
                return
            }
            
            let placemark = placemarks! as [CLPlacemark]
            
            if placemark.count>0{
                
                let placemark = placemarks![0]
                
                self.userCurrentLocation = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error \(error)")
    }
}

extension LocationViewController: GMSAutocompleteViewControllerDelegate {
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print ("Place name == \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        enterLocationField.text = place.name
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        Alerts.showAlert(controller: self, title: "Error", message: error.localizedDescription) { (Ok) in
            
        }
        print (error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: true, completion: nil)
    }
}
