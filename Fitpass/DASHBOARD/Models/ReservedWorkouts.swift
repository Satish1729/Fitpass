//
//  ReservedWorkouts.swift
//  Fitpass
//
//  Created by Satish Regeti on 13/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class ReservedWorkouts: NSObject {
   
    var workout_date : String? = ""
    var workout_name : String? = ""
    var user_name : String? = ""
    var user_membership_id : String? = ""
    var user_mobile : String? = ""
    var status : String? = ""
    var start_time : String? = ""
    var user_schedule_id : String? = ""
    var create_time : String? = ""
    
    func updateReservedWorkouts(responseDict : NSDictionary?) -> NSMutableArray {
        
        let resultDict: NSDictionary = responseDict!.object(forKey: "result") as! NSDictionary
        let dataArray : NSArray = resultDict.object(forKey: "data") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for reservedObj in (dataArray as? [[String:Any]])! {
            
            let reservedBean : ReservedWorkouts = ReservedWorkouts()
            
            reservedBean.workout_date = reservedObj["workout_date"] as? String
            reservedBean.workout_name = reservedObj["workout_name"] as? String
            reservedBean.user_name = reservedObj["user_name"] as? String
            reservedBean.user_membership_id = reservedObj["user_membership_id"] as? String
            reservedBean.user_mobile = reservedObj["user_mobile"] as? String
            reservedBean.status = reservedObj["status"] as? String
            reservedBean.start_time = reservedObj["start_time"] as? String
            reservedBean.user_schedule_id = reservedObj["user_schedule_id"] as? String
            reservedBean.create_time = reservedObj["create_time"] as? String
            
            tempArray.add(reservedBean)
        }
        return tempArray
    }
}

