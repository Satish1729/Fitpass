//
//  WorkoutCell.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {

    
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var workoutCategoryIdLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var ccreateTimeLabel: UILabel!
    
    func updateWorkoutDetails (workoutBean : Workouts) {
        
        if let name = workoutBean.workout_name {
            self.workoutNameLabel.text = name
        }

        if let categoryId = workoutBean.workout_category_id {
            self.workoutCategoryIdLabel.text = categoryId.stringValue
        }
        
        if let createdBy = workoutBean.created_by {
            self.createdByLabel.text = createdBy
        }
        
        if let createdTime = workoutBean.create_time {
            self.ccreateTimeLabel.text = createdTime
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
