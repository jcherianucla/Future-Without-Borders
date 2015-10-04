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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
       
}

