//
//  SubCategoryTableViewCell.swift
//  Yelp
//
//  Created by Nag Varun Chunduru on 9/23/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var subCategorySwitch: UISwitch!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
