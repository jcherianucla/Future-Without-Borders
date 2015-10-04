//
//  SecondViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/2/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var profilePicture: UIImageView!
    
    var activityInicator = UIActivityIndicatorView()
    var manager: CLLocationManager!
    @IBOutlet weak var maxPeopleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var geolocationLabel: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    var userData: PFObject? = nil
    var imageFile: PFFile? = nil
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // load()
        
        }
        func load()
        {
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            if #available(iOS 8.0, *) {
                manager.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
            }
            manager.startUpdatingLocation()
            
            
            
            activityInicator = UIActivityIndicatorView(frame: self.view.frame)
            activityInicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityInicator.center = self.view.center
            activityInicator.hidesWhenStopped = true
            activityInicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityInicator)
            activityInicator.startAnimating()
            
            let dashboardQuery = PFUser.query()
            dashboardQuery!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
                (object: PFObject?, error: NSError?) -> Void in
                if error == nil && object != nil {
                    print(object)
                    self.userData = object
                    let firstName:String = self.userData!["first_name"] as! String
                    let secondName:String = self.userData!["last_name"] as! String
                    self.helloLabel.text = "Hello, " + firstName + " " + secondName
                    self.addressLabel.text = self.userData!["address"] as? String
                    self.phoneNumLabel.text = self.userData!["phone_number"] as? String
                    self.maxPeopleLabel.text = self.userData!["max_people"] as? String
                    self.emailLabel.text = self.userData!["email"] as? String
                    self.locationLabel.text = self.userData!["location"] as? String
                    self.imageFile = self.userData!["profile_picture"] as! PFFile
                    self.imageFile!.getDataInBackgroundWithBlock { (data , error) -> Void in
                        if let downloadedImage = UIImage(data: data!) {
                            self.activityInicator.stopAnimating()
                            self.profilePicture!.image = downloadedImage
                            self.profilePicture.layer.cornerRadius = (downloadedImage.size.width + downloadedImage.size.height)/12
                            self.profilePicture.layer.borderWidth = 2
                            self.profilePicture.layer.borderColor = UIColor.whiteColor().CGColor
                            self.profilePicture.layer.masksToBounds = true
                            
                        }
                    }
                    
                } else {
                    print(error)
                }

    }
        func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            self.geolocationLabel.text = "\(locValue.latitude), \(locValue.longitude)"
            
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
    }
    
}