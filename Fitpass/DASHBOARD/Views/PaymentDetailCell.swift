//
//  PaymentDetailCell.swift
//  Fitpass
//
//  Created by SatishMac on 08/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class PaymentDetailCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
