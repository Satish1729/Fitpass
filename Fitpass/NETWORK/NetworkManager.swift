//
//  NetworkManager.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import Alamofire

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

class NetworkManager: NSObject {
    //    var completionBlock: ((Data?,HTTPURLResponse?,Error?) -> ())?
    
    //MARK: Singleton Instance
    static let sharedInstance = NetworkManager()
    
    //MARK: Create URL Request
    func createURLRequestForURLWithType(urlString:String,type:String) -> NSMutableURLRequest {
        let url:NSURL! = NSURL.init(string: urlString as String)
        let urlRequest: NSMutableURLRequest! = NSMutableURLRequest.init(url: url as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = type as String
        return urlRequest
    }
    
    //MARK: Create URL Response
    func getResponseForURLWithParameters(url:String, userInfo:NSDictionary?,type:String,completion:@escaping (Data?,HTTPURLResponse?,Error?)->()) {
        let urlRequest = createURLRequestForURLWithType(urlString: url as String,type: type as String)
        if appDelegate.userBean?.authHeader != nil {
            urlRequest.addValue((appDelegate.userBean?.authHeader)!, forHTTPHeaderField: "Authorization")
        }
        if userInfo != nil {
            let parametersData:Data = try! JSONSerialization.data(withJSONObject: userInfo!, options: .prettyPrinted)
            urlRequest.httpBody = parametersData as Data
            let string = NSString.init(data: urlRequest.httpBody!, encoding:String.Encoding.utf8.rawValue)
            print("user parameters \(String(describing: string))  \n \(urlRequest)")
            
        }
        
        let urlSessionConfiguration:URLSessionConfiguration! = URLSessionConfiguration.default
        let urlSession:URLSession! = URLSession.init(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
        let urlDataTask:URLSessionDataTask = urlSession.dataTask(with: urlRequest as URLRequest) { (data, urlResponse, error) in
            
            if (urlResponse != nil) {
                let httpURLResponse:HTTPURLResponse = urlResponse as! HTTPURLResponse
                if error == nil && httpURLResponse.statusCode == 200{
                    completion(data! as Data?,httpURLResponse,nil)
                }
                else{
                    print(httpURLResponse.statusCode)
                    
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDict:NSDictionary? = jsonObject as? NSDictionary
                    if (responseDict != nil) {
                        print(responseDict!)
                    }
                    
                    
                    let userInfo: [NSObject : AnyObject] =
                        [
                            NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Unauthorized", value: "Something went wrong...", comment: "") as AnyObject,
                            NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Unauthorized", value: "Account not activated", comment: "") as AnyObject
                    ]
                    let err = NSError(domain: "HttpResponseErrorDomain", code: httpURLResponse.statusCode, userInfo: userInfo)
                    
                    completion(data! as Data?,nil,err)
                }
            }
            else{
                completion(data as Data?,nil,error)
            }
        }
        urlDataTask.resume()
    }
    
    
    //MARK: Create URL Response
    func applyLeaveWithFileURLWithParameters(url:String, userInfo:NSDictionary?,type:String, fileData : UIImage?,completion:@escaping (Data?,HTTPURLResponse?,Error?)->()) {
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            for (key, value) in userInfo! {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key as! String)
            }
            if fileData != nil {
                let imageData = UIImageJPEGRepresentation(fileData!, 0.5)
                multipartFormData.append(imageData!, withName: "file", fileName: "leave_file.jpg", mimeType: "image/jpeg")
            }
        },
                         usingThreshold:UInt64.init(),
                         to:url,
                         method:HTTPMethod(rawValue: type)!,
                         headers:["authorization": (appDelegate.userBean?.authHeader)!],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    if (response.response?.statusCode == 200) {
                                        
                                        completion(response.data as Data?,response.response,response.error)
                                        
                                    } else{
                                        print(response.response?.statusCode ?? 400)
                                        
                                        let jsonObject = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                        let responseDict:NSDictionary? = jsonObject as? NSDictionary
                                        if (responseDict != nil) {
                                            print(responseDict!)
                                            var errorMessage : String =  "Something went wrong..."
                                            if (responseDict?.value(forKey: "message")) != nil {
                                                errorMessage = (responseDict?.object(forKey: "message") as? String)!
                                            } else if (responseDict?.value(forKey: "error")) != nil {
                                                errorMessage = (responseDict?.object(forKey: "error") as? String)!
                                            }
                                            
                                            let userInfo: [NSObject : AnyObject] =
                                                [
                                                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Unauthorized", value: errorMessage, comment: "") as AnyObject,
                                                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Unauthorized", value: errorMessage, comment: "") as AnyObject
                                            ]
                                            let err = NSError(domain: "HttpResponseErrorDomain", code: (response.response?.statusCode)!, userInfo: userInfo)
                                            
                                            completion(response.data! as Data?,nil,err)
                                            
                                        } else {
                                            let userInfo: [NSObject : AnyObject] =
                                                [
                                                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("Unauthorized", value: "Something went wrong...", comment: "") as AnyObject,
                                                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("Unauthorized", value: "Account not activated", comment: "") as AnyObject
                                            ]
                                            let err = NSError(domain: "HttpResponseErrorDomain", code: (response.response?.statusCode)!, userInfo: userInfo)
                                            
                                            completion(response.data! as Data?,nil,err)
                                            
                                        }
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completion(nil,nil,encodingError)
                            }
        })
        
    }
}
