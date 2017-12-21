//
//  SalesReportCell.swift
//  Fitpass
//
//  Created by Quantela on 28/11/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class SalesReportCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isActiveLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var totalPaidLabel: UILabel!
    @IBOutlet weak var totalOrderLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    func updateSalesReportDetails (salesReportBean : SalesReport) {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0
        
        if let paidDate = salesReportBean.paid_date{
            self.createdAtLabel.text = Utility().getDateStringSimple(dateStr: paidDate)
        }
        
        if let contactNumber = salesReportBean.contact_number {
            self.callButton.setTitle(contactNumber.stringValue, for: UIControlState.normal)
        }

        if let name = salesReportBean.member_name {
            self.nameLabel.text = name
        }
        if let plan = salesReportBean.subscription_plan{
            self.planLabel.text = plan
        }
        if let paidAmount = salesReportBean.total_paid_amount{
            self.totalPaidLabel.text = formatCurrency(value: paidAmount)+"(Paid Amount)"
        }
        if let orderAmount = salesReportBean.total_order_amount{
            self.totalOrderLabel.text = formatCurrency(value: orderAmount)+"(Total Order Amount)"
        }
        
        if let isActive = salesReportBean.status{ //memberBean.is_active{
            if(isActive == "Paid"){
                self.statusView.backgroundColor = UIColor(red: 172/255, green: 240/255, blue: 55/255, alpha: 1.0)
            }else{
                self.statusView.backgroundColor = UIColor(red: 253/255, green: 67/255, blue: 67/255, alpha: 1.0)
            }
            self.isActiveLabel.text = isActive
        }

        if let dueDate = salesReportBean.due_date {
            let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.black]
            let valueString = NSMutableAttributedString(string: Utility().getDateStringSimple(dateStr: dueDate), attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.lightGray]
            let myString = NSMutableAttributedString(string: "Expiry Date ", attributes: myAttribute1 )
            myString.append(valueString)
            self.dueDateLabel.attributedText = myString
        }
        
        self.callButton.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
    }
    
    
    func call(){
        callTheNumber(numberString: self.contactNumberLabel.text!)
    }
    
    
    func callTheNumber(numberString : String){
        if let url = URL(string: "tel://\(numberString)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func formatCurrency(value: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencyCode = "INR"
//        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value)
        return result!
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
