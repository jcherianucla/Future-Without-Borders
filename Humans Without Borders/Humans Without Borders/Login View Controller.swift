//
//  Login View Controller.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

class Login_View_Controller: UIViewController {

    @IBOutlet var TitleMain: UILabel!
    
    @IBOutlet var TitleSecondary: UILabel!
    
    @IBOutlet var LoginBtn: UIButton!
    
    @IBOutlet var SignupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInFBButton(sender: AnyObject) {
        let message = "If you are a Syrian Refugee, do not sign up for this service. Call/text +1 (669)-342-1932, and you will be given immediate help."
        
        if #available(iOS 8.0, *)
        {
            
            let alert = UIAlertController(title: "Note", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
                PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (var user: PFUser?, error: NSError?) -> Void in
                    
                    if(error != nil)
                    {
                        print("Error!!!\n")
                        return
                    }
                    
                    print(user)
                    print("Current user token =\(FBSDKAccessToken.currentAccessToken().tokenString)")
                    print("Current user ID =\(FBSDKAccessToken.currentAccessToken().userID)")
                    
                    let requestedPermissions = ["fields": "id , email , first_name, last_name, timezone"]
                    let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestedPermissions)
                    
                    userDetails.startWithCompletionHandler{ (connection, result, error: NSError!) -> Void in
                        if(error != nil)
                        {
                            print("Error!")
                            return
                        }
                        
                        if(result != nil)
                        {
                            let userID:String = result["id"] as! String
                            let userFirstName:String? = result["first_name"] as? String
                            let userLastName:String? = result["last_name"] as? String
                            let userEmail:String? = result["email"] as? String
                            let userType: String? = "Host"
                            let userLocation: String? = result["timezone"] as? String
                            
                            let myUser:PFUser = PFUser.currentUser()!
                            myUser.setObject(userType!, forKey: "user_type")
                            
                            
                            if(userFirstName != nil)
                            {
                                myUser.setObject(userFirstName!, forKey: "first_name")
                            }
                            if(userLastName != nil)
                            {
                                myUser.setObject(userLastName!, forKey: "last_name")
                            }
                            if(userEmail != nil)
                            {
                                myUser.setObject(userEmail!, forKey: "email")
                            }
                            if(userLocation != nil)
                            {
                                myUser.setObject(userLocation!, forKey: "timezone")
                            }
                            
                            let userProfile = "https://graph.facebook.com/" + userID + "/picture?type=large"
                            let profilePictureURL = NSURL(string: userProfile)
                            let profilePictureData = NSData(contentsOfURL: profilePictureURL!)
                            
                            if(profilePictureData != nil)
                            {
                                let profileFileObject = PFFile(data: profilePictureData!)
                                myUser.setObject(profileFileObject, forKey: "profile_picture")
                            }
                            
                            myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                                
                                if(success)
                                {
                                    print("User details updated in Parse Cloud")
                                    
                                }
                                self.performSegueWithIdentifier("SetTextSegue", sender: nil)
                                
                            })
                        }
                        
                    }
                })
                

            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
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
