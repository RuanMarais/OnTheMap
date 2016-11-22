//
//  NewPinMapViewViewController.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit
import MapKit

class NewPinMapViewViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mediaLinkTextfield: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelPin(_ sender: Any) {
    }
    
}
