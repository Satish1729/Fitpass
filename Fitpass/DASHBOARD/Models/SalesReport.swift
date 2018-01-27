//
//  SalesReport.swift
//  Fitpass
//
//  Created by Quantela on 28/11/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class SalesReport: NSObject {
    
    var contact_number : NSNumber?
    var due_date : String?
    var id : NSNumber?
    
    var member_name : String?
    var order_id : NSNumber?
    var paid_date : String?
    
    var payment_source:String?
    var status : String?
    var subscription_plan:String?
    
    var total_order_amount : NSNumber?
    var total_paid_amount : NSNumber?
    var transaction_id : NSNumber?

    func updateSalesReport(responseDict : NSDictionary?) -> NSMutableArray {
        
        let resultDict: NSDictionary = responseDict!.object(forKey: "result") as! NSDictionary
        let dataArray : NSArray = resultDict.object(forKey: "data") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for salesReportObj in (dataArray as? [[String:Any]])! {
            
            let salesReportBean : SalesReport = SalesReport()
            
            salesReportBean.contact_number = salesReportObj[ "contact_number"] as? NSNumber
            salesReportBean.due_date = salesReportObj[ "due_date"] as? String
            salesReportBean.id = salesReportObj[ "id"] as? NSNumber
            
            salesReportBean.member_name = salesReportObj[ "member_name"] as? String
            salesReportBean.order_id = salesReportObj[ "order_id"] as? NSNumber
            salesReportBean.paid_date = salesReportObj[ "paid_date"] as? String
            
            salesReportBean.payment_source = salesReportObj[ "payment_source"] as? String
            salesReportBean.status = salesReportObj["status"] as? String
            salesReportBean.subscription_plan = salesReportObj[ "subscription_plan"] as? String
            
            salesReportBean.total_order_amount = salesReportObj["agreed_amount"] as? NSNumber
            salesReportBean.total_paid_amount = salesReportObj[ "total_paid_amount"] as? NSNumber
            salesReportBean.transaction_id = salesReportObj["transaction_id"] as? NSNumber
            
            tempArray.add(salesReportBean)
        }
        return tempArray
    }
}



