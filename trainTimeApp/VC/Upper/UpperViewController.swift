//
//  UpperViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class UpperViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var stationText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    //
    var startText = ""
    var endText = ""
    
    
    //picker
    var stationPicker = UIPickerView()
    
    //delegateinfo
    let trainInfo = TrainInfo()
    
    //train
    var trainNo = [Int]()
    var startArrivalTime = [String]()
    var endArrivalTime = [String]()
    var trainTimeInterval = [String]()
    
    //train data
    var APIUrl = ""
    var station = ["南港","台北","板橋","桃園","新竹","苗栗","台中","彰化","雲林","嘉義","台南","左營"]
    
    //
    var tmpStart: Int = 0
    var tmpEnd: Int = 0
    
    //activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //No deleagate
    var hourInt = 0
    var hourWithLeadingZero = ""
    var hour = ""
    var minuteInt = 0
    var minuteWithLeadingZero = ""
    var minute = ""
    var startStationNo = 0
    var endStationNo = 0
    var selectedDate: String = ""
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pciker
        stationPicker.delegate = self
        stationPicker.dataSource = self
        stationText.inputView = stationPicker

        
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
        dateText.text = dateFormatter.string(from: Date())
        dateText.textAlignment = NSTextAlignment.center
        selectedDate = dateText.text!
        dateText.text = "\(selectedDate)- \(hour):\(minute) "
        //
        setUpDatePicker()
        //
        let gesture = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        stationText.endEditing(true)
        dateText.endEditing(true)
    }
    
    
    fileprivate func setUpDatePicker() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(UpperViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        dateText.inputView = datePicker
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        
        //get hour and minute
        let date = sender.date
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
        
        
        dateText.text = formatter.string(from: sender.date)
        print(generateDate(Input: dateText.text!))
        selectedDate = generateDate(Input: dateText.text!)
        dateText.text = "\(selectedDate)- \(hour):\(minute) "
        
    }
    
    func generateDate(Input: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM dd,yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatterPrint.string(from: dateFormatterGet.date(from: Input)!)
        
        return date
        
    }
    
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
        print("go to search view")
    }
    
    func generateTimeIntervalHour(input: String) -> String {
        
        let startIndex = input.startIndex
        let offset2Index = input.index(startIndex, offsetBy: 2)
        let subString = String(input[startIndex..<offset2Index])
        
        switch subString {
        case "13": return "01\(input.mySubString(from: 2))"
        case "14": return "02\(input.mySubString(from: 2))"
        case "15": return "03\(input.mySubString(from: 2))"
        case "16": return "04\(input.mySubString(from: 2))"
        case "17": return "05\(input.mySubString(from: 2))"
        case "18": return "06\(input.mySubString(from: 2))"
        case "19": return "07\(input.mySubString(from: 2))"
        case "20": return "08\(input.mySubString(from: 2))"
        case "21": return "09\(input.mySubString(from: 2))"
        case "22": return "10\(input.mySubString(from: 2))"
        case "23": return "11\(input.mySubString(from: 2))"
        case "12": return "00\(input.mySubString(from: 2))"
        default:
            return input
        }
        
    }
    
    func resetDataArray() {
        trainNo = []
        startArrivalTime = []
        endArrivalTime = []
        trainTimeInterval = []
        print("Reset in Table method triggered")
    }

//////////////////////////////
    
    
//////////////////////////////
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/THSR/DailyTimetable/OD/"+"\(startStationNo)"+"/to/"+"\(endStationNo)"+"/"+"\(selectedDate)"+"?$top=200&$format=JSON&$orderby=OriginStopTime/ArrivalTime&$filter=OriginStopTime/ArrivalTime%20ge%20%27\(hour):\(minute)%27"
        
        let request = setUpUrl(APIUrl: APIUrl)
        
        print("\(APIUrl)")
        
        Alamofire.request(request).responseJSON { response in
            do{
                print(Thread.isMainThread)
                let json: JSON = try JSON(data: response.data!)
                
                if let result = json.array {
                    for data in result {
                        
                        let data2 = data["DailyTrainInfo"]["TrainNo"]
                        let data3 = data["OriginStopTime"]["ArrivalTime"]
                        let data4 = data["DestinationStopTime"]["ArrivalTime"]
                        var data6 = "" //timeInterval
                        
                        ////////////
                        let formatter = DateFormatter()
                        formatter.dateFormat = "hh:mm"
                        
                        if let date1 = formatter.date(from: self.generateTimeIntervalHour(input: data3.stringValue)), let date2 = formatter.date(from: self.generateTimeIntervalHour(input: data4.stringValue)) {
                            let elapsedTime = date2.timeIntervalSince(date1)
                            var hours = floor(elapsedTime / 60 / 60)
                            let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
                            switch hours {
                            case -12: hours = 0
                            case -11: hours = 1
                            case -10: hours = 2
                            case -9: hours = 3
                            case -8: hours = 4
                            case -7: hours = 5
                            case -6: hours = 6
                            case -5: hours = 7
                            case -4: hours = 8
                            case -3: hours = 9
                            case -2: hours = 10
                            case -1: hours = 11
                            default:
                                print("hours not triggered")
                            }
                            
                            data6 = "\(Int(hours))小時\(Int(minutes))分鐘"
                            print(data6)
                            self.trainTimeInterval.append(data6)
                        }else {
                            print("error in interval caculate")
                        }
                        
                        ////////////
                        
                        self.trainNo.append(data2.intValue)
                        self.startArrivalTime.append(data3.stringValue)
                        self.endArrivalTime.append(data4.stringValue)
                        
                        
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToTHSRTImeList",sender: nil)
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    
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
                    //POPUP "CANT SEARCH HISTORY"
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
    
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(Thread.isMainThread)
        if segue.destination is UpperTableViewController {
            let vc = segue.destination as? UpperTableViewController
            vc?.resetDataArray()
            //data
            vc?.trainNo = self.trainNo
            vc?.startArrivalTime = self.startArrivalTime
            vc?.endArrivalTime = self.endArrivalTime
            vc?.trainTimeInterval = self.trainTimeInterval
            //title
            vc?.formerStation = startText
            vc?.laterStation = endText 
            
            print(self.trainNo)
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    
    
  
}


extension UpperViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return station.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return station[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            startStationNo = trainInfo.trainNoKeypair[station[row]]!
            print(startStationNo)
            startText = station[row]
            stationText.text = "\(startText)至\(endText)"
        }
        else if component == 1 {
            endStationNo = trainInfo.trainNoKeypair[station[row]]!
            print(endStationNo)
            endText = station[row]
            stationText.text = "\(startText)至\(endText)"
        }
        
    }
    
    
}
