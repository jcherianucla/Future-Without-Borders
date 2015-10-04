//
//  FamilyListViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit
import Parse

class FamilyListViewController: UIViewController, UITableViewDelegate , UITableViewDataSource, Host {

    @IBOutlet var TableViewFamilies: UITableView!
    
    var refugeeCount = 0
    var rufugeeDataList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TEST\n")
        print("TEST\n")
        print("TEST\n")

        self.TableViewFamilies.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
        let query = PFQuery(className:"Refugees")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                self.refugeeCount = objects!.count
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        self.rufugeeDataList.append(object)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            print(self.rufugeeDataList)
            self.TableViewFamilies.reloadData()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return refugeeCount
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FamilyTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.FamilyNameLabel.text = rufugeeDataList[indexPath.row]["fam_name"] as? String
        if cell.FamilyNameLabel.text != nil {
            cell.FamilyNameLabel.text = "Family " + cell.FamilyNameLabel.text!
        }
        else {
            cell.FamilyNameLabel.text = "Family Name Unknown"
        }
        cell.numberFamilyMembersLabel.text = rufugeeDataList[indexPath.row]["fam_number"] as? String
        if cell.numberFamilyMembersLabel.text != nil {
            cell.numberFamilyMembersLabel.text = cell.numberFamilyMembersLabel.text! + " Family Members"
        }
        else {
            cell.numberFamilyMembersLabel.text = "Family Members Unknown"
        }
        cell.distanceLabel.text = rufugeeDataList[indexPath.row]["distance"] as? String
        if cell.distanceLabel.text != nil {
            cell.distanceLabel.text = "Located " + cell.distanceLabel.text! + " km"
        }
        else {
            cell.distanceLabel.text = "Location Unkown"
        }
        cell.longitude = rufugeeDataList[indexPath.row]["long"] as? String
        cell.latitude = rufugeeDataList[indexPath.row]["lat"] as? String
        cell.famNum = rufugeeDataList[indexPath.row]["fam_number"] as? String
        var randNumb = Int(arc4random_uniform(5)) + 1
        cell.refugeeImageView?.image = UIImage(named: "Refugee Family Icon \(randNumb)")
        cell.delegate = self
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueToHostFamily" {
            if segue.identifier == "alarmToSettings" {
                let secondVC:HostFamilyViewController = segue.destinationViewController as! HostFamilyViewController
                print(templatitude)
                print(templongitude)
                print(tempnumberOfFamilyMembers)
                secondVC.latitude = templatitude
                secondVC.longitude = templongitude
                secondVC.numberOfFamilyMembers = tempnumberOfFamilyMembers
            }
        }
    }
    
    var templatitude = String()
    var templongitude = String()
    var tempnumberOfFamilyMembers = String()

    func PressedButtonToGotoHost(lat: String, lon: String, famNum: String) {
        templatitude = lat
        templongitude = lon
        tempnumberOfFamilyMembers = famNum
        performSegueWithIdentifier("SegueToHostFamily", sender: self)
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
