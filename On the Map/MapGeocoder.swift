//
//  File.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import MapKit

struct MapData {
    
    static func geoCodeData (locationString: String) -> MKPlacemark? {
        let geocoder: CLGeocoder = CLGeocoder()
        var placemarkReturn: MKPlacemark? = nil
        geocoder.geocodeAddressString(locationString) {(placemarks, error) in
            
            guard (error == nil) else {
                print(error as Any)
                return
            }
 
            if ((placemarks?.count)! > 0) {
                let top: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: top)
                placemarkReturn = placemark
            }
    }
        return placemarkReturn
    }
}