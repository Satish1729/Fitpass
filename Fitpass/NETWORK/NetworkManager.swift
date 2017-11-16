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
            urlRequest.addValue((appDelegate.userBean?.authHeader)!, forHTTPHeaderField: "x-auth-token")
        }
        if appDelegate.userBean?.auth_key != nil {
            urlRequest.addValue("hgdsdjfvsdjfvsdfvhjsdfjsavdfusdfuysfx", forHTTPHeaderField: "X-APPKEY")
//            urlRequest.addValue((appDelegate.userBean?.auth_key)!, forHTTPHeaderField: "X-APPKEY")
        }
        if appDelegate.userBean?.partner_id != nil {
            urlRequest.addValue("1588", forHTTPHeaderField: "X-partner-id") //(appDelegate.userBean?.partner_id)!
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
    


}
