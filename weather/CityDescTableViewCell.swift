//
//  CityDescTableViewCell.swift
//  weather
//
//  Created by codinghands on 01/10/19.
//  Copyright © 2019 codinghands. All rights reserved.
//

import UIKit

class CityDescTableViewCell: UITableViewCell {

    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var climateimageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
