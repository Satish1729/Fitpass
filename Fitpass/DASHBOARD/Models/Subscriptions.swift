//
//  Subscriptions.swift
//  Fitpass
//
//  Created by Satish Regeti on 21/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Subscriptions: NSObject {

    
    var created_at : String? = ""
    var created_by : String? = ""
    var descriptionString : String? = ""
    var duration : NSNumber?
    var id : NSNumber?
    var is_active : NSNumber?
    var is_deleted : NSNumber?
    var mrp : NSNumber?
    var plan_name : String? = ""
    var selling_price : NSNumber?
    var updated_at : String? = ""
    var updated_by : String? = ""

    
    func updateSubscriptions(responseDict : NSDictionary?) -> NSMutableArray {
        
        let dataArray : NSArray = responseDict!.object(forKey: "result") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for subscriptionObj in (dataArray as? [[String:Any]])! {
            
            let subscriptionBean : Subscriptions = Subscriptions()
            
            subscriptionBean.created_at = subscriptionObj["created_at"] as? String
            subscriptionBean.created_by = subscriptionObj["created_by"] as? String
            subscriptionBean.descriptionString = subscriptionObj[ "description"] as? String
            subscriptionBean.duration = subscriptionObj[ "duration"] as? NSNumber
            subscriptionBean.id = subscriptionObj[ "id"] as? NSNumber
            subscriptionBean.is_active = subscriptionObj[ "is_active"] as? NSNumber
            subscriptionBean.is_deleted = subscriptionObj[ "is_deleted"] as? NSNumber
            subscriptionBean.mrp = subscriptionObj[ "mrp"] as? NSNumber
            subscriptionBean.plan_name = subscriptionObj[ "plan_name"] as? String
            subscriptionBean.selling_price = subscriptionObj[ "selling_price"] as? NSNumber
            subscriptionBean.updated_at = subscriptionObj[ "updated_at"] as? String
            subscriptionBean.updated_by = subscriptionObj[ "updated_by"] as? String
            
            tempArray.add(subscriptionBean)
        }
        return tempArray
    }
}
