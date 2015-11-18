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
import Parse


class HostFamilyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var userData: PFObject? = nil
    var refugeeData: PFObject? = nil
    var latitude:String? = nil
    var longitude:String? = nil
    var numberOfFamilyMembers:String? = nil
    var refugeeLatitude: CLLocationDegrees? = nil
    var refugeeLongitude: CLLocationDegrees? = nil
    var numberOfFamMembers: Int? = nil
    var selection: Bool? = nil
    var host: String? = nil
    var objectID: String? = nil
    var distanceInt = Int()
    
    @IBOutlet weak var geoLocation: UILabel!
    @IBOutlet weak var numberInFamily: UILabel!
    @IBOutlet weak var refugeeLocation: MKMapView!
    @IBOutlet weak var distanceAway: UILabel!
    
    
    
    let regionRadius: CLLocationDistance = 1000
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refugeeLocation.delegate = self
        print(latitude)
        print(longitude)
        print((latitude! as NSString).doubleValue)
        print((longitude! as NSString).doubleValue)
        var temp1 = (latitude! as NSString).doubleValue
        if temp1 > 80 || temp1 < -80
        {
            temp1 = 70;
        }
        var temp2 = (longitude! as NSString).doubleValue
        if temp2 > 160 || temp2 < -160
        {
            temp2 = 150
        }
        refugeeLatitude = temp1
        refugeeLongitude = temp2
        numberOfFamMembers = (numberOfFamilyMembers! as NSString).integerValue
        
        
        numberInFamily.text = "Number of Family Members \(numberOfFamMembers!)"
        geoLocation.text = "Geolocation: \(refugeeLatitude!), \(refugeeLongitude!)"
        
        
        let initialLocation = CLLocation(latitude: refugeeLatitude!, longitude: refugeeLongitude!)
        centerMapOnLocation(initialLocation)
        let annotation = MKPointAnnotation()
        annotation.coordinate = initialLocation.coordinate
        annotation.title = "Location of Refugee(s)"
        refugeeLocation.addAnnotation(annotation)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
            let request = MKDirectionsRequest()
            request.source = MKMapItem.mapItemForCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: refugeeLatitude!, longitude: refugeeLongitude!), addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .Automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                for route in unwrappedResponse.routes {
                    self.refugeeLocation.addOverlay(route.polyline)
                    self.refugeeLocation.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        // draw the track
        let polyLine = overlay
        let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
        polyLineRenderer.strokeColor = UIColor.blueColor()
        polyLineRenderer.lineWidth = 2.0
        
        return polyLineRenderer
    }
    
    func checkLocationAuthorizationStatus()
    {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            refugeeLocation.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        refugeeLocation.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            //this is the place where you get the new location
            let initialLocation = CLLocation(latitude: refugeeLatitude!, longitude: refugeeLongitude!)
            let meters:CLLocationDistance =  (location.distanceFromLocation(initialLocation))
            distanceInt = Int(meters)
            distanceAway.text = "Distance to Refugee: \(distanceInt/1000) KM"
            
        }
    }
    
    
    @IBAction func provideAidButton(sender: AnyObject) {
        print("OBJECT IDDDDDDDDDDDDD: " + objectID!)
        let query = PFUser.query()
        query!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!){ (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil
            {
                self.userData = object
                let firstName = self.userData!["first_name"] as! String
                let lastName = self.userData!["last_name"] as! String
                let address = self.userData!["address"] as! String
                let location = self.userData!["location"] as! String
                let number = self.userData!["phone_number"] as! String
                print(object)
                let refugeeQuery = PFQuery(className: "Refugees")
                refugeeQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if error == nil {
                        // The find succeeded.
                        // Do something with the found objects
                        if let objects = objects as [PFObject]!
                        {
                            for innerObject in objects
                            {
                                print(innerObject)
                                print(String(self.objectID))
                                if(String(innerObject.objectId) == String(self.objectID!))
                                {
                                    self.refugeeData = innerObject
                                    print("THE INNER OBJECT IS: " + String(innerObject))
                                    let decider:Bool? = self.refugeeData!["selected"] as? Bool
                                    if(decider! == false)
                                    {
                                        self.refugeeData!["selected"] = true
                                        self.refugeeData!["host"] = firstName + " " + lastName + ", " + address + ", " + location + ", " + number
                                        innerObject.saveInBackground()
                                        
                                        self.throwAlert("Congratulations", msgTitle: "You have become a Host for a Family.", msgEnd: "Help another Family")
                                    }
                                    else
                                    {
                                        self.throwAlert("Note!", msgTitle: "This family has already found shelter.", msgEnd: "Help another Family")
                                    }
                                }
                            }
                        }
                    } else
                    {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            }
        }
    }
    
    func throwAlert(msg:String, msgTitle: String, msgEnd: String)
    {
        let message = msg
        if #available(iOS 8.0, *)
        {
            let alerter = UIAlertController(title: msgTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alerter.addAction(UIAlertAction(title: msgEnd, style: .Default, handler: { (action) -> Void in
                //
            }))
            self.presentViewController(alerter, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

