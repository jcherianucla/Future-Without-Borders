//
//  FamilyTableViewCell.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var numberFamilyMembersLabel: UILabel!
    @IBOutlet var FamilyNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
