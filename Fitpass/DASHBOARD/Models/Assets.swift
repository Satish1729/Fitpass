//
//  Assets.swift
//  Fitpass
//
//  Created by SatishMac on 28/06/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Assets: NSObject {
    var amount : NSNumber?
    var asset_name : String? = ""
    var asset_status : String? = ""
    var bill : String? = ""
    var created_at : String? = ""
    var created_by : String? = ""
    var id : NSNumber?
    var is_active : NSNumber?
    var is_deleted : NSNumber?
    var purchased_on : String?
    var remarks : String? = ""
    var updated_at : String?
    var updated_by : String?
    var vendor_name : String?
    
    func updateAssets(responseDict : NSDictionary?) -> NSMutableArray {
        
        let resultDict: NSDictionary = responseDict!.object(forKey: "result") as! NSDictionary
        let dataArray : NSArray = resultDict.object(forKey: "data") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for assetObj in (dataArray as? [[String:Any]])! {
            
            let assetBean : Assets = Assets()
            
            assetBean.amount = assetObj[ "amount"] as? NSNumber
            assetBean.asset_name = assetObj[ "asset_name"] as? String
            assetBean.asset_status = assetObj[ "asset_status"] as? String
            assetBean.bill = assetObj[ "bill"] as? String
            assetBean.created_at = assetObj[ "created_at"] as? String
            assetBean.created_by = assetObj[ "created_by"] as? String
            assetBean.id = assetObj[ "id"] as? NSNumber
            assetBean.is_active = assetObj[ "is_active"] as? NSNumber
            assetBean.is_deleted = assetObj[ "is_deleted"] as? NSNumber
            assetBean.purchased_on = assetObj[ "purchased_on"] as? String
            assetBean.remarks = assetObj[ "remarks"] as? String
            assetBean.updated_at = assetObj["updated_at"] as? String
            assetBean.updated_by = assetObj["updated_by"] as? String
            assetBean.vendor_name = assetObj["vendor_name"] as? String
            
            tempArray.add(assetBean)
        }
        return tempArray
    }
}
