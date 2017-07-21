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

    
    func updateMembersDetails (memberBean : Members) {
        
        if let name = memberBean.name {
            self.nameLabel.text = name
        }
        
        if let isActive = memberBean.is_active{
            if(isActive.stringValue == "1"){
                self.isActiveLabel.text = "Active"
            }else{
                self.isActiveLabel.text = "InActive"
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
        }
        
        if let timeFrom = memberBean.preferred_time_slot_from {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: timeFrom+" to "+memberBean.preferred_time_slot_to!, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Preferred time slot - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.preferredTimeSlotLabel.attributedText = myString
            
            self.callButton.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
            self.mailButton.addTarget(self, action: #selector(email), for: UIControlEvents.touchUpInside)
        }
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
