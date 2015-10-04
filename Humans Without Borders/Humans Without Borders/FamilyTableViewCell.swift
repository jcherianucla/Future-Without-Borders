//
//  FamilyTableViewCell.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit


protocol Host {
    func PressedButtonToGotoHost(lat: String, lon: String, famNum: String)
}

class FamilyTableViewCell: UITableViewCell {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var numberFamilyMembersLabel: UILabel!
    @IBOutlet var FamilyNameLabel: UILabel!
    
    var longitude: String? = nil
    var latitude: String? = nil
    var famNum: String? = nil
    var delegate: Host? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func ButtonPressed(sender: AnyObject) {
        print("PRESSED BUTTON")
        if (delegate != nil) {
            delegate!.PressedButtonToGotoHost(latitude!, lon: longitude!, famNum: famNum!)
        }
    }
}
