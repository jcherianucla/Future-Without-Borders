//
//  EditViewController.swift
//  Humans Without Borders
//
//  Created by Jahan Cherian on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var adressField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var emailField: UITextField!

    
    var activityInicator = UIActivityIndicatorView()
    
    @IBOutlet weak var peopleField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    
    var userData:PFObject? = nil
    var userPic:PFFile? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressField.userInteractionEnabled = true
        numberField.userInteractionEnabled = true
        peopleField.userInteractionEnabled = true
        emailField.userInteractionEnabled = true
        locationField.userInteractionEnabled = true
        
        activityInicator = UIActivityIndicatorView(frame: self.view.frame)
        activityInicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityInicator.center = self.view.center
        activityInicator.hidesWhenStopped = true
        activityInicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityInicator)
        activityInicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let query = PFUser.query()
        query!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                self.userData = object
                let firstName:String = self.userData!["first_name"] as! String
                let secondName:String = self.userData!["last_name"] as! String
                self.helloLabel.text = "Hello, " + firstName + " " + secondName
                self.userPic = self.userData!["profile_picture"] as! PFFile
                self.adressField.text! = self.userData!["address"] as! String
                self.numberField.text! = self.userData!["phone_number"] as! String
                self.peopleField.text! = self.userData!["max_people"] as! String
                self.emailField.text! = self.userData!["email"] as! String
                self.locationField.text! = self.userData!["location"] as! String
                self.userPic!.getDataInBackgroundWithBlock { (data , error) -> Void in
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
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func Save() {
        print("SUBMITTING SUBMITTING")
        let query3 = PFUser.query() //PFQuery(className:"GameScore")
        query3!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                object["address"] = self.adressField.text!
                object["phone_number"] = self.numberField.text!
                object["location"] = self.locationField.text!
                object["max_people"] = self.peopleField.text!
                if (self.isValidEmail(self.emailField.text!))
                {
                    object["email"] = self.emailField.text!
                    object.saveInBackground()
                    print(object)
                    if(self.adressField.text!.characters.count > 0 && self.numberField.text!.characters.count > 0 && self.locationField.text!.characters.count > 0 && self.peopleField.text!.characters.count > 0)
                    {
                        //self.performSegueWithIdentifier("SetuserdataToContributeSegue", sender: self)
                    }
                    else
                    {
                        let message = "Please fill out all fields!"
                        if #available(iOS 8.0, *)
                        {
                            let missingCharacters = UIAlertController(title: "Empty Fields!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                            missingCharacters.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                                //
                            }))
                            self.presentViewController(missingCharacters, animated: true, completion: nil)
                        }
                        else{
                            //Fallback to earlier versions
                        }
                    }
                }
                else
                {
                    let message = "Please enter a valid email address!"
                    if #available(iOS 8.0, *)
                    {
                        let emailValidation = UIAlertController(title: "Invalid Email", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        emailValidation.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                            self.adressField.text! = ""
                            self.numberField.text! = ""
                            self.locationField.text! = ""
                            self.emailField.text! = ""
                            self.peopleField.text! = ""
                            
                        }))
                        self.presentViewController(emailValidation, animated: true, completion: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
            }
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewDidDisappear(animated: Bool) {
        print("SAVE!")
        Save()
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
