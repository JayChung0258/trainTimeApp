//
//  DetailViewCell.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/8.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class DetailViewCell: UITableViewCell {

    @IBOutlet weak var destinationStation: UILabel!
    @IBOutlet weak var destinationArrivalTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
