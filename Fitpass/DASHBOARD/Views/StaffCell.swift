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
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var joiningDateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    func updateStaffDetails (staffBean : Staffs) {
        
        if let name = staffBean.name {
            self.nameLabel.text = name
        }
        
        if let role = staffBean.role {
            self.roleLabel.text = role
        }
        
        if let contactNumber = staffBean.contact_number {
            self.contactNumberLabel.text = contactNumber.stringValue
        }
        
        if let joiningDate = staffBean.joining_date {
            self.joiningDateLabel.text = joiningDate
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
