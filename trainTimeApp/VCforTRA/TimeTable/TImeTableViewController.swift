//
//  TImeTableViewController.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/30.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class TImeTableViewController: UITableViewController {

    //row data
    var trainNo: [Int]?
    var stationName: [String]?
    var startArrivalTime: [String]?
    var endArrivalTime: [String]?
    var trainTypeID: [String]?
    var trainTimeInterval: [String]?
    
    //title
    var formerStation: String = ""
    var laterStation: String = ""
    
    let trainCell = TrainTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
        tableView.allowsSelection = false
        
        if formerStation != "" {
            self.title = "\(formerStation)至\(laterStation)"
        }else{
            self.title = "列車時刻"
        }
        
        
    }
    
    func resetDataArray() {
        trainNo = []
        stationName = []
        startArrivalTime = []
        endArrivalTime = []
        trainTypeID = []
        trainTimeInterval = []
        print("Reset in List method triggered")
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (trainNo?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainTableViewCell
        
        if let no = trainNo?[indexPath.row], let sat = startArrivalTime?[indexPath.row], let eat = endArrivalTime?[indexPath.row], let typeID = trainTypeID?[indexPath.row], let interval = trainTimeInterval?[indexPath.row]
        {
            cell.trainNo.text = "\(no)"
            cell.trainTime.text = "\(sat)~\(eat)"
            switch typeID {
            case "區間車": cell.trainType.textColor = UIColor(red: 28/255, green: 125/255, blue: 69/255, alpha: 1)
            case "區間快": cell.trainType.textColor = UIColor(red: 28/255, green: 125/255, blue: 69/255, alpha: 1)
            case "自強(推拉式自強號且無自行車車廂)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            case "自強(推拉式自強號)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            case "自強(普悠瑪)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            case "自強(太魯閣)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            
            default:
                cell.trainType.textColor = UIColor.black
            }
            cell.trainType.text = typeID
            cell.trainTimeInterval.text = interval
        }else{
            print("Not catch the value of name in item")
        }
        
        return cell
    }
    

   

}
