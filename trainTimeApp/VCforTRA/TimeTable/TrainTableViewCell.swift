//
//  TrainTableViewCell.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/30.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class TrainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var trainType: UILabel!
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
