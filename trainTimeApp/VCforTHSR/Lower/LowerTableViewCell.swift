//
//  LowerTableViewCell.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class LowerTableViewCell: UITableViewCell {

    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var trainArrivalTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
