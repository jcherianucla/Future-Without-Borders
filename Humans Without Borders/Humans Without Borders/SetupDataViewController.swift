//
//  SetupDataViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit
import Parse

class SetupDataViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var welcomeText: UILabel!
    
    var activityInicator = UIActivityIndicatorView()

    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var PhoneTextField: UITextField!
    @IBOutlet var MaxPeopleTextfield: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var LocationTextField: UITextField!
    
    let myUser = PFUser.currentUser()
    var userData: PFObject? = nil
    var imageFile: PFFile? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.userInteractionEnabled = true
        PhoneTextField.userInteractionEnabled = true
        MaxPeopleTextfield.userInteractionEnabled = true
        EmailTextField.userInteractionEnabled = true
        LocationTextField.userInteractionEnabled = true
        
        activityInicator = UIActivityIndicatorView(frame: self.view.frame)
        activityInicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityInicator.center = self.view.center
        activityInicator.hidesWhenStopped = true
        activityInicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityInicator)
        activityInicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let query2 = PFUser.query()
        query2!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                print(object)
                self.userData = object
                let firstName:String = self.userData!["first_name"] as! String
                let secondName:String = self.userData!["last_name"] as! String
                self.welcomeText.text = "Welcome, " + firstName + " " + secondName
                self.imageFile = self.userData!["profile_picture"] as! PFFile
                self.imageFile!.getDataInBackgroundWithBlock { (data , error) -> Void in
                    if let downloadedImage = UIImage(data: data!) {
                        self.activityInicator.stopAnimating()
                        self.profilePic!.image = downloadedImage
                    }
                }
                
            } else {
                print(error)
            }
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Submit(sender: AnyObject) {
        print("SUBMITTING SUBMITTING")
        let query3 = PFUser.query() //PFQuery(className:"GameScore")
        query3!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                object["address"] = self.addressTextField.text!
                object["phone_number"] = self.PhoneTextField.text!
                object["location"] = self.LocationTextField.text!
                object["email"] = self.EmailTextField.text!
                object["max_people"] = self.MaxPeopleTextfield.text!
                object.saveInBackground()
            }
        }
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
