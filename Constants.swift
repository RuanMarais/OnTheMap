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
        static let ColorDark = UIColor(colorLiteralRed: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        static let ColorLight = UIColor(colorLiteralRed: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    }
    
    struct signUp {
        static let udacitySignUp = "https://www.udacity.com/account/auth#!/signup"
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
        static let objectMatch = "where"
        static let order = "order"
    }
    
    struct ParseApiQueryValues {
        static let limitNumber = 100
        static let ascendingTime = "-updatedAt"
    }
    
    struct AlertStrings {
        static let title = "Student Pin Placement"
        static let body = "You have already placed a Pin. Would you like to replace it?"
        static let replace = "Replace"
        static let noReplace = "Don't replace"
    }
    
    struct ParseApiRequestType {
        static let post = "POST"
        static let put = "PUT"
    }
    
    struct PostingAlerts {
        static let noLinkTitle = "No Media Link entered"
        static let noLinkPrompt = "Do you wish to continue without adding a media link to your pin"
        static let continueNoLink = "Continue"
        static let addLink = "Add Link"
    }
    
    struct AlertLogin {
        static let failed = "Login failed"
        static let connectionAbsent = "Please check your internet connection and try again"
        static let incorrectDetails = "Please check your username/password"
        static let retryLogin = "Retry"
    }
    
    struct AlertNetwork {
        static let failed = "Could not retrieve pins"
        static let failedPost = "Could not post pin"
        static let failedTable = "Could not populate table"
        static let failedGeocode = "Could not find that location"
        static let failedLogout = "Could not logout"
        static let connection = "Please check your internet connection and try again"
        static let geocoderFail = "Please try another location"
        static let accept = "Accept"
    }
    
    struct AlertUrl {
        static let failed = "Could not open link"
        static let message = "Please check your internet connection or try another link"
        static let accept = "Accept"
    }
    
    
}
