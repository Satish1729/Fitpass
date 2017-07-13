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
    
    
    func updateReservedWorkoutDetails (reservedBean : ReservedWorkouts) {
        
        if let workoutname = reservedBean.workout_name {
            self.workoutNameLabel.text = workoutname
        }
        
        if let workoutdate = reservedBean.workout_date {
            self.workoutDateLabel.text = workoutdate
        }
        
        if let username = reservedBean.user_name {
            self.userNameLabel.text = username
        }
        
        if let membershipId = reservedBean.user_membership_id {
            let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)]
            let valueString = NSMutableAttributedString(string: membershipId, attributes: myAttribute )
            let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
            let myString = NSMutableAttributedString(string: "Membership Id - ", attributes: myAttribute1 )
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
