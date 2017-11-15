//
//  Members.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Members: NSObject {

    var address : String? = ""
    var agreed_amount : NSNumber?
    var contact_number : NSNumber?
    var created_at : String? = ""
    var created_by : String? = ""
    var dob : String? = ""
    var email : String? = ""
    var gender : String?
    var id : NSNumber?
    var is_active : NSNumber?
    var is_deleted : NSNumber?
    var joining_date : String?
    var name : String? = ""
    var payment_date : NSNumber?
    var preferred_time_slot_from : String?
    var preferred_time_slot_to : String?
    var remarks : String? = ""
    var status : String?
    var subscription_plan : String? = ""
    var updated_at : String?
    var updated_by : String?
    
    func updateMembers(responseDict : NSDictionary?) -> NSMutableArray {
        
        let resultDict: NSDictionary = responseDict!.object(forKey: "result") as! NSDictionary
        let dataArray : NSArray = resultDict.object(forKey: "data") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for memberObj in (dataArray as? [[String:Any]])! {
            
            let memberBean : Members = Members()

            memberBean.address = memberObj[ "member_address"] as? String
            memberBean.agreed_amount = memberObj["agreed_amount"] as? NSNumber
            memberBean.contact_number = memberObj[ "contact_number"] as? NSNumber
            memberBean.created_at = memberObj[ "created_at"] as? String
            memberBean.created_by = memberObj[ "created_by"] as? String
            memberBean.dob = memberObj[ "date_of_birth"] as? String
            memberBean.email = memberObj[ "email_address"] as? String
            memberBean.gender = memberObj[ "gender"] as? String
            memberBean.id = memberObj[ "id"] as? NSNumber
            memberBean.is_active = memberObj["is_active"] as? NSNumber
            memberBean.is_deleted = memberObj[ "is_deleted"] as? NSNumber
            memberBean.joining_date = memberObj["joining_date"] as? String
            memberBean.name = memberObj[ "member_name"] as? String
            memberBean.payment_date = memberObj[ "payment_date"] as? NSNumber
            memberBean.preferred_time_slot_from = memberObj[ "preferred_time_slot_from"] as? String
            memberBean.preferred_time_slot_to = memberObj[ "preferred_time_slot_to"] as? String
            memberBean.remarks = memberObj[ "remarks"] as? String
            memberBean.status = memberObj["member_status"] as? String
            memberBean.subscription_plan = memberObj[ "subscription_plan"] as? String
            memberBean.updated_at = memberObj["updated_at"] as? String
            memberBean.updated_by = memberObj["updated_by"] as? String
            
            tempArray.add(memberBean)
        }
        return tempArray
    }
}

