//
//  InstagramCell.swift
//  Instagram
//
//  Created by Darrell Shi on 2/25/16.
//  Copyright © 2016 iOS Development. All rights reserved.
//

import UIKit

class InstagramCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
