//
//  AssetsCell.swift
//  Fitpass
//
//  Created by SatishMac on 29/06/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class AssetsCell: UITableViewCell {
    
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var purchasedOnLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    func updateAssetsDetails (assetBean : Assets) {
        
        if let assetName = assetBean.asset_name {
            self.assetNameLabel.text = assetName
        }
        
        if let status = assetBean.asset_status {
            self.statusLabel.text = status
        }
        
        if let vendorName = assetBean.vendor_name {
            self.vendorNameLabel.text = vendorName
        }
        
        if let purchasedOn = assetBean.purchased_on {
            self.purchasedOnLabel.text = purchasedOn
        }
        
        if let amount = assetBean.amount {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: amount.stringValue+"rs", attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Amount - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.amountLabel.attributedText = myString
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
