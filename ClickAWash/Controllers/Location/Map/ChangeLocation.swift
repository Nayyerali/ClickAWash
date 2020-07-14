//
//  ChangeLocation.swift
//  ClickAWash
//
//  Created by Nayyer Ali on 6/14/20.
//  Copyright © 2020 NayyerAli. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces


protocol ChangeLocationDelegate {
    
    func newLocationDetail (newLocation:String)
}

class ChangeLocation: UIViewController {
    
    @IBOutlet weak var mapViewOut: GMSMapView!
    @IBOutlet weak var searchLocationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var changeLocationProtocol : ChangeLocationDelegate?
    
    @IBAction func changeLocationBtnPressed(_ sender: Any) {
        
        changeLocationProtocol?.newLocationDetail(newLocation: searchLocationField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enterLocationFieldTapped(_ sender: Any) {
        
        searchLocationField.resignFirstResponder()
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        present(autoCompleteController, animated: true)
    }
}

extension ChangeLocation: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let _:CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
    }
}

extension ChangeLocation: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
        self.mapViewOut.clear()
        searchLocationField.text = place.name
        
        let coordinates = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        let marker          =   GMSMarker()
        marker.position     =   coordinates
        marker.title        =   "Location"
        marker.snippet      =   place.name
        marker.map          =   self.mapViewOut
        
        self.mapViewOut.camera  =   GMSCameraPosition.camera(withTarget: coordinates, zoom: 15)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        Alerts.showAlert(controller: self, title: "Error", message: error.localizedDescription) { (Ok) in
        }
        return
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

