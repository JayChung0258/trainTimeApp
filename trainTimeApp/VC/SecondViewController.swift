//
//  SecondViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func upperButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTHSRTIme", sender: nil)
    }
    

}
