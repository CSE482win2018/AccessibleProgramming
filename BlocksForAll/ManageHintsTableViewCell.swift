//
//  ManageHintsTableViewCell.swift
//  BlocksForAll
//
//  Created by Alex Davis on 2/24/18.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit

class ManageHintsTableViewCell: UITableViewCell {

    @IBOutlet weak var hintText: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
