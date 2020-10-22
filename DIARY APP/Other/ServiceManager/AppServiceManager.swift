//
//  APIManager.swift
//  Developer
//
//  Created by Krupa Detroja on 22/10/20.
//  Copyright © 2020 DIARY APP. All rights reserved.
//

import UIKit
import SwiftyJSON

class APIManager: NSObject {
    
    typealias ServiceCompletionHandlerTwoWithData = (_ objectData: Data?,_ object: JSON?,_ message: String?,_ error: Error?) -> Void

    public class func getAllNotestList(with handler: @escaping ServiceCompletionHandlerTwoWithData){
        
        let url = "\(BASE_URL)\(BASE_NOTES)"
        let httpBody = ""
        
        let restClient = SHRestClient(withUrl: url, Body: httpBody, Method: "GET", Headers: nil)
        
        restClient.sendParameters { (data,object, error) in
            if error == nil
            {
                if let response = object
                {
                    handler(data,response,nil,error)
                }
            }
            else
            {
                handler(nil,nil,nil,error)
            }
        }
    }
}
