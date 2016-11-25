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
            
            guard (sessionDictionary[Constants.UdacityResponseKeys.sessionID] as? String) != nil else {
                completionHandlerForID(false, NSError(domain: "Udacity Auth parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity Auth result"]))
                return
            }
            
            DataStorage.sharedInstance.ownStudent.studentLocationInfo["uniqueKey"] = parsedUserID as AnyObject?
            
            completionHandlerForID(true, nil)
        }
    }
    
    func getUdacityStudentDetails(completionHandlerForStudentDetails: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        // let userId = student.uniqueKey
        let userId = DataStorage.sharedInstance.ownStudent.studentLocationInfo["uniqueKey"] as? String
        let parameters = [String: AnyObject]()
        let userMethod = Constants.UdacityApiMethods.userDetails + userId!
        
        taskForGETMethod(method: userMethod, parameters: parameters) {(results, error) in
        
            guard (error == nil) else {
                completionHandlerForStudentDetails(false, error)
                return
            }
            
            guard let accountDictionary = results?[Constants.UdacityResponseKeys.user] as? [String: AnyObject] else {
                completionHandlerForStudentDetails(false, NSError(domain: "Udacity response parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity user dictionary result"]))
                return
            }
            
            guard let firstName = accountDictionary["first_name"] as? String else {
                completionHandlerForStudentDetails(false, NSError(domain: "Udacity response parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity user - firstname result"]))
                return
            }
            
            guard let lastName = accountDictionary["last_name"] as? String else {
                completionHandlerForStudentDetails(false, NSError(domain: "Udacity response parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity user - firstname result"]))
                return
            }
            
            DataStorage.sharedInstance.ownStudent.studentLocationInfo["firstName"] = firstName as AnyObject?
            DataStorage.sharedInstance.ownStudent.studentLocationInfo["lastName"] = lastName as AnyObject?
            
            completionHandlerForStudentDetails(true, nil)

        }
    }
    
    func attemptLogout(completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void){
        
        taskForDELETEMethod() {(results, error) in
            
            guard (error == nil) else {
                completionHandlerForLogout(false, error)
                return
            }
            
            guard let accountDictionary = results?[Constants.UdacityResponseKeys.session] as? [String: AnyObject] else {
                completionHandlerForLogout(false, NSError(domain: "Udacity logout response parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity user logout result"]))
                return
            }
            
            guard ((accountDictionary[Constants.UdacityResponseKeys.sessionID]) != nil) else {
                completionHandlerForLogout(false, NSError(domain: "Udacity logout response parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Udacity user logout result"]))
                return
            }
            
            completionHandlerForLogout(true, nil)
            
        }
    }
}
