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
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (var user: PFUser?, error: NSError?) -> Void in
            
            if(error != nil)
            {
                print("Error!!!\n")
                return
            }
            
            print(user)
            print("Current user token =\(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("Current user ID =\(FBSDKAccessToken.currentAccessToken().userID)")
            
            if(FBSDKAccessToken.currentAccessToken() != nil)
            {
                user = PFUser.currentUser()
                user?.setObject("Host", forKey: "user_type")
                self.performSegueWithIdentifier("ContributeSegue", sender: nil)
            }
        })
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
