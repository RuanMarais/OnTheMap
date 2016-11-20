//
//  Constants.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/17.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import UIKit

// Mark: CONSTANTS 
struct Constants {
    

    struct UIValues {
        static let loginColorTop = UIColor(colorLiteralRed: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        static let loginColorBottom = UIColor(colorLiteralRed: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor
    }
    
    struct UdacityApiConstants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct UdacityApiMethods {
        static let sessionID = "/session"
    }
    
    struct UdacityResponseKeys {
        static let account = "account"
        static let userID = "key"
        static let isRegistered = "registered"
        static let session = "session"
        static let sessionID = "id"
    }
    
    
}
