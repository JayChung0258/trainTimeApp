//
//  TRADetailViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/10.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class TRADetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var startAndend: UILabel!
    @IBOutlet weak var type: UILabel!
    
    //detail data
    var detailSelectedDate = ""
    var detailTrainNo = ""
    var detailStart = ""
    var detailEnd = ""
    var detailType = "" 
    
    //detail table data
    var destinationStation:[String] = []
    var destinationArrivalTime:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateText.text = "日期:\(detailSelectedDate)"
        trainNo.text = "車次:\(detailTrainNo)"
        startAndend.text = "起迄站:\(detailStart)~\(detailEnd)"
        type.text = "車種:\(detailType)"
    }
    

}

extension TRADetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationStation.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TRADetailTableViewCell
        
        cell.destinationStation.text = destinationStation[indexPath.row]
        cell.destinationArrivalTime.text = destinationArrivalTime[indexPath.row]
        
        
        return cell
        
        
    }
    
    
}

