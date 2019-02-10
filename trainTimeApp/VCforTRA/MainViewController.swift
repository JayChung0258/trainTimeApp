//
//  MainViewController.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/30.
//  Copyright © 2019 JayChung. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation
import GoogleMobileAds

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timeTableButton: UIButton!
    @IBOutlet weak var nearStationButton: UIButton!
    
    
    var APIUrl = ""
    var APIUrl2 = ""
    
    //first alamofire -> locate
    var locationDistanceArray: [Double] = []
    var locationName: [String] = []
    var locationStationID: [Int] = []
    var nearStationDistance: Double = 0
    var nearStationIndexInArray: Int = 0
    
    //second alamofire -> tableList Data
    var trainDepart: [String] = []
    var trainDestination: [String] = []
    var trainArrivalTime: [String] = []
    var trainType: [String] = []
    var trainNo: [String] = []
    var trainDirection: [Int] = []
    
    //activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var userLoacation = CLLocation(latitude: 25.047503, longitude: 121.517047)
    
    var locationManager = CLLocationManager()
    
    //Ads View set
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Ads set
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        //
        timeTableButton.layer.cornerRadius = 5.0
        nearStationButton.layer.cornerRadius = 5.0
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetDataArray()
        print("Now on MainViewController")
    }
    
    func resetDataArray() {
        //first alamofire -> locate
        locationDistanceArray = []
        locationName = []
        locationStationID = []
        nearStationDistance = 0
        nearStationIndexInArray = 0
        
        //second alamofire -> tableList Data
        trainDepart = []
        trainDestination = []
        trainArrivalTime = []
        trainType = []
        trainNo = []
        trainDirection = []
        
        print("resetData in MainViewController triggered")
        
    }
    
    func startAnimating() {
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    @IBAction func timeTableButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTimeTable", sender: nil)
    }
    
    @IBAction func nearStationButtonPressed(_ sender: Any) {
        
        //loading animatind and ignore user tap
        self.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        userLoacation = locationManager.location ?? userLoacation
        
        APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/Station?$format=JSON"
        let request = setUpUrl(APIUrl: APIUrl)
        
        Alamofire.request(request).responseJSON { response in
            
            do {
                let json: JSON = try JSON(data: response.data!)
                
                if let result = json.array {
                    
                    for data in result {
                        
                        let data1 = data["StationName"]["Zh_tw"]
                        var data2 = data["StationPosition"]["PositionLon"]
                        var data3 = data["StationPosition"]["PositionLat"]
                        var data4 = data["StationID"]
                        
                        //some stations has no data -> null
                        if data2 == JSON.null {
                            data2 = 150
                            data3 = 30
                        }
                        
                        self.locationName.append(data1.stringValue)
                        self.caculate(Lon: data2.doubleValue, Lat: data3.doubleValue)
                        self.locationStationID.append(data4.intValue)
                    }
                    print(self.locationDistanceArray)
                    
                    //Inside Alamofire request
                    
                    self.nearStationDistance = self.locationDistanceArray.min() ?? 1
                    self.nearStationIndexInArray = self.locationDistanceArray.firstIndex(of: self.nearStationDistance) ?? 1
                    
                    self.APIUrl2 = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard/Station/"+"\(self.locationStationID[self.nearStationIndexInArray])"+"?$top=30&$format=JSON"
                    let request2 = setUpUrl(APIUrl: self.APIUrl2)
                    
                    Alamofire.request(request2).responseJSON { response in
                        do{
                            let json: JSON = try JSON(data: response.data!)
                            
                            if let result = json.array {
                                
                                for data in result {
                                    
                                    let data2 = data["StationName"]["Zh_tw"] //depart
                                    let data3 = data["EndingStationName"]["Zh_tw"] //destination
                                    let data4 = data["ScheduledArrivalTime"] //arrivalTime
                                    let data5 = data["TrainTypeName"]["Zh_tw"] //Type
                                    let data6 = data["TrainNo"]
                                    let data7 = data["Direction"]//direction 1 for 逆 0 for 順
                                    
                                    self.trainDepart.append(data2.stringValue)
                                    self.trainDestination.append(data3.stringValue)
                                    self.trainArrivalTime.append(data4.stringValue)
                                    self.trainType.append(data5.stringValue)
                                    self.trainNo.append(data6.stringValue)
                                    self.trainDirection.append(data7.intValue)
                                    
                                }
                                print(self.trainDepart)
                                print(self.trainType)
                                print(self.trainArrivalTime)
                                print(self.trainNo)
                                print(self.trainDestination)
                                print(self.trainDirection)
                                
                                self.performSegue(withIdentifier: "goToNearStation", sender: nil)
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                            }
                        }
                        catch{
                            print("ERROR in URL2")
                        }
                    }
                }
            }
            catch {
                print("ERROR in alamofire catching data")
                print("Connect error")
                //alert
                let alert = UIAlertController(title: "請查看網路設定", message: "No Internet Connect!", preferredStyle: .alert)
                let action = UIAlertAction.init(title: "確定", style: .default) { (action) in
                    
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                //POPUP "CANT SEARCH HISTORY"
            }
        }

    }
    
    func caculate(Lon: Double, Lat: Double){
        
        let location: CLLocation = CLLocation(latitude: Lat, longitude: Lon)
        
        let distanceInMeters = Double(location.distance(from: userLoacation))
        
        locationDistanceArray.append(distanceInMeters)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is NearStationViewController {
            
            let vc = segue.destination as? NearStationViewController
            vc?.textWillAppear = locationName[nearStationIndexInArray]
            vc?.locationStationID = locationStationID[nearStationIndexInArray]
            
            vc?.trainDepart = self.trainDepart
            vc?.trainDestination = self.trainDestination
            vc?.trainArrivalTime = self.trainArrivalTime
            vc?.trainType = self.trainType
            vc?.trainNo = self.trainNo
            vc?.trainDirection = self.trainDirection
            
            self.activityIndicator.stopAnimating()
        }
    }
    


}


extension MainViewController: GADBannerViewDelegate {
    
//    /// Tells the delegate an ad request loaded an ad.
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        print("adViewDidReceiveAd")
//    }
//
//    /// Tells the delegate an ad request failed.
//    func adView(_ bannerView: GADBannerView,
//                didFailToReceiveAdWithError error: GADRequestError) {
//        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
//    }
//
//    /// Tells the delegate that a full-screen view will be presented in response
//    /// to the user clicking on an ad.
//    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
//        print("adViewWillPresentScreen")
//    }
//
//    /// Tells the delegate that the full-screen view will be dismissed.
//    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewWillDismissScreen")
//    }
//
//    /// Tells the delegate that the full-screen view has been dismissed.
//    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
//        print("adViewDidDismissScreen")
//    }
//
//    /// Tells the delegate that a user click will open another app (such as
//    /// the App Store), backgrounding the current app.
//    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
//        print("adViewWillLeaveApplication")
//    }
}
