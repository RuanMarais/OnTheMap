//
//  UdacityLogin.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/19.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func getSessionAndUserID (username: String, password: String, completionHandlerForID: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let username = username
        let password = password
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let parameters = [String:AnyObject]()
        
        taskForPOSTMethod(method: Constants.UdacityApiMethods.sessionID, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            
            guard (error == nil) else {
                completionHandlerForID(false, error)
                return
            }
            
            guard let accountDictionary = results?[Constants.UdacityResponseKeys.account] as? [String: AnyObject] else {
                completionHandlerForID(false, NSError(domain: "Udacity Auth parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity Auth result"]))
                return
            }
            
            guard let registered = accountDictionary[Constants.UdacityResponseKeys.isRegistered] as? Bool, registered else {
                completionHandlerForID(false, NSError(domain: "Udacity Auth parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity Auth result"]))
                return
            }
            
            guard let parsedUserID = accountDictionary[Constants.UdacityResponseKeys.userID] as? String else {
                completionHandlerForID(false, NSError(domain: "Udacity Auth parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity Auth result"]))
                return
            }
            
            guard let sessionDictionary = results?[Constants.UdacityResponseKeys.session] as? [String:AnyObject] else {
                completionHandlerForID(false, NSError(domain: "Udacity Auth parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity Auth result"]))
                return
            }
            
            guard let parsedSessionID = sessionDictionary[Constants.UdacityResponseKeys.sessionID] as? String else {
                completionHandlerForID(false, NSError(domain: "Udacity Auth parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity Auth result"]))
                return
            }
            
            self.sessionID = parsedSessionID
            self.userID = parsedUserID
            completionHandlerForID(true, nil)
        }
    }
    
    
}
