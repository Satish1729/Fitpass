//
//  Staffs.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Staffs: NSObject {

    var address : String? = ""
    var contact_number : NSNumber?
    var created_at : String? = ""
    var created_by : String? = ""
    var dob : String? = ""
    var email : String? = ""
    var gender : String?
    var id : NSNumber?
    var is_active : NSNumber?
    var is_deleted : String?
    var joining_date : String? = ""
    var joining_documents : String?
    var name : String? = ""
    var remarks : String? = ""
    var role : String? = ""
    var salary : String? = ""
    var salary_date : NSNumber?
    var updated_at : String?
    
    func updateStaffs(responseDict : NSDictionary?) -> NSMutableArray {
        
        let resultDict: NSDictionary = responseDict!.object(forKey: "result") as! NSDictionary
        let dataArray : NSArray = resultDict.object(forKey: "data") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for staffObj in (dataArray as? [[String:Any]])! {
            
            let staffBean : Staffs = Staffs()
            
            staffBean.address = staffObj[ "address"] as? String
            staffBean.contact_number = staffObj[ "contact_number"] as? NSNumber
            staffBean.created_at = staffObj[ "created_at"] as? String
            staffBean.created_by = staffObj["created_by"] as? String
            staffBean.dob = staffObj[ "date_of_birth"] as? String
            staffBean.email = staffObj[ "email_address"] as? String
            staffBean.gender = staffObj[ "gender"] as? String
            staffBean.id = staffObj[ "id"] as? NSNumber
            staffBean.is_active = staffObj["is_active"] as? NSNumber
            staffBean.is_deleted = staffObj[ "is_deleted"] as? String
            staffBean.joining_date = staffObj[ "joining_date"] as? String
            staffBean.joining_documents = staffObj[ "joining_documents"] as? String
            staffBean.name = staffObj[ "staff_name"] as? String
            staffBean.remarks = staffObj[ "remarks"] as? String
            staffBean.role = staffObj[ "role"] as? String
            staffBean.salary = staffObj[ "salary"] as? String
            staffBean.salary_date = staffObj[ "salary_date"] as? NSNumber
            staffBean.updated_at = staffObj["updated_at"] as? String
            
            tempArray.add(staffBean)
        }
        return tempArray
    }
}
