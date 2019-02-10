//
//  NearStationViewController.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/31.
//  Copyright © 2019 JayChung. All rights reserved.
//
import UIKit
import GoogleMobileAds

class NearStationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var textWillAppear: String = ""
    var locationStationID: Int = 0
    
    var trainDepart: [String]?
    var trainDestination: [String]?
    var trainArrivalTime: [String]?
    var trainType: [String]?
    var trainNo: [String]?
    var trainDirection: [Int]?
    
    //    self.trainDepart.append(data2.stringValue)
    //    self.trainDestination.append(data3.stringValue)
    //    self.trainArrivalTime.append(data4.stringValue)
    //    self.trainType.append(data5.stringValue)
    
    //GAD
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var distanceText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceText.text = "車站:\(textWillAppear)"
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 80
        tableView.allowsSelection = false
        
        //Ads set
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    
    
}



extension NearStationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trainDepart?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NearTableViewCell
        
//        let depart = trainDepart?[indexPath.row]
        let destination = trainDestination?[indexPath.row] ?? "無資料"
        let arrivalTime = trainArrivalTime?[indexPath.row] ?? "無資料"
        let type = trainType?[indexPath.row] ?? "無資料"
        let direction = trainDirection?[indexPath.row] ?? 0
        
        if let no = trainNo?[indexPath.row]
        {
            
            cell.trainNo.text = "\(no)"
            switch type {
            case "區間車": cell.trainType.textColor = UIColor(red: 28/255, green: 125/255, blue: 69/255, alpha: 1)
            case "區間快": cell.trainType.textColor = UIColor(red: 28/255, green: 125/255, blue: 69/255, alpha: 1)
            case "自強(推拉式自強號且無自行車車廂)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            case "自強(推拉式自強號)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            case "自強(普悠瑪)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
            case "自強(太魯閣)": cell.trainType.textColor = UIColor(red: 225/255, green: 100/255, blue: 33/255, alpha: 1)
                
            default:
                cell.trainType.textColor = UIColor.black
            }
            cell.trainType.text = "\(type)"
            cell.trainTime.text = "\(arrivalTime)"
            cell.trainWhere.text = "終點站: \(destination)"
            
            switch direction {
            case 0 : cell.trainDirectionImage.image = UIImage(named: "clockwise")
            case 1 : cell.trainDirectionImage.image = UIImage(named: "counterwise")
            default:
                print("Error in image")
            }
            
        }else{
            print("Not catch the value of name in item")
        }
        
        return cell
        
    }
    

    
}
