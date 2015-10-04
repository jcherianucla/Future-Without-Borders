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
    
    var latitude = String()
    var longitude = String()
    var numberOfFamilyMembers = String()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        self.locationManager.startUpdatingLocation()
        
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(1, 1))
        self.refugeeLocation.setRegion(region, animated: true)
        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
