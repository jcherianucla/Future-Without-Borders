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
    
    @IBOutlet weak var geoLocation: UILabel!
    @IBOutlet weak var numberInFamily: UILabel!
    @IBOutlet weak var refugeeLocation: MKMapView!
    @IBOutlet weak var distanceAway: UILabel!
    
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
    @IBAction func provideAidButton(sender: AnyObject)
    {
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
                                        self.refugeeData!["distance"] = self.distanceAway.text
                                        self.refugeeData!["host"] = firstName + " " + lastName + ", " + address + ", " + location + ", " + number
                                        innerObject.saveInBackground()
                                        
                                        let message = "You have become a Host for a Family."
                                        if #available(iOS 8.0, *)
                                        {
                                            let helped = UIAlertController(title: "Congratulations", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                                            helped.addAction(UIAlertAction(title: "Help another Family", style: .Default, handler: { (action) -> Void in
                                                //
                                            }))
                                            self.presentViewController(helped, animated: true, completion: nil)
                                        } else
                                        {
                                            // Fallback on earlier versions
                                        }
                                        
                                        
                                    }
                                    else
                                    {
                                        let message = "This family has already found shelter."
                                        if #available(iOS 8.0, *)
                                        {
                                            let helped = UIAlertController(title: "Woah!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                                            helped.addAction(UIAlertAction(title: "Help another Family", style: .Default, handler: { (action) -> Void in
                                                //
                                            }))
                                            self.presentViewController(helped, animated: true, completion: nil)
                                        } else
                                        {
                                            // Fallback on earlier versions
                                        }
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

    
}

