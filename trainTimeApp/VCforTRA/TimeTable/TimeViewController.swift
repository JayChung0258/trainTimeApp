//
//  TimeViewController.swift
//  CleanTrainTime
//
//  Created by 洪丞桀 on 2019/1/30.
//  Copyright © 2019 JayChung. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import GoogleMobileAds


class TimeViewController: UIViewController {
    
    @IBOutlet weak var StartText: UITextField!
    @IBOutlet weak var EndText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var searchButton: UIButton!
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    let trainInfo = TRATrainInfo()
    
    //train
    var trainNo = [String]()
    var stationName = [String]()
    var startArrivalTime = [String]()
    var endArrivalTime = [String]()
    var trainTypeID = [String]()
    var trainTimeInterval = [String]()
    
    //picker
    var startPicker = UIPickerView()
    var endPicker = UIPickerView()
    
    //import transport
    var startStationNo = 0
    var endStationNo = 0
    var selectedDate: String = ""
    
    //No deleagate
    var hourInt = 0
    var hourWithLeadingZero = ""
    var hour = ""
    var minuteInt = 0
    var minuteWithLeadingZero = ""
    var minute = ""

    
    //train data
    var APIUrl = ""
    var formerStation = ["臺北","桃園","新竹","苗栗","臺中","彰化","南投","雲林","嘉義","臺南","高雄","屏東","臺東","花蓮","宜蘭","平溪/深奧線","內灣線","集集線","沙崙線"]
    var laterStation = [["福隆", "貢寮", "雙溪","牡丹", "三貂嶺", "侯桐","瑞芳", "四腳亭", "暖暖","基隆", "三坑", "八堵","七堵", "百福", "五堵","汐止", "汐科", "南港","松山", "臺北", "萬華","板橋", "浮洲", "樹林","南樹林", "山佳", "鶯歌"], ["桃園", "內壢", "中壢","埔心", "楊梅", "富岡","新富"], ["北湖", "湖口", "新豐","竹北", "北新竹", "新竹","三姓橋", "香山"], ["崎頂", "竹南", "談文","大山", "後龍", "龍港","白沙屯", "新埔", "通宵","苑裡", "造橋", "豐富","苗栗", "南勢", "銅鑼","三義"], ["日南", "大甲", "台中港","清水", "沙鹿", "龍井","大肚", "追分", "成功","泰安", "后里", "豐原","栗林", "潭子", "頭家厝","松竹", "太原", "精武","台中", "五權", "大慶", "烏日","新烏日"],[ "彰化", "花壇","大村", "員林", "永靖","社頭", "田中", "二水"],[ "二水", "源泉","濁水", "龍泉", "集集","水里", "車埕"],[ "林內", "石榴","斗六", "斗南", "石龜"],[ "大林", "民雄","嘉北", "嘉義", "水上","南靖"],[ "後壁", "新營","柳營", "林鳳營", "隆田","拔林", "善化", "南科","新市", "永康", "大橋","臺南", "保安", "仁德","中州", "長榮大學", "沙崙"],["大湖", "路竹","岡山", "橋頭", "楠梓","新左營", "左營", "內惟","美術館", "鼓山", "三塊厝","高雄", "民族", "科工館","正義", "鳳山", "後庄","九曲堂"],[ "六塊厝", "屏東","歸來", "麟洛", "西勢","竹田", "潮州", "崁頂","南州", "鎮安", "林邊","佳冬", "東海", "枋寮","加祿", "內獅", "枋山"] ,[ "古莊", "大武","瀧溪", "金崙", "太麻里","知本", "康樂", "臺東","山里", "鹿野", "瑞源","瑞和", "月美", "關山","海端", "池上"],[ "富里", "東竹","東里", "玉里", "三民","瑞穗", "富源", "大富","光復", "萬榮", "鳳林","南平", "林榮新光", "豐田","壽豐", "平和", "志學","吉安", "花蓮", "北埔","景美", "新城", "崇德","和仁", "和平"],[ "漢本", "武塔","南澳", "東澳", "永樂","蘇澳", "蘇澳新", "新馬","冬山", "羅東", "中里","二結", "宜蘭", "四城","礁溪", "頂埔", "頭城","外澳", "龜山", "大溪","大里", "石城"],["菁桐", "平溪","嶺腳", "望古", "十分","大華", "八斗子", "三貂嶺","海科館"],[ "新竹", "北新竹","世博(千甲)", "竹科(新莊)", "竹中","六家", "上員", "榮華","竹東", "橫山", "九讚頭","合興", "富貴", "內灣"],["二水", "源泉","濁水", "龍泉", "集集","水里", "車埕"],["長榮大學", "沙崙"]]
    
    //
    var tmpFormerStationIndexForStart: Int = 0
    var tmpLaterStationIndexForStart: Int = 0
    var tmpFormerStationIndexForEnd: Int = 0
    var tmpLaterStationIndexForEnd: Int = 0
    
    //default
    let defaults = UserDefaults.standard
    
    //activity indicator
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    
    
    fileprivate func defaultsGetData() {

        tmpFormerStationIndexForStart = defaults.integer(forKey: "tmpFormerStationIndexForStart")
        tmpLaterStationIndexForStart = defaults.integer(forKey: "tmpLaterStationIndexForStart")
        tmpFormerStationIndexForEnd = defaults.integer(forKey: "tmpFormerStationIndexForEnd")
        tmpLaterStationIndexForEnd = defaults.integer(forKey: "tmpLaterStationIndexForEnd")
        
        startPicker.selectRow(tmpFormerStationIndexForStart, inComponent: 0, animated: true)
        startPicker.reloadComponent(1)
        startPicker.selectRow(tmpLaterStationIndexForStart, inComponent: 1, animated: true)
        StartText.text = laterStation[tmpFormerStationIndexForStart][tmpLaterStationIndexForStart]
        startStationNo = trainInfo.trainNoKeypair[StartText.text!]!
        print(startStationNo)
        
        endPicker.selectRow(tmpFormerStationIndexForEnd, inComponent: 0, animated: true)
        endPicker.reloadComponent(1)
        endPicker.selectRow(tmpLaterStationIndexForEnd, inComponent: 1, animated: true)
        EndText.text = laterStation[tmpFormerStationIndexForEnd][tmpLaterStationIndexForEnd]
        endStationNo = trainInfo.trainNoKeypair[EndText.text!]!
        print(endStationNo)
    }
    
    fileprivate func defaultsStoreData() {
        //default set
        defaults.set(tmpFormerStationIndexForStart, forKey: "tmpFormerStationIndexForStart")
        defaults.set(tmpLaterStationIndexForStart, forKey: "tmpLaterStationIndexForStart")
        defaults.set(tmpFormerStationIndexForEnd, forKey: "tmpFormerStationIndexForEnd")
        defaults.set(tmpLaterStationIndexForEnd, forKey: "tmpLaterStationIndexForEnd")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view, typically from a nib.
        startPicker.delegate = self
        startPicker.dataSource = self
        endPicker.delegate = self
        endPicker.dataSource = self
        StartText.inputView = startPicker
        EndText.inputView = endPicker
        
        //button
        searchButton.layer.cornerRadius = 7.0
        
        //Ads set
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        //defaults get
        defaultsGetData()
        
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
        StartText.endEditing(true)
        EndText.endEditing(true)
        dateText.endEditing(true)
    }
    
    
    fileprivate func setUpDatePicker() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(TimeViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
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
        print("Now on TimeViewController")
    }
    
    func resetDataArray() {
        trainNo = []
        stationName = []
        startArrivalTime = []
        endArrivalTime = []
        trainTypeID = []
        trainTimeInterval = []
        print("Reset in TimeViewController triggered")
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
    
    
    
    
//////////////////////////////////////////////////////
    
    @IBAction func switchButtonPressed(_ sender: Any) {
        
        let swapFormerStart = tmpFormerStationIndexForStart
        let swapFormerEnd = tmpFormerStationIndexForEnd
        let swapLaterStart = tmpLaterStationIndexForStart
        let swapLaterEnd = tmpLaterStationIndexForEnd
        
        swap(&tmpFormerStationIndexForStart, &tmpFormerStationIndexForEnd)
        swap(&tmpLaterStationIndexForStart, &tmpLaterStationIndexForEnd)
        
        startPicker.selectRow(swapFormerEnd, inComponent: 0, animated: true)
        startPicker.reloadComponent(1)
        startPicker.selectRow(swapLaterEnd, inComponent: 1, animated: true)
        StartText.text = laterStation[swapFormerEnd][swapLaterEnd]
        startStationNo = trainInfo.trainNoKeypair[StartText.text!]!
        print(startStationNo)
        
        endPicker.selectRow(swapFormerStart, inComponent: 0, animated: true)
        endPicker.reloadComponent(1)
        endPicker.selectRow(swapLaterStart, inComponent: 1, animated: true)
        EndText.text = laterStation[swapFormerStart][swapLaterStart]
        endStationNo = trainInfo.trainNoKeypair[EndText.text!]!
        print(endStationNo)
        
    }
    
    
    
    
    
    
    
    

    
    @IBAction func buttonPressed(_ sender: Any) {
        
        APIUrl = "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/OD/"+"\(startStationNo)"+"/to/"+"\(endStationNo)"+"/"+"\(selectedDate)"+"?$top=200&$format=JSON&$orderby=OriginStopTime/ArrivalTime&$filter=OriginStopTime/ArrivalTime%20ge%20%27\(hour):\(minute)%27"
        
        let request = setUpUrl(APIUrl: APIUrl)
        
        print("\(APIUrl)")
        
        //loading animatind and ignore user tap
        self.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        StartText.endEditing(true)
        EndText.endEditing(true)
        dateText.endEditing(true)
        
        
        Alamofire.request(request).responseJSON { response in
            do{
                print(Thread.isMainThread)
                let json: JSON = try JSON(data: response.data!)
                
                if let result = json.array {
                    for data in result {
                        
                        let data2 = data["DailyTrainInfo"]["TrainNo"]
                        let data3 = data["OriginStopTime"]["ArrivalTime"]
                        let data4 = data["DestinationStopTime"]["ArrivalTime"]
                        let data5 = data["DailyTrainInfo"]["TrainTypeName"]["Zh_tw"]
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
                        
                        self.trainNo.append(data2.stringValue)
                        self.startArrivalTime.append(data3.stringValue)
                        self.endArrivalTime.append(data4.stringValue)
                        self.trainTypeID.append(data5.stringValue)
                        
                        
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToTimeTableList",sender: nil)
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
        
        defaultsStoreData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print(Thread.isMainThread)
        if segue.destination is TImeTableViewController {
            let vc = segue.destination as? TImeTableViewController
//            vc?.resetDataArray()
            //data
            vc?.trainNo = self.trainNo
            vc?.startArrivalTime = self.startArrivalTime
            vc?.endArrivalTime = self.endArrivalTime
            vc?.trainTypeID = self.trainTypeID
            vc?.trainTimeInterval = self.trainTimeInterval
            //title
            vc?.formerStation = StartText.text ?? ""
            vc?.laterStation = EndText.text ?? ""
            
            //date passing
            vc?.detailSelectedDate = self.selectedDate
            
            print(self.trainNo)
            self.activityIndicator.stopAnimating()
        }
    }
    


}

///////////////////////////////

extension TimeViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var a = 0
        if component == 0 {
            a = formerStation.count
        }
        else if component == 1 && pickerView == startPicker {
//            print("pickerView: \(pickerView.selectedRow(inComponent: 0))")
//            print("tmp: \(tmpFormerStationIndexForStart)")
            var selected = pickerView.selectedRow(inComponent: 0)
            selected = tmpFormerStationIndexForStart
            a = laterStation[selected].count
//            print("number : \(a)")
        }
        else if component == 1 && pickerView == endPicker {
//            print("pickerView: \(pickerView.selectedRow(inComponent: 0))")
//            print("tmp: \(tmpFormerStationIndexForEnd)")
            var selected = pickerView.selectedRow(inComponent: 0)
            selected = tmpFormerStationIndexForEnd
            a = laterStation[selected].count
//            print("number : \(a)")
            
        }
        return a
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var b = ""
        if component == 0 {
            b = formerStation[row]
        }
        else {
            let selected = pickerView.selectedRow(inComponent: 0)
//            print("reload: \(selected) \(row)")
            b = laterStation[selected][row]
        }
        return b
    }
    

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == startPicker && component == 0 {
            tmpFormerStationIndexForStart = pickerView.selectedRow(inComponent: 0)
            pickerView.reloadComponent(1)
            
            switch tmpFormerStationIndexForStart {
            case 0 : tmpLaterStationIndexForStart = 19
            case 1 : tmpLaterStationIndexForStart = 0
            case 2 : tmpLaterStationIndexForStart = 5
            case 3 : tmpLaterStationIndexForStart = 12
            case 4 : tmpLaterStationIndexForStart = 18
            case 5 : tmpLaterStationIndexForStart = 0
            case 6 : tmpLaterStationIndexForStart = 4
            case 7 : tmpLaterStationIndexForStart = 2
            case 8 : tmpLaterStationIndexForStart = 3
            case 9 : tmpLaterStationIndexForStart = 11
            case 10 : tmpLaterStationIndexForStart = 11
            case 11 : tmpLaterStationIndexForStart = 1
            case 12 : tmpLaterStationIndexForStart = 7
            case 13 : tmpLaterStationIndexForStart = 18
            case 14 : tmpLaterStationIndexForStart = 12
            case 15 : tmpLaterStationIndexForStart = 3
            case 16 : tmpLaterStationIndexForStart = 0
            case 17 : tmpLaterStationIndexForStart = 4
            case 18 : tmpLaterStationIndexForStart = 0
            default:
                print("results out of cases")
            }

            startPicker.selectRow(tmpLaterStationIndexForStart, inComponent: 1, animated: true)
            StartText.text = laterStation[tmpFormerStationIndexForStart][tmpLaterStationIndexForStart]
            startStationNo = trainInfo.trainNoKeypair[StartText.text!]!
            print(startStationNo)


        }
        else if pickerView == startPicker && component == 1 {
            let selected = pickerView.selectedRow(inComponent: 0)
            tmpLaterStationIndexForStart = row
            StartText.text = laterStation[selected][tmpLaterStationIndexForStart]
            startStationNo = trainInfo.trainNoKeypair[StartText.text!]!
            print(startStationNo)
        }
            
        else if pickerView == endPicker && component == 0 {
            tmpFormerStationIndexForEnd = pickerView.selectedRow(inComponent: 0)
            pickerView.reloadComponent(1)
            
            switch tmpFormerStationIndexForEnd {
            case 0 : tmpLaterStationIndexForEnd = 19
            case 1 : tmpLaterStationIndexForEnd = 0
            case 2 : tmpLaterStationIndexForEnd = 5
            case 3 : tmpLaterStationIndexForEnd = 12
            case 4 : tmpLaterStationIndexForEnd = 18
            case 5 : tmpLaterStationIndexForEnd = 0
            case 6 : tmpLaterStationIndexForEnd = 4
            case 7 : tmpLaterStationIndexForEnd = 2
            case 8 : tmpLaterStationIndexForEnd = 3
            case 9 : tmpLaterStationIndexForEnd = 11
            case 10 : tmpLaterStationIndexForEnd = 11
            case 11 : tmpLaterStationIndexForEnd = 1
            case 12 : tmpLaterStationIndexForEnd = 7
            case 13 : tmpLaterStationIndexForEnd = 18
            case 14 : tmpLaterStationIndexForEnd = 12
            case 15 : tmpLaterStationIndexForEnd = 3
            case 16 : tmpLaterStationIndexForEnd = 0
            case 17 : tmpLaterStationIndexForEnd = 4
            case 18 : tmpLaterStationIndexForEnd = 0
            default:
                print("results out of cases")
            }
            
            endPicker.selectRow(tmpLaterStationIndexForEnd, inComponent: 1, animated: true)
            EndText.text = laterStation[tmpFormerStationIndexForEnd][tmpLaterStationIndexForEnd]
            endStationNo = trainInfo.trainNoKeypair[EndText.text!]!
            print(endStationNo)
        }
        
        else if pickerView == endPicker && component == 1 {
            let selected = pickerView.selectedRow(inComponent: 0)
            tmpLaterStationIndexForEnd = row
            EndText.text = laterStation[selected][tmpLaterStationIndexForEnd]
            endStationNo = trainInfo.trainNoKeypair[EndText.text!]!
            print(endStationNo)
        }
        

        
       
    }
    
}
