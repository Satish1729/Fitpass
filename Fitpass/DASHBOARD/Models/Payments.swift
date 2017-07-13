//
//  Payments.swift
//  Fitpass
//
//  Created by SatishMac on 08/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Payments: NSObject {
    
    var attended_workout : String? = ""
    var bank_utr_number : String? = ""
    var comment : String? = ""
    var pay_amount : String? = ""
    var payment_date : String? = ""
    var payment_of_month : String? = ""
    var payment_status : String? = ""
    var total_amount : String? = ""
    var workout_reserved : String? = ""
    
    func updatePayments(responseDict : NSDictionary?) -> NSMutableArray {
        let dataArray : NSArray = responseDict!.object(forKey: "data") as! NSArray
        let tempArray : NSMutableArray = NSMutableArray()
        for paymentObj in (dataArray as? [[String:Any]])! {
            let paymentBean : Payments = Payments()
            paymentBean.attended_workout = paymentObj[ "attended_workout"] as? String
            paymentBean.bank_utr_number = paymentObj[ "bank_utr_number"] as? String
            paymentBean.comment = paymentObj[ "comment"] as? String
            paymentBean.pay_amount = paymentObj[ "pay_amount"] as? String
            paymentBean.payment_date = paymentObj[ "payment_date"] as? String
            paymentBean.payment_of_month = paymentObj[ "payment_of_month"] as? String
            paymentBean.payment_status = paymentObj[ "payment_status"] as? String
            paymentBean.total_amount = paymentObj[ "total_amount"] as? String
            paymentBean.workout_reserved = paymentObj[ "workout_reserved"] as? String
            tempArray.add(paymentBean)
        }
        return tempArray
    }
}
