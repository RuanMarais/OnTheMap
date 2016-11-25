//
//  DataStorage.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/25.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import MapKit

class DataStorage: NSObject {
    
    var studentLocationDataStructArray = [StudentLocationData]()
    var ownStudent = StudentLocationData(studentLocationDictionary: [:])
    var session = URLSession.shared
    static let sharedInstance = DataStorage()
    var placemark: MKPlacemark? = nil
    
    override init() {
        super.init()
    }
}
