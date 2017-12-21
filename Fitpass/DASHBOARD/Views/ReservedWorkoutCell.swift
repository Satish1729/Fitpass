//
//  ReservedWorkoutCell.swift
//  Fitpass
//
//  Created by Satish Regeti on 13/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class ReservedWorkoutCell: UITableViewCell {

    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutDateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var membershipIdLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColorView: UIView!
    
    func updateReservedWorkoutDetails (reservedBean : ReservedWorkouts) {
        
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView.layer.shadowOpacity = 1.0
        self.borderView.layer.shadowRadius = 0.0
        self.borderView.layer.masksToBounds = false
        self.borderView.layer.cornerRadius = 1.0

        if let workoutname = reservedBean.user_name {
            self.workoutNameLabel.text = workoutname
        }
        
        if let workoutdate = reservedBean.workout_date {
            self.workoutDateLabel.text = Utility().getDateStringSimple(dateStr: workoutdate)
        }
        
        if let username = reservedBean.workout_name {
            self.categoryName.text = username
        }
        
        if let startTime = reservedBean.start_time {
            self.membershipIdLabel.text = startTime
        }
        if let mobile = reservedBean.user_mobile {
            self.userNameLabel.text = mobile
        }
        
        if let isActive = reservedBean.status{
            if(isActive == "Active"){
                self.statusLabel.text = "Active"
                self.statusColorView.backgroundColor = UIColor.green
            }else{
                self.statusLabel.text = "Inactive"
                self.statusColorView.backgroundColor = UIColor.red
            }
        }
        
        if let membershipId = reservedBean.start_time {
            let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.black]
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.lightGray]

            let valueString = NSMutableAttributedString(string: membershipId, attributes: myAttribute )
            let myString = NSMutableAttributedString(string: "Starting at : ", attributes: myAttribute1 )
            myString.append(valueString)
            self.membershipIdLabel.attributedText = myString
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
