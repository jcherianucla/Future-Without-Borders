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

class HostFamilyViewController: UIViewController {

    @IBOutlet weak var geoLocation: UILabel!
    @IBOutlet weak var numberInFamily: UILabel!
    @IBOutlet weak var refugeeLocation: MKMapView!
    @IBOutlet weak var distanceAway: UILabel!
    
    var latitude = String()
    var longitude = String()
    var numberOfFamilyMembers = String()
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        
        loadInitialData()
        refugeeLocation.addAnnotations(artworks)
        
        refugeeLocation.delegate = self
        
        // show artwork on map
        //    let artwork = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park",
        //      discipline: "Sculpture", coordinate: CLLocationCoordinate2D(latitude: 21.283921,
        //        longitude: -157.831661))
        //    mapView.addAnnotation(artwork)
    }
    
    var artworks = [Artwork]()
    func loadInitialData() {
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        var readError : NSError?
        var data: NSData = try! NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
        
        // 2
        var error: NSError?
        let jsonObject: AnyObject!
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions(rawValue: 0))
        } catch var error1 as NSError {
            error = error1
            jsonObject = nil
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject] where error == nil,
            // 4
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
                for artworkJSON in jsonData {
                    if let artworkJSON = artworkJSON.array,
                        // 5
                        artwork = Artwork.fromJSON(artworkJSON) {
                            artworks.append(artwork)
                    }
                }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        refugeeLocation.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - location manager to authorize user location for Maps app
    //  var locationManager = CLLocationManager()
    //  func checkLocationAuthorizationStatus() {
    //    if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
    //      mapView.showsUserLocation = true
    //    } else {
    //      locationManager.requestWhenInUseAuthorization()
    //    }
    //  }
    //  
    //  override func viewDidAppear(animated: Bool) {
    //    super.viewDidAppear(animated)
    //    checkLocationAuthorizationStatus()
    //  }
    
}

