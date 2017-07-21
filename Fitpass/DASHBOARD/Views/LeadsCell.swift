
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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var nextFollowUpLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    
    func updateLeadsDetails (leadBean : Leads) {
        
        if let name = leadBean.name {
            self.nameLabel.text = name
        }
        
        if let leadNature = leadBean.lead_nature {
            self.leadNatureLabel.text = leadNature
        }

        if let email = leadBean.email {
            self.emailLabel.text = email
        }

        if let contactNumber = leadBean.contact_number {
            self.contactNumberLabel.text = contactNumber.stringValue
        }

        if let createdAt = leadBean.created_at {
            self.createdAtLabel.text = Utility().getDateString(dateStr: createdAt)
        }
        
        if let nextFollowUp = leadBean.next_follow_up {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: Utility().getDateStringSimple(dateStr: nextFollowUp), attributes: myAttribute )
//            let valueString = NSMutableAttributedString(string: nextFollowUp, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Next Follow Up - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.nextFollowUpLabel.attributedText = myString
            
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
