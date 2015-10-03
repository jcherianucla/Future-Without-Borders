//
//  ContributeTableViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

class ContributeTableViewController: UITableViewController, Contribute{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Main Blurred BG"));
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
                    
                })
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.bounds.height / 3.5)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContributeTableViewCell
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.imageBG.image = UIImage(named: "Contribute BG \(indexPath.row+1)")
        cell.id = indexPath.row + 1
        if indexPath.row == 0 {
            cell.label.text = "Host a Family"
        }
        else if indexPath.row == 1 {
            cell.label.text = "Donate to a Host Family"
        }
        else {
            cell.label.text = "Find out more about this Crisis"
        }
        cell.delegate = self
        return cell
    }
    func pressedImage() {
        performSegueWithIdentifier("ContributeToHostfamilySegue", sender: self)
    }
}
