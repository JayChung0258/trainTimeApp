//
//  LowerViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class LowerViewController: UIViewController {
    
    @IBOutlet weak var stationText: UITextField!
    
    //default
    let defaults = UserDefaults.standard
    
    //
    var stationNoText = ""
    var directNoText = ""
    var dateText = ""
    
    //picker
    var stationPicker = UIPickerView()
    
    //delegateinfo
    let trainInfo = TrainInfo()
    
    //train
    var trainNo = [String]()
    var trainArrivalTime = [String]()
    
    //detail data
    
    
    //important transport
    var StationNo = 0
    var DirectNo = 0
    var selectedDate: String = ""
    
    //
    var stationIndex = 0
    var directIndex = 0
    
    
    //delegate
    var hourInt = 0
    var hourWithLeadingZero = ""
    var hour = ""
    var minuteInt = 0
    var minuteWithLeadingZero = ""
    var minute = ""
    
    //train data
    var APIUrl = ""
    var station = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    var direction = ["北上","南下"]
    
    //activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    fileprivate func defaultsGetData() {
        stationNoText = defaults.string(forKey: "THSRLowerViewController_stationNoText") ?? "站別"
        directNoText = defaults.string(forKey: "THSRLowerViewController_directNoText") ?? "方向"
        stationIndex = defaults.integer(forKey: "THSRLowerViewController_stationIndex")
        directIndex = defaults.integer(forKey: "THSRLowerViewController_directIndex")
        StationNo = defaults.integer(forKey: "THSRLowerViewController_StationNo")
        DirectNo = defaults.integer(forKey: "THSRLowerViewController_DirectNo")
        
        stationPicker.selectRow(stationIndex, inComponent: 0, animated: true)
        stationPicker.selectRow(directIndex, inComponent: 1, animated: true)
        
    }
    
    fileprivate func defaultsStoreData() {
        defaults.set(stationNoText, forKey: "THSRLowerViewController_stationNoText")
        defaults.set(directNoText, forKey: "THSRLowerViewController_directNoText")
        defaults.set(stationIndex, forKey: "THSRLowerViewController_stationIndex")
        defaults.set(directIndex, forKey: "THSRLowerViewController_directIndex")
        defaults.set(StationNo, forKey: "THSRLowerViewController_StationNo")
        defaults.set(DirectNo, forKey: "THSRLowerViewController_DirectNo")
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //picker
        stationPicker.delegate = self
        stationPicker.dataSource = self
        stationText.inputView = stationPicker
        
        //get data
        defaultsGetData()
        
        //text
        stationText.text = "\(stationNoText)/\(directNoText)"
        
        //set default date
        let dateFormatter = DateFormatter()
        
        //get hour and minute
        let date = Date()
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        hourInt = components.hour!
        if hourInt < 10 {
            hourWithLeadingZero = "0\(hourInt)"
            hour = hourWithLeadingZero
        }else{
            hour = String(hourInt)
        }
        minuteInt = components.minute!
        if minuteInt < 10 {
            minuteWithLeadingZero = "0\(minuteInt)"
            minute = minuteWithLeadingZero
        }else{
            minute = String(minuteInt)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateText = dateFormatter.string(from: Date())
        selectedDate = dateText
        
        // Do any additional setup after loading the view.
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
        print("Now On LowerViewController")
    }
    
    func resetDataArray() {
        trainNo = []
        trainArrivalTime = []
        print("Reset in LowerViewController triggered")
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/Station/"+"\(StationNo)"+"/"+"\(selectedDate)"+"?$filter=Direction%20eq%20'"+"\(DirectNo)"+"'%20and%20ArrivalTime%20ge%20'\(hour)%3A\(minute)'&$orderby=ArrivalTime&$top=30&$format=JSON"
        
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
                      
                        let data2 = data["TrainNo"]
                        let data3 = data["ArrivalTime"]
                        
                        ////////////
                        
                        self.trainNo.append(data2.stringValue)
                        self.trainArrivalTime.append(data3.stringValue)
                
                        }
                    self.performSegue(withIdentifier: "goToTHSRTImeList2",sender: nil)
                        
                    }
                else{
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
            catch {
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
        
        
        
        defaultsStoreData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(Thread.isMainThread)
        if segue.destination is LowerTableViewController {
            let vc = segue.destination as? LowerTableViewController
            //data
            vc?.trainNo = self.trainNo
            vc?.trainArrivalTime = self.trainArrivalTime
    
            //date passing
            vc?.detailSelectedDate = self.selectedDate
            
            print(self.trainNo)
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    

}



extension LowerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return station.count
        }
        else {
            return direction.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return station[row]
        }
        else {
            return direction[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            stationIndex = pickerView.selectedRow(inComponent: 0)
            print(station[row])
            StationNo = trainInfo.trainNoKeypair[station[row]]!
            stationNoText = "\(station[row])"
            stationText.text = "\(stationNoText)/\(directNoText)"
            
        }
        else if component == 1 {
            directIndex = pickerView.selectedRow(inComponent: 1)
            print(direction[row])
            DirectNo = trainInfo.trainDirectKeyPair[direction[row]]!
            directNoText = "\(direction[row])"
            stationText.text = "\(stationNoText)/\(directNoText)"
        }
        
    }
    
    
    
}
