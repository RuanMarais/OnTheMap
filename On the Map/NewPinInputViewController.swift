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
    var replace: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func showOnMap(_ sender: Any) {
    }
    
    @IBAction func cancelPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
