//
//  NearStationViewController.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/31.
//  Copyright © 2019 JayChung. All rights reserved.
//
import UIKit
import GoogleMobileAds
import Alamofire
import SwiftyJSON



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
    

    //GAD
    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var distanceText: UILabel!
    
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
        
        distanceText.text = "車站:\(textWillAppear)"
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 80
        
        //Ads set
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    
    
    func resetDataArray() {
        destinationStation = []
        destinationArrivalTime = []
        print("Reset in NearStationViewController triggered")
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
        print("Now on NearStationViewController")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        detailTrainNo = trainNo![indexPath.row]
        
        //alamofire here and pss data to startEnd and table
        
        APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/TrainNo/"+"\(detailTrainNo)"+"/TrainDate/"+"\(detailSelectedDate)"+"?$top=30&$format=JSON"
        
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
                    
                    self.performSegue(withIdentifier: "goToTRADetail2",sender: nil)
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
        
        if segue.destination is TRADetailViewController {
            let vc = segue.destination as? TRADetailViewController
            
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
