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
        
        taskForGETMethod(method: nil, parameters: parameters) {(results, error) in
        
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
                var latitude: Double?
                var longitude: Double?
                
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
                
                if let long = student["longitude"] as? Double {
                    longitude = long
                } else {
                    longitude = nil
                }
                
                if let lat = student["latitude"] as? Double {
                    latitude = lat
                } else {
                    latitude = nil
                }

                let studentLocationStruct = StudentLocation(firstName: firstName, objectId: objectId, uniqueKey: uniqueKey, lastName: lastName, mapString: mapString, mediaUrl: mediaUrl, latitude: latitude, longitude: longitude)
                self.appDelegate.studentLocationDataStructArray.append(studentLocationStruct)
                }
            
            completionHandlerForParse(true, nil)
        }
    }
    
    func postPin(replace: Bool, student: StudentLocation, completionHandlerForPostPin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let student = student
        let jsonBody = "{\"uniqueKey\": \"\(student.uniqueKey!)\", \"firstName\": \"\(student.firstName!)\", \"lastName\": \"\(student.lastName!)\",\"mapString\": \"\(student.mapString!)\", \"mediaURL\": \"\(student.mediaUrl!)\",\"latitude\": \(student.latitude!), \"longitude\": \(student.longitude!)}"
        
        if !replace {
            
            taskForPOSTMethod(method: nil, requestType: "POST", parameters: parameters, jsonBody: jsonBody) {(results, error) in
            
            guard (error == nil) else {
                completionHandlerForPostPin(false, error)
                return
            }
            
            guard let objectId = results?["objectId"] as? String else {
                completionHandlerForPostPin(false, NSError(domain: "Parse database new pin parse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve ID of new Student Location object"]))
                return
            }
            
            completionHandlerForPostPin(true, nil)
            self.appDelegate.student?.objectId = objectId
        }
        } else {
            
            let method = "/\(student.objectId)"
            
            taskForPOSTMethod(method: method, requestType: "PUT", parameters: parameters, jsonBody: jsonBody){(results, error) in
                
                guard (error == nil) else {
                    completionHandlerForPostPin(false, error)
                    return
                }
                
                guard (results?["updatedAt"] as? String) != nil else {
                    completionHandlerForPostPin(false, NSError(domain: "Parse database replace pin parse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse update string  of replaced Student Location object"]))
                    return
                }
                
                completionHandlerForPostPin(true, nil)
            }
        }
    }
    
    func checkPinPresent(completionHandlerForCheckPin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        var parameters = [String: AnyObject]()
        parameters[Constants.ParseApiQueryKeys.objectMatch] = self.appDelegate.student?.uniqueKey as AnyObject?
        
        taskForGETMethod(method: nil, parameters: parameters){(results, error) in
            if (results != nil) {
                completionHandlerForCheckPin(true, nil)
            } else {
                completionHandlerForCheckPin(false, error)
            }
        }
    }
}
