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
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var borderView: UIView!
    
    func updateStaffDetails (staffBean : Staffs) {
        
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let name = staffBean.name {
            self.nameLabel.text = name
        }
        
        if let email = staffBean.email {
            self.mailButton.setTitle(email, for: UIControlState.normal)
        }

        if let contactNumber = staffBean.contact_number {
            self.callButton.setTitle(contactNumber.stringValue, for: UIControlState.normal)
        }

        if let createdAt = staffBean.created_at {
            self.createdAtLabel.text = Utility().getDateString(dateStr: createdAt)
        }
        
        if let role = staffBean.role {
            self.roleLabel.text = role
        }
        
        if let joiningDate = staffBean.joining_date {
            let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.black]
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.lightGray]

            let valueString = NSMutableAttributedString(string: Utility().getDateStringSimple(dateStr: joiningDate), attributes: myAttribute )
            let myString = NSMutableAttributedString(string: "Joining Date ", attributes: myAttribute1 )
            myString.append(valueString)
            self.joiningDateLabel.attributedText = myString
            
            self.callButton.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
            self.mailButton.addTarget(self, action: #selector(email), for: UIControlEvents.touchUpInside)
        }
    }
    func call(){
        callTheNumber(numberString: (self.callButton.titleLabel?.text)!)
    }
    
    func email(){
        sendMailTo(mailString: (self.mailButton.titleLabel?.text)!)
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
