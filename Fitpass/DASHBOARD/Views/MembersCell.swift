//
//  MembersCell.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class MembersCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isActiveLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var preferredTimeSlotLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var timeslotLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    func updateMembersDetails (memberBean : Members) {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let name = memberBean.name {
            self.nameLabel.text = name
        }
        
        if let isActive = memberBean.status{ //memberBean.is_active{
            if(isActive == "Active"){
                self.isActiveLabel.text = "Active"
                self.statusView.backgroundColor = UIColor.green
            }else{
                self.isActiveLabel.text = "Inactive"
                self.statusView.backgroundColor = UIColor.red
            }
        }
        
        if let email = memberBean.email {
            self.emailLabel.text = email
        }
        
        if let contactNumber = memberBean.contact_number {
            self.contactNumberLabel.text = contactNumber.stringValue
        }
        
        if let createdAt = memberBean.created_at {
            self.createdAtLabel.text = Utility().getDateString(dateStr: createdAt)
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: self.createdAtLabel.text!, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Expiry Date ", attributes: myAttribute1 )
            myString.append(valueString)
            self.preferredTimeSlotLabel.attributedText = myString
        }
        
        if let timeFrom = memberBean.preferred_time_slot_from {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: timeFrom+" to "+memberBean.preferred_time_slot_to!, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Time slot - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.timeslotLabel.attributedText = myString
        }
        
        
        self.callButton.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
        self.mailButton.addTarget(self, action: #selector(email), for: UIControlEvents.touchUpInside)
    }
    
    
    func call(){
        callTheNumber(numberString: self.contactNumberLabel.text!)
    }

    func email(){
        sendMailTo(mailString: self.emailLabel.text!)
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
    func sendMailTo(mailString : String){
        if let url = URL(string: "mailto:\(mailString)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
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
