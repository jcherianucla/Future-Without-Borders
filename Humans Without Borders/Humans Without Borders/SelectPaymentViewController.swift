//
//  SelectPaymentViewController.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 11/17/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

class SelectPaymentViewController: UIViewController {
    
    @IBOutlet var fiveBtn: UIButton!
    
    @IBOutlet var tenBtn: UIButton!

    @IBOutlet var fifteenBtn: UIButton!
    
    @IBOutlet var twentyBtn: UIButton!
    
    @IBOutlet var FiftyBtn: UIButton!
    
    @IBOutlet var hundredBtn: UIButton!
    
    @IBOutlet var OtherBtn: UIButton!
    
    @IBOutlet var OtherTextField: UITextField!
    
    var blue_highlight: UIColor = UIColor(red: 108/256, green: 178/256, blue: 255/256, alpha: 1.0)
    
    @IBAction func PaymentAmountPressed(sender: AnyObject) {
        fiveBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tenBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fifteenBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        twentyBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        FiftyBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        hundredBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        OtherBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        switch(sender.tag){
        case 1:
        fiveBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        case 2:
        tenBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        case 3:
        fifteenBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        case 4:
        twentyBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        case 5:
        FiftyBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        case 6:
        hundredBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        case 7:
        OtherBtn.setTitleColor(blue_highlight, forState: UIControlState.Normal)
            break;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
