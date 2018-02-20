//
//  ManageActivitiesTableViewCell.swift
//  BlocksForAll
//
//  Created by Alex Davis on 2/19/18.
//  Copyright © 2018 Lauren Milne. All rights reserved.
//

import UIKit

class ManageActivitiesTableViewCell: UITableViewCell {
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
