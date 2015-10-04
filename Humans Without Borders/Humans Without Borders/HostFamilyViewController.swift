//
//  HostFamilyViewController.swift
//  Humans Without Borders
//
//  Created by Jahan Cherian on 10/4/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HostFamilyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var geoLocation: UILabel!
    @IBOutlet weak var numberInFamily: UILabel!
    @IBOutlet weak var refugeeLocation: MKMapView!
    @IBOutlet weak var distanceAway: UILabel!
    
    var latitude:String? = nil
    var longitude:String? = nil
    var numberOfFamilyMembers:String? = nil
    var refugeeLatitude: CLLocationDegrees? = nil
    var refugeeLongitude: CLLocationDegrees? = nil
    var numberOfFamMembers: Int? = nil
    
    
    let regionRadius: CLLocationDistance = 1000
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refugeeLatitude = (latitude! as NSString).doubleValue
        refugeeLongitude = (longitude! as NSString).doubleValue
        numberOfFamMembers = (numberOfFamilyMembers! as NSString).integerValue


        numberInFamily.text = "Number of Family Members \(numberOfFamMembers!)"
        geoLocation.text = "Geolocation: \(refugeeLatitude!), \(refugeeLongitude!)"
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    func checkLocationAuthorizationStatus() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                refugeeLocation.showsUserLocation = true
                locationManager.startUpdatingLocation()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //this is the place where you get the new location
            print("\(location.coordinate.latitude)")
            
            print("\(location.coordinate.longitude)")
            
            let initialLocation = CLLocation(latitude: refugeeLatitude!, longitude: refugeeLongitude!)
            centerMapOnLocation(initialLocation)
            let locationQ = CLLocationCoordinate2DMake(refugeeLatitude!, refugeeLongitude!)
            let meters:CLLocationDistance =  (location.distanceFromLocation(initialLocation))
            let distanceInt = Int(meters)
            distanceAway.text = "Distance to Refugee: \(distanceInt/1000) KM"
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationQ
            annotation.title = "Location of Refugee(s)"
            refugeeLocation.addAnnotation(annotation)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        refugeeLocation.setRegion(coordinateRegion, animated: true)
    }
    
    
}

