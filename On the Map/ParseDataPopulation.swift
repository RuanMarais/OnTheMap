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
        
        DataStorage.sharedInstance.studentLocationDataStructArray.removeAll()
        
        var parameters = [String: AnyObject]()
        parameters[Constants.ParseApiQueryKeys.limit] = "\(limitResults)" as AnyObject?
        parameters[Constants.ParseApiQueryKeys.order] = Constants.ParseApiQueryValues.ascendingTime as AnyObject?
        
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
                
                let newStudent = StudentLocationData(studentLocationDictionary: student as [String: AnyObject?])
                DataStorage.sharedInstance.studentLocationDataStructArray.append(newStudent)
            }
            
            completionHandlerForParse(true, nil)
        }
    }
    
    func postPin(replace: Bool, student: StudentLocationData, completionHandlerForPostPin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let parameters = [String: AnyObject]()
        let student = student
        
        let key = student.studentLocationInfo["uniqueKey"] as! String
        let name = student.studentLocationInfo["firstName"] as! String
        let lastName = student.studentLocationInfo["lastName"] as! String
        let map = student.studentLocationInfo["mapString"] as! String
        let media = student.studentLocationInfo["mediaURL"] as! String
        let lat = student.studentLocationInfo["latitude"] as! Double
        let long = student.studentLocationInfo["longitude"] as! Double
        
        let jsonBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(name)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(map)\", \"mediaURL\": \"\(media)\",\"latitude\": \(lat), \"longitude\": \(long)}"
       
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
            DataStorage.sharedInstance.ownStudent.studentLocationInfo["objectId"] = objectId as AnyObject??
                
        }
        } else {
            
            let objectId = student.studentLocationInfo["objectId"] as! String
            let method = "/\(objectId)"
            
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
        guard let userID = DataStorage.sharedInstance.ownStudent.studentLocationInfo["uniqueKey"] else {
            completionHandlerForCheckPin(false, NSError(domain: "student data struct contains no uniqueKey", code: 0, userInfo: [NSLocalizedDescriptionKey: "found nil in student data struct - uniqueKey"]))
            return
        }
        parameters[Constants.ParseApiQueryKeys.objectMatch] = "{\"uniqueKey\": \"\(userID as! String)\"}" as AnyObject
        
        taskForGETMethod(method: nil, parameters: parameters){(results, error) in
            
            guard (error == nil) else {
                completionHandlerForCheckPin(false, error)
                return
            }
            
            guard let resultsArray = results?["results"] as? [[String: AnyObject]] else {
                completionHandlerForCheckPin(false, NSError(domain: "Parse database check pin parse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve ID of previous Student Location object"]))
                return
            }
            
            let objectOne = resultsArray[0]
            
            guard let objectId = objectOne["objectId"] as? String else {
                completionHandlerForCheckPin(false, NSError(domain: "Parse database check pin parse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not retrieve ID of previous Student Location object"]))
                return
            }
            
            completionHandlerForCheckPin(true, nil)
            DataStorage.sharedInstance.ownStudent.studentLocationInfo["objectId"] = objectId as AnyObject?
        }
    }
}
