//
//  PaymentsCell.swift
//  Fitpass
//
//  Created by SatishMac on 08/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class PaymentsCell: UITableViewCell {
    
    @IBOutlet weak var bankUtrNumberLabel: UILabel!
    @IBOutlet weak var paymentDateLabel: UILabel!
    @IBOutlet weak var paymentMonthLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    
    
    func updatePaymentsDetails (paymentBean : Payments) {
        
        if let bankutr = paymentBean.bank_utr_number {
            self.bankUtrNumberLabel.text = bankutr
        }
        
        if let paymentdate = paymentBean.payment_date {
            self.paymentDateLabel.text = paymentdate
        }
        
        if let paymentmonth = paymentBean.payment_of_month {
            self.paymentMonthLabel.text = paymentmonth
        }
        
        if let totalamount = paymentBean.total_amount {
            self.totalAmountLabel.text = totalamount
        }
        
        if let paymentstatus = paymentBean.payment_status {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: paymentstatus, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Payment status - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.paymentStatusLabel.attributedText = myString
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
