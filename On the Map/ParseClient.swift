//
//  ParseClient.swift
//  On the Map
//
//  Created by Dr GJK Marais on 2016/11/18.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    static let sharedInstance = ParseClient()
    
    // MARK: class initialiser
    
    override init() {
        super.init()
    }
    
    func taskForGETMethod(method: String?, parameters: [String:AnyObject],completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        // parameters for URL
        var parameters = parameters
        let session = DataStorage.sharedInstance.session
        // url and request
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parameters: parameters, withPathExtension: method))
        
        request.addValue("\(Constants.ParseApiKeys.AppId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(Constants.ParseApiKeys.RestApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // making request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // request error
            guard (error == nil) else {
                sendError(error: "Request error: \(error)")
                return
            }
            
            // response code error
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Status code not 2xx")
                return
            }
            
            // no data returned error
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            //parse data
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        //start request
        task.resume()
        
    }
    
    func taskForPOSTMethod(method: String?, requestType: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        // parameters for URL
        var parameters = parameters
        let session = DataStorage.sharedInstance.session
        
        // url and request
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parameters: parameters, withPathExtension: method))
        request.httpMethod = requestType
        request.addValue("\(Constants.ParseApiKeys.AppId)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(Constants.ParseApiKeys.RestApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // making request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // request error
            guard (error == nil) else {
                sendError(error: "Request error: \(error)")
                return
            }
            
            // response code error
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Status code not 2xx")
                return
            }
            
            // no data returned error
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            //parse data
            self.convertDataWithCompletionHandler(data: data, completionHandlerForConvertData: completionHandlerForPOST)
            }
        //start request
        task.resume()
    }

    // MARK: Url generator for Udacity API
    
    func ParseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.ParseApiConstants.ApiScheme
        components.host = Constants.ParseApiConstants.ApiHost
        components.path = Constants.ParseApiConstants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // JSON data converstion and security string removal
    private func convertDataWithCompletionHandler(data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: Any!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult as AnyObject!, nil)
    }
    
}
