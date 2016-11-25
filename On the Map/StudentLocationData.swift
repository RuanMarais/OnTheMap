//
//  StudentLocationData.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/25.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

struct StudentLocationData {
    
    var studentLocationInfo: [String: AnyObject?]
    
    init (studentLocationDictionary: [String: AnyObject?]) {
        studentLocationInfo = studentLocationDictionary
    }
}
