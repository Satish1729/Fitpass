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
            self.createdAtLabel.text = createdAt
        }
        
        if let timeFrom = memberBean.preferred_time_slot_from {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: timeFrom+" to "+memberBean.preferred_time_slot_to!, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Preferred time slot - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.preferredTimeSlotLabel.attributedText = myString
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
