//
//  DetailViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/8.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var trainNo: UILabel!
    @IBOutlet weak var startAndend: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var tmpDateText = ""
    var tmpTrainNo = ""
    var tmpStart = ""
    var tmpEnd = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateText.text = tmpDateText
        trainNo.text = tmpTrainNo
        startAndend.text = "\(tmpStart)~\(tmpEnd)"
        
    }
    

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailViewCell
        
        return cell
        
        
    }
    
    
}
