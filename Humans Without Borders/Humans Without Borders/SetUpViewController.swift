//
//  SetUpViewController.swift
//  Humans Without Borders
//
//  Created by Jahan Cherian on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit
import Parse

class SetUpViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var welcomeText: UILabel!
    
    var activityInicator = UIActivityIndicatorView()
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var homeNumTextField: UITextField!
    @IBOutlet weak var cellNumTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var maxPeopleTextField: UITextField!
    
    let myUser = PFUser.currentUser()
    var userData: PFObject? = nil
    var imageFile: PFFile? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityInicator = UIActivityIndicatorView(frame: self.view.frame)
        activityInicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityInicator.center = self.view.center
        activityInicator.hidesWhenStopped = true
        activityInicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityInicator)
        activityInicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var query2 = PFUser.query()
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
        }
        
        
        // Do any additional setup after loading the view.
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(sender: AnyObject) {
        let address:String? = addressTextField.text!
        let phoneNum:String? = homeNumTextField.text!
        let cellNum:String? = cellNumTextField.text!
        let email:String? = emailTextField.text!
        let people:String? = maxPeopleTextField.text!
        
        if(address != nil)
        {
            myUser?.setObject(address!, forKey: "address")
        }
        if(phoneNum != nil)
        {
            myUser?.setObject(phoneNum!, forKey: "home_number")
        }
        if(cellNum != nil)
        {
            myUser?.setObject(cellNum!, forKey: "cell_number")
        }
        if(email != nil)
        {
            myUser?.setObject(email!, forKey: "email")
        }
        if(people != nil)
        {
            myUser?.setObject(people!, forKey: "capacity")
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
