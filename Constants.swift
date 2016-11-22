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
        static let userDetails = "/users/"
    }
    
    struct UdacityResponseKeys {
        static let account = "account"
        static let userID = "key"
        static let isRegistered = "registered"
        static let session = "session"
        static let sessionID = "id"
        static let user = "user"
    }
    
    struct ParseApiKeys {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParseApiConstants {
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    struct ParseApiQueryKeys {
        static let limit = "limit"
    }
    
    struct ParseApiQueryValues {
        static let limitNumber = 1000
    }
    
}
