//
//  FirstViewController.swift
//  trainTimeApp
//
//  Created by 洪丞桀 on 2019/2/7.
//  Copyright © 2019 JayChung. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func TRAbuttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTRA", sender: nil)
    }
    
    @IBAction func THSRbuttonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToTHSR", sender: nil)
    }
    
    
    


}
