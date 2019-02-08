//
//  DetailViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/8.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var startAndend: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //detail data
    var detailSelectedDate = ""
    var detailTrainNo = ""
    var detailStart = ""
    var detailEnd = ""
    
    //detail table data
    var destinationStation:[String] = []
    var destinationArrivalTime:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateText.text = "日期:\(detailSelectedDate)"
        trainNo.text = "車次:\(detailTrainNo)"
        startAndend.text = "起迄站:\(detailStart)~\(detailEnd)"
        
    }
    

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationStation.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailViewCell
        
        cell.destinationStation.text = destinationStation[indexPath.row]
        cell.destinationArrivalTime.text = destinationArrivalTime[indexPath.row]
        
        
        return cell
        
        
    }
    
    
}
