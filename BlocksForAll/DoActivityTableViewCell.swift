//
//  DoActivityTableViewCell.swift
//  BlocksForAll
//
//  Created by Kathryn Chan on 25/02/2018.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit

class DoActivityTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
