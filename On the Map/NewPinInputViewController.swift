//
//  NewPinInputViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class NewPinInputViewController: UIViewController {
   
    @IBOutlet weak var pinInputLabel: UILabel!
    @IBOutlet weak var pinInputButton: UIButton!
    @IBOutlet weak var pinInputTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func showOnMap(_ sender: Any) {
    }
    
    @IBAction func cancelPin(_ sender: Any) {
    }
    
}
