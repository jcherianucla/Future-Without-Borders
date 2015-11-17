//
//  ContributeTableViewCell.swift
//  Humans Without Borders
//
//  Created by Akhil Nadendla on 10/3/15.
//  Copyright © 2015 Humans Without Borders. All rights reserved.
//

import UIKit

protocol Contribute {
    func pressedImage(index: Int)
}

class ContributeTableViewCell: UITableViewCell {

    @IBOutlet var imageBG: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var CellPressed: UIButton!
    var id: Int? = nil
    
    var delegate: Contribute? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func cellPressed(sender: AnyObject) {
        if id == 1 {
            if (delegate != nil) {
                delegate!.pressedImage(1)
            }
        }
        if id == 2 {
            if (delegate != nil) {
                delegate!.pressedImage(2)
            }
        }
        if id == 3 {
            UIApplication.sharedApplication().openURL(NSURL(string:"https://www.youtube.com/watch?v=RvOnXh3NN9w")!)
        }
    }

}
