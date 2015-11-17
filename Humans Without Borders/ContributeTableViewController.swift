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
        
                
    }
    @IBAction func Logout(sender: AnyObject) {
        UIApplication.sharedApplication().keyWindow!.rootViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
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
            cell.label.text = "Donate to support the Cause"
        }
        else {
            cell.label.text = "Find out more about this Crisis"
        }
        cell.delegate = self
        return cell
    }
    func pressedImage(index:Int) {
        if (index == 1 ){
            performSegueWithIdentifier("ContributeToHostfamilySegue", sender: self)
        }
        else if (index == 2 ){
            performSegueWithIdentifier("ContributeToDonateSegue", sender: self)
        }
    }
}
