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
    
    //
    var stationNoText = ""
    var directNoText = ""
    var dateText = ""
    
    //picker
    var stationPicker = UIPickerView()
    
    //delegateinfo
    let trainInfo = TrainInfo()
    
    //train
    var trainNo = [Int]()
    var trainArrivalTime = [String]()
    
    
    
    //No deleagate
    var StationNo = 0
    var DirectNo = 0
    var selectedDate: String = ""
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //picker
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
        dateText = dateFormatter.string(from: Date())
        selectedDate = dateText
        
        // Do any additional setup after loading the view.
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
        
        Alamofire.request(request).responseJSON { response in
            do{
                print(Thread.isMainThread)
                
                let json: JSON = try JSON(data: response.data!)
                
                if let result = json.array {
                    
                    for data in result {
                      
                        let data2 = data["TrainNo"]
                        let data3 = data["ArrivalTime"]
                        
                        ////////////
                        
                        self.trainNo.append(data2.intValue)
                        self.trainArrivalTime.append(data3.stringValue)
                
                        }
                    self.performSegue(withIdentifier: "goToTHSRTImeList2",sender: nil)
                        
                    }
                
                }
            catch {
                print("ERROR")
            }
                    
            }
        
        print("\(APIUrl)")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(Thread.isMainThread)
        if segue.destination is LowerTableViewController {
            let vc = segue.destination as? LowerTableViewController
            //reset
            vc?.resetDataArray()
            //data
            vc?.trainNo = self.trainNo
            vc?.trainArrivalTime = self.trainArrivalTime
            
            print(self.trainNo)
//            self.activityIndicator.stopAnimating()
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
            print(station[row])
            StationNo = trainInfo.trainNoKeypair[station[row]]!
            stationNoText = "\(station[row])"
            stationText.text = "\(stationNoText)/\(directNoText)"
            
        }
        else if component == 1 {
            print(direction[row])
            DirectNo = trainInfo.trainDirectKeyPair[direction[row]]!
            directNoText = "\(direction[row])"
            stationText.text = "\(stationNoText)/\(directNoText)"
        }
        
    }
    
    
    
}
