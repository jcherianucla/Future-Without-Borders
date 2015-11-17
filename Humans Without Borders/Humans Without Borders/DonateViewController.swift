//
//  DonateViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 11/17/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

class DonateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func GoToAidOtherGroups(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://onetoday.google.com/page/refugeerelief")!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
