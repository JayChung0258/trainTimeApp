//
//  UpperTableViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class UpperTableViewController: UITableViewController {
    
    //row data
    var trainNo: [Int]?
    var startArrivalTime: [String]?
    var endArrivalTime: [String]?
    var trainTimeInterval: [String]?
    
    //title
    var formerStation: String = ""
    var laterStation: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
        
        if formerStation != "" {
            self.title = "\(formerStation)至\(laterStation)"
        }else{
            self.title = "列車時刻"
        }
    }
    
    func resetDataArray() {
        trainNo = []
        startArrivalTime = []
        endArrivalTime = []
        trainTimeInterval = []
        print("Reset in List method triggered")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (trainNo?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpperTableViewCell
        
        if let no = trainNo?[indexPath.row], let sat = startArrivalTime?[indexPath.row], let eat = endArrivalTime?[indexPath.row], let interval = trainTimeInterval?[indexPath.row]
        {
            cell.trainNo.text = "\(no)"
            cell.trainTime.text = "\(sat)~\(eat)"
            cell.trainTimeInterval.text = interval
        }else{
            print("Not catch the value of name in item")
        }
        
        return cell
        

    }

}
