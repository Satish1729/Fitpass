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
    @IBOutlet weak var paymentStatusColrView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    func updatePaymentsDetails (paymentBean : Payments) {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let bankutr = paymentBean.bank_utr_number {
            self.bankUtrNumberLabel.text = bankutr
        }
        
        if let paymentdate = paymentBean.payment_date {
            self.paymentDateLabel.text = Utility().getDateStringSimple(dateStr: paymentdate)
        }
        
        if let comment = paymentBean.comment{
            self.commentLabel.text = comment
            if(comment == ""){
                self.commentLabel.text = "NA"
            }
        }
        
        if let paymentmonth = paymentBean.payment_of_month {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: Utility().getMonthString(dateStr: paymentmonth), attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Payment Month ", attributes: myAttribute1 )
            myString.append(valueString)
            self.paymentMonthLabel.attributedText = myString
        }
        
        if let totalamount = paymentBean.total_amount {
            self.totalAmountLabel.text = "₹ "+totalamount
        }
        
        if let paymentstatus = paymentBean.payment_status {
            self.paymentStatusLabel.text = paymentstatus
            if(paymentstatus == "Transferred"){
                self.paymentStatusColrView.backgroundColor = UIColor(red: 172/255, green: 240/255, blue: 55/255, alpha: 1.0)
            }
            else{
                self.paymentStatusColrView.backgroundColor = UIColor(red: 253/255, green: 67/255, blue: 67/255, alpha: 1.0)
            }
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
