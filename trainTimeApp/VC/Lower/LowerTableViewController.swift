//
//  LowerTableViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class LowerTableViewController: UITableViewController {
    
    //row data
    var trainNo: [Int]?
    var trainArrivalTime: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }
    
    func resetDataArray() {
        trainNo = []
        trainArrivalTime = []
        print("Reset in LowerTableViewController triggered")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (trainNo?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LowerTableViewCell
        
        if let no = trainNo?[indexPath.row], let arrival = trainArrivalTime?[indexPath.row] {
            cell.trainNo.text = "\(no)"
            cell.trainArrivalTime.text = "\(arrival)"
        }
        else {
            print("Not catch the value of name in item")
        }
        
        
        return cell
    }
    



}
