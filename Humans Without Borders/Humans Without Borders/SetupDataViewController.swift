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
    
    
    func load()
    {
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
                self.userData = object
                let firstName:String = self.userData!["first_name"] as! String
                let secondName:String = self.userData!["last_name"] as! String
                self.welcomeText.text = "Welcome, " + firstName + " " + secondName
                self.imageFile = self.userData!["profile_picture"] as? PFFile
                self.imageFile!.getDataInBackgroundWithBlock { (data , error) -> Void in
                    if let downloadedImage = UIImage(data: data!) {
                        self.activityInicator.stopAnimating()
                        self.profilePic!.image = downloadedImage
                        self.profilePic.layer.cornerRadius = (downloadedImage.size.width + downloadedImage.size.height)/12
                        self.profilePic.layer.borderWidth = 2
                        self.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
                        self.profilePic.layer.masksToBounds = true
                    }
                }
                
            } else {
                print(error)
            }
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addressTextField.userInteractionEnabled = true
        PhoneTextField.userInteractionEnabled = true
        MaxPeopleTextfield.userInteractionEnabled = true
        EmailTextField.userInteractionEnabled = true
        LocationTextField.userInteractionEnabled = true
        
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Submit(sender: AnyObject) {
        print("SUBMITTING SUBMITTING SETUP")
        let query3 = PFUser.query() //PFQuery(className:"GameScore")
        query3!.getObjectInBackgroundWithId(PFUser.currentUser()!.objectId!) {
            (object, error) -> Void in
            if error != nil {
                print(error)
            } else if let object = object {
                object["address"] = self.addressTextField.text!
                if(self.isValidPhoneNumber(self.PhoneTextField.text!))
                {
                    object["phone_number"] = self.PhoneTextField.text!
                }
                else
                {
                    self.throwAlert("Please enter a valid Phone Number!", msgTitle: "Invalid Phone Number", msgEnd: "Ok", clearFields: false, clearText: self.PhoneTextField)
                }
                object["location"] = self.LocationTextField.text!
                object["max_people"] = self.MaxPeopleTextfield.text!
                if (self.isValidEmail(self.EmailTextField.text!))
                {
                    object["email"] = self.EmailTextField.text!
                    object.saveInBackground()
                    print(object)
                    if(self.addressTextField.text!.characters.count > 0 && self.PhoneTextField.text!.characters.count > 0 && self.LocationTextField.text!.characters.count > 0 && self.MaxPeopleTextfield.text!.characters.count > 0)
                    {
                        self.performSegueWithIdentifier("SetuserdataToContributeSegue", sender: self)
                    }
                    else
                    {
                        self.throwAlert("Please fill out all fields!", msgTitle: "Missing Fields", msgEnd: "Ok", clearFields: true, clearText: self.PhoneTextField)
                    }
                }
                else
                {
                    self.throwAlert("Please enter a valid Email Address!", msgTitle: "Invalid Email", msgEnd: "Ok", clearFields: false, clearText: self.EmailTextField)
                }
                
            }
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func isValidPhoneNumber(phoneNum: String) -> Bool
    {
        let phoneNumbRegEx = "\\+?(\\d{1,3})?\\d{10,15}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumbRegEx)
        return phoneTest.evaluateWithObject(phoneNum)
        
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
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func throwAlert(msg:String, msgTitle: String, msgEnd: String, clearFields: Bool, clearText: UITextField)
    {
        let message = msg
        if #available(iOS 8.0, *)
        {
            let emailValidation = UIAlertController(title: msgTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            emailValidation.addAction(UIAlertAction(title: msgEnd, style: .Default, handler: { (action) -> Void in
                if (clearFields == true)
                {
                    self.addressTextField.text! = ""
                    self.PhoneTextField.text! = ""
                    self.LocationTextField.text! = ""
                    self.EmailTextField.text! = ""
                    self.MaxPeopleTextfield.text! = ""
                }
                else
                { clearText.text! = "" }
                
            }))
            self.presentViewController(emailValidation, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
}
