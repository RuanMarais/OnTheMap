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
        
        self.appDelegate.studentLocationDataStructArray.removeAll()
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
                
                var firstName: String?
                var lastName: String?
                var objectId: String?
                var uniqueKey: String?
                var mediaUrl: String?
                var mapString: String?
                var latitude: Float?
                var longitude: Float?
                
                if let nameFirst = student["firstName"] as? String {
                    firstName = nameFirst
                } else {
                    firstName = nil
                }
                
                if let nameLast = student["lastName"] as? String {
                    lastName = nameLast
                } else {
                    lastName = nil
                }
                
                if let id = student["objectId"] as? String {
                    objectId = id
                } else {
                    objectId = nil
                }
                
                if let uk = student["uniqueKey"] as? String {
                    uniqueKey = uk
                } else {
                    uniqueKey = nil
                }
                
                if let medUrl = student["mediaURL"] as? String {
                    mediaUrl = medUrl
                } else {
                    mediaUrl = nil
                }
                
                if let map = student["mapString"] as? String {
                    mapString = map
                } else {
                    mapString = nil
                }
                
                if let long = student["longitude"] as? Float {
                    longitude = long
                } else {
                    longitude = nil
                }
                
                if let lat = student["latitude"] as? Float {
                    latitude = lat
                } else {
                    latitude = nil
                }

                /*
 
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
 
                */
                
                let studentLocationStruct = StudentLocation(firstName: firstName, objectId: objectId, uniqueKey: uniqueKey, lastName: lastName, mapString: mapString, mediaUrl: mediaUrl, latitude: latitude, longitude: longitude)
                self.appDelegate.studentLocationDataStructArray.append(studentLocationStruct)
                }
            
            completionHandlerForParse(true, nil)
            
        }
    }
    
}
