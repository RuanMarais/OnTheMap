//
//  StudentLocation.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    // MARK: PROPERTIES: StudentLocation
    
    var firstName: String?
    var objectId: String?
    var uniqueKey: String?
    var lastName: String?
    var mapString: String?
    var mediaUrl: String?
    var latitude: Double?
    var longitude: Double?
    
    init (firstName: String?, objectId: String?, uniqueKey: String?, lastName: String?, mapString: String?, mediaUrl: String?, latitude: Double?, longitude: Double?) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaUrl = mediaUrl
        self.objectId = objectId
        self.uniqueKey = uniqueKey
    }
}
