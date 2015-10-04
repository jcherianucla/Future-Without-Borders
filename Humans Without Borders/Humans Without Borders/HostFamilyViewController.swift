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
    //var myLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refugeeLatitude = (latitude! as NSString).doubleValue
        refugeeLongitude = (longitude! as NSString).doubleValue
        numberOfFamMembers = (numberOfFamilyMembers! as NSString).integerValue


        numberInFamily.text = "Number of Family Members \(numberOfFamMembers!)"
        geoLocation.text = "Geolocation: Lat: \(refugeeLatitude!), Long: \(refugeeLongitude!)"
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        //myLocation! = locationManager.location!
        var currentLocation = CLLocation!()
        
        if #available(iOS 8.0, *) {
            if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
                    
                    currentLocation = locationManager.location
                    print(currentLocation.coordinate.latitude)
            }
        } else {
            // Fallback on earlier versions
        }
        //let initialLocation = CLLocation(latitude: refugeeLatitude!, longitude: refugeeLongitude!)
        //centerMapOnLocation(initialLocation)
//        let location = CLLocationCoordinate2DMake(refugeeLatitude!, refugeeLongitude!)
//        let meters:CLLocationDistance =  (myLocation?.distanceFromLocation(initialLocation))!
//        distanceAway.text = "\(meters)"
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "Location of Refugee(s)"
        //refugeeLocation.addAnnotation(annotation)
        
        
    }
    
//    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//            regionRadius * 2.0, regionRadius * 2.0)
//        refugeeLocation.setRegion(coordinateRegion, animated: true)
//    }
    
    
}

