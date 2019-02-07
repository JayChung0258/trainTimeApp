//
//  UpperTableViewCell.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class UpperTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var trainTime: UILabel!
    @IBOutlet weak var trainTimeInterval: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
