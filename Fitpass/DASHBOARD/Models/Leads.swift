//
//  Leads.swift
//  Fitpass
//
//  Created by SatishMac on 26/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Leads: NSObject {
    var address : String? = ""
    var contact_number : NSNumber?
    var created_at : String? = ""
    var dob : String? = ""
    var email : String? = ""
    var gender : String?
    var id : NSNumber?
    var is_deleted : String?
    var last_comment : String?
    var lead_nature : String?
    var lead_source : String?
    var name : String? = ""
    var next_follow_up : String? = ""
    var remarks : String? = ""
    var status : String?
    var updated_at : String?
    
    func updateLeads(responseDict : NSDictionary?) -> NSMutableArray {
        
        let resultDict: NSDictionary = responseDict!.object(forKey: "result") as! NSDictionary
        let dataArray : NSArray = resultDict.object(forKey: "data") as! NSArray
        
//        if let addressTemp =  userDet["address"], !(addressTemp is NSNull){
//            self.address = addressTemp as? String
//        }else{
//            self.address = ""
//        }
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for leadObj in (dataArray as? [[String:Any]])! {
            
            let leadBean : Leads = Leads()
            
            leadBean.address = leadObj[ "address"] as? String
            leadBean.contact_number = leadObj[ "contact_number"] as? NSNumber
            leadBean.created_at = leadObj[ "created_at"] as? String
            leadBean.dob = leadObj[ "dob"] as? String
            leadBean.email = leadObj[ "email"] as? String
            leadBean.gender = leadObj[ "gender"] as? String
            leadBean.id = leadObj[ "id"] as? NSNumber
            leadBean.is_deleted = leadObj[ "is_deleted"] as? String
            leadBean.last_comment = leadObj[ "last_comment"] as? String
            leadBean.lead_nature = leadObj[ "lead_nature"] as? String
            leadBean.lead_source = leadObj[ "lead_source"] as? String
            leadBean.name = leadObj[ "name"] as? String
            leadBean.next_follow_up = leadObj[ "next_follow_up"] as? String
            leadBean.remarks = leadObj[ "remarks"] as? String
            leadBean.status = leadObj["status"] as? String
            leadBean.updated_at = leadObj["updated_at"] as? String
            
            tempArray.add(leadBean)
        }
        return tempArray
    }
}
