//
//  AssetsCell.swift
//  Fitpass
//
//  Created by SatishMac on 29/06/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class AssetsCell: UITableViewCell {
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var purchasedOnLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var statusColorView: UIView!
    
    func updateAssetsDetails (assetBean : Assets) {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let assetName = assetBean.asset_name {
            self.assetNameLabel.text = assetName
        }
        if let createdAt = assetBean.created_at{
            self.createdAtLabel.text = Utility().getDateString(dateStr: createdAt)
        }

        if let status = assetBean.asset_status {
            self.statusLabel.text = status
            if(status == "In-Use"){
                self.statusColorView.backgroundColor = UIColor(red: 253/255, green: 198/255, blue: 67/255, alpha: 1.0)
            }else if(status == "Available"){
                self.statusColorView.backgroundColor = UIColor(red: 172/255, green: 240/255, blue: 55/255, alpha: 1.0)
            }else{
                self.statusColorView.backgroundColor = UIColor(red: 253/255, green: 67/255, blue: 67/255, alpha: 1.0)
            }
        }

        if let vendorName = assetBean.vendor_name {
            self.vendorNameLabel.text = vendorName
        }
        
        if let purchasedOn = assetBean.purchased_on {
            let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.black]
            let valueString = NSMutableAttributedString(string: Utility().getDateStringSimple(dateStr: purchasedOn), attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.lightGray]
            let myString = NSMutableAttributedString(string: "Purchase Date ", attributes: myAttribute1 )
            myString.append(valueString)
            self.purchasedOnLabel.attributedText = myString
        }
        
        if let amount = assetBean.amount {
            self.amountLabel.text = "₹ "+amount.stringValue
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
