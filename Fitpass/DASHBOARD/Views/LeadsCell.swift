
//
//  LeadsCell.swift
//  Fitpass
//
//  Created by SatishMac on 26/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class LeadsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var leadNatureLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    func updateLeadsDetails (leadBean : Leads) {
        
        if let name = leadBean.name {
            self.nameLabel.text = name
        }
        
        if let leadNature = leadBean.lead_nature {
            self.leadNatureLabel.text = leadNature
        }
        
        if let contactNumber = leadBean.contact_number {
            self.contactNumberLabel.text = contactNumber.stringValue
        }

        if let createdAt = leadBean.created_at {
            self.createdAtLabel.text = createdAt
        }
        
        if let status = leadBean.status {
            self.statusLabel.text = status
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
