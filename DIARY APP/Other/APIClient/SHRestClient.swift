//
//  SHRestClient.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import SwiftyJSON

class SHRestClient: NSObject {
    
    typealias SHHTTPResponseHandlerTwoWithData = (_ data: Data?,_ data:JSON?,_ error: Error?) -> Void
    var httpMethod: String = ""
    var httpBody: String = ""
    var urlString: String = ""
    var contentType: String = ""
    var authorizationValue: String = ""
    var headerFieldsAndValues : NSDictionary?
    var recievedData : NSMutableData?
    
    convenience init(withUrl url: String!, Body body: String?, Method method: String?, Headers headerFieldsAndValues: NSDictionary?) {
        self.init()
        self.httpBody = body!
        self.urlString = url
        self.httpMethod = method!
        if headerFieldsAndValues != nil {
            self.headerFieldsAndValues = headerFieldsAndValues
        }
    }
    
    public func sendParameters(_ httpResponseHandler: @escaping SHHTTPResponseHandlerTwoWithData) {
        guard let url = URL(string: self.urlString) else {
            COMMON_SINON.SHARED.DLOG(message: "Error: cannot create URL")
            return
        }
        let defaultConfig = URLSessionConfiguration.default
        let defaultSession = URLSession(configuration: defaultConfig)
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 30.0)
        request.httpMethod = self.httpMethod
        request.httpBody = !self.httpBody.isEmpty ? self.httpBody.data(using: .utf8) : "".data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.headerFieldsAndValues?.enumerateKeysAndObjects({ (key, value, stop) -> Void in
            request.setValue(value as! NSString as String, forHTTPHeaderField: key as! NSString as String)
        })
        let task = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            if error == nil {
                guard let responseData = data else {
                    COMMON_SINON.SHARED.DLOG(message: "Error: did not receive data")
                    
                    return
                }
                if let returnData = String(data: responseData, encoding: .utf8) {
                    COMMON_SINON.SHARED.DLOG(message: "OUTPUT in String : \(returnData)")
                }
                do{
                    let json = try JSON(data: responseData)
                    httpResponseHandler(responseData,json, nil)
                }
                catch {
                    httpResponseHandler(responseData,nil, nil)
                }
            } else {
                httpResponseHandler(data,nil, error)
            }
        })
        task.resume()
    }
}
