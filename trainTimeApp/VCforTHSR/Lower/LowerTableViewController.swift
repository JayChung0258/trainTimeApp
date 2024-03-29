//
//  LowerTableViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LowerTableViewController: UITableViewController {
    
    //row data
    var trainNo: [String]?
    var trainArrivalTime: [String]?
    
    //data to detail
    var detailSelectedDate = ""
    var detailTrainNo = ""
    var detailStart = ""
    var detailEnd = ""
    //data to detail table
    var destinationStation: [String] = []
    var destinationArrivalTime: [String] = []
    
    //api
    var APIUrl = ""
    
    //activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }
    
    
    func resetDataArray() {
        destinationStation = []
        destinationArrivalTime = []
        print("Reset in LowerTableViewController triggered")
    }
    
    //activity
    fileprivate func startAnimating() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetDataArray()
        print("Now on LowerTableViewController")
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        detailTrainNo = trainNo![indexPath.row]
        
        //alamofire here and pss data to startEnd and table
        
        APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/TrainNo/"+"\(detailTrainNo)"+"/TrainDate/"+"\(detailSelectedDate)"+"?$top=30&$format=JSON"
        
        let request = setUpUrl(APIUrl: APIUrl)
        
        print("\(APIUrl)")
        
        //loading animatind and ignore user tap
        self.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        Alamofire.request(request).responseJSON { response in
            do{
                print(Thread.isMainThread)
                let json: JSON = try JSON(data: response.data!)
                
                if let result = json.array {
                    for data in result {
                        
                        let data2 = data["DailyTrainInfo"]["StartingStationName"]["Zh_tw"]
                        let data3 = data["DailyTrainInfo"]["EndingStationName"]["Zh_tw"]
                        
                        self.detailStart = data2.stringValue
                        self.detailEnd = data3.stringValue
                        
                        //detail table data
                        let InnerData = data["StopTimes"].arrayValue
                        for data in InnerData {
                            let data4 = data["StationName"]["Zh_tw"]
                            let data5 = data["ArrivalTime"]
                            print(data4)
                            self.destinationStation.append(data4.stringValue)
                            self.destinationArrivalTime.append(data5.stringValue)
                            
                        }
                        
                        
                    }
                    
                    self.performSegue(withIdentifier: "goToTHSRDetail2",sender: nil)
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                    
                else{
                    print("Connect error")
                    //alert
                    let alert = UIAlertController(title: "查無資料", message: "無法查詢歷史資料", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "確定", style: .default) { (action) in
                        
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
            catch{
                print("ERROR in json \(error)")
                
                let alert = UIAlertController(title: "請查看網路設定", message: "No Internet Connect!", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "確定", style: .default) { (action) in
                    
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
        
        //////////////////
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetailViewController {
            let vc = segue.destination as? DetailViewController
            
            vc?.detailSelectedDate = self.detailSelectedDate
            vc?.detailTrainNo = self.detailTrainNo
            vc?.detailStart = self.detailStart
            vc?.detailEnd = self.detailEnd
            
            vc?.destinationStation = self.destinationStation
            vc?.destinationArrivalTime = self.destinationArrivalTime
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }



}
