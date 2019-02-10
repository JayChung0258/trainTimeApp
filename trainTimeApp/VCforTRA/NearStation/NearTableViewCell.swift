//
//  NearTableViewCell.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/31.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class NearTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var trainType: UILabel!
    @IBOutlet weak var trainTime: UILabel!
    @IBOutlet weak var trainWhere: UILabel!
    @IBOutlet weak var trainDirectionImage: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
