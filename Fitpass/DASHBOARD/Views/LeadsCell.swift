
//
//  LeadsCell.swift
//  Fitpass
//
//  Created by SatishMac on 26/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class LeadsCell: UITableViewCell {

    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var leadTypeImageView: UIImageView!
    @IBOutlet weak var leadTypeLabel: UILabel!
    @IBOutlet weak var natureColorLabel: UIView!
    @IBOutlet weak var leadNatureLabel: UILabel!
    @IBOutlet weak var nextFollowUpLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    
    func updateLeadsDetails (leadBean : Leads) {
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let name = leadBean.name {
            self.nameLabel.text = name
        }
        
        if let leadNature = leadBean.lead_nature {
            self.leadNatureLabel.text = leadNature
//            self.statusImageView.layer.cornerRadius = self.statusImageView.frame.size.width / 2
//            self.statusImageView.clipsToBounds = true
            switch leadNature {
            case "Warm":
                self.natureColorLabel.backgroundColor = UIColor.yellow //UIColor(red: 105/255, green: 194/255, blue: 255/255, alpha: 1.0)
            case "Hot":
                self.natureColorLabel.backgroundColor = UIColor.red
            case "Cold":
                self.natureColorLabel.backgroundColor = UIColor(red: 105/255, green: 194/255, blue: 255/255, alpha: 1.0)
            default:
                self.natureColorLabel.backgroundColor = UIColor.white
            }
        }

        if let leadType = leadBean.status {
            self.leadTypeLabel.text = leadType
            switch leadType {
            case "Member":
                self.leadTypeImageView.image = UIImage(named: "profile")
            case "Open":
                self.leadTypeImageView.image = UIImage(named: "pulse")
            case "Dead":
                self.leadTypeImageView.image = UIImage(named: "dead")
            default:
                self.leadTypeImageView.image = UIImage(named: "profile")
            }
            self.leadTypeImageView.layer.cornerRadius = self.leadTypeImageView.frame.size.width / 2
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
            
            var valueString:NSMutableAttributedString
            if(leadBean.next_follow_up == "0000-00-00"){
                valueString = NSMutableAttributedString.init(string: "NA")
            }else{
                valueString = NSMutableAttributedString(string: Utility().getDateStringSimple(dateStr: nextFollowUp), attributes: myAttribute )
            }
                //            let valueString = NSMutableAttributedString(string: nextFollowUp, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Next Follow Up - ", attributes: myAttribute1 )
            myString.append(valueString)
            self.nextFollowUpLabel.attributedText = myString
            

        }
        self.callButton.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
        self.mailButton.addTarget(self, action: #selector(email), for: UIControlEvents.touchUpInside)

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
