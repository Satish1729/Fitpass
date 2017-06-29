//
//  StaffCell.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class StaffCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var joiningDateLabel: UILabel!
    
    func updateStaffDetails (staffBean : Staffs) {
        
        if let name = staffBean.name {
            self.nameLabel.text = name
        }
        
        if let email = staffBean.email {
            self.emailLabel.text = email
        }

        if let contactNumber = staffBean.contact_number {
            self.contactNumberLabel.text = contactNumber.stringValue
        }
        
        if let createdAt = staffBean.created_at {
            self.createdAtLabel.text = createdAt
        }
        
        if let role = staffBean.role {
            self.roleLabel.text = role
        }
        
        if let joiningDate = staffBean.joining_date {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: joiningDate, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Joining Date - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.joiningDateLabel.attributedText = myString
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
