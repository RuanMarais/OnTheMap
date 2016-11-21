//
//  ParseDataPopulation.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func populateStudentLocationStructArray(limitResults: Int, completionHandlerForParse: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        var parameters = [String: AnyObject]()
        parameters[Constants.ParseApiQueryKeys.limit] = "\(limitResults)" as AnyObject?
        
        taskForPOSTMethod(method: nil, parameters: parameters) {(results, error) in
        
            guard (error == nil) else {
                completionHandlerForParse(false, error)
                return
            }
            
            guard let resultsArray = results?["results"] as? [[String: AnyObject]] else {
                completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - Array"]))
                return
            }
            
            for student in resultsArray {
                
                guard let firstName = student["firstName"] as? String else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - firstName"]))
                    return
                }
                guard let lastName = student["lastName"] as? String else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - lastName"]))
                    return
                }
                guard let objectId = student["objectId"] as? String else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - objectId"]))
                    return
                }
                guard let uniqueKey = student["uniqueKey"] as? String else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - uniqueKey"]))
                    return
                }
                guard let mediaURL = student["mediaURL"] as? String else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - mediaURL"]))
                    return
                }
                guard let mapString = student["mapString"] as? String else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - mapString"]))
                    return
                }
                guard let latitude = student["latitude"] as? Float else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - latitude"]))
                    return
                }
                guard let longitude = student["longitude"] as? Float else {
                    completionHandlerForParse(false, NSError(domain: "Parse database parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse Parse database result - longitude"]))
                    return
                }
                
                let studentLocationStruct = StudentLocation(firstName: firstName, objectId: objectId, uniqueKey: uniqueKey, lastName: lastName, mapString: mapString, mediaUrl: mediaURL, latitude: latitude, longitude: longitude)
                self.appDelegate.studentLocationDataStructArray.append(studentLocationStruct)
            }
            
            completionHandlerForParse(true, nil)
            
        }
    }
    
}
