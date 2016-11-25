//
//  DataStorage.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/25.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

class DataStorage: NSObject {
    
    var studentLocationDataStructArray = [StudentLocation]()
    static let sharedInstance = DataStorage()
    
    override init() {
        super.init()
    }
}
