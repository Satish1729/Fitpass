//
//  WorkoutDetailCell.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class WorkoutDetailCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var workoutdaysLabel: UILabel!
    
    
    func updateWorkoutDetails (scheduleBean: WorkoutSchedulesObject) {
        
        if let name = scheduleBean.workout_schedule_id {
            self.idLabel.text = name
        }
        
        if let seats =  scheduleBean.number_of_seats{
            self.seatsLabel.text = seats
        }
        
        if let time = scheduleBean.start_time {
            self.timeLabel.text = time+" to "+scheduleBean.end_time!
        }
        
        if let days = scheduleBean.workout_days {
            self.workoutdaysLabel.text = days
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
