//
//  WorkoutSchedules.swift
//  Fitpass
//
//  Created by SatishMac on 13/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class WorkoutSchedules: NSObject {
    
    var schedule_status : String? = ""
    var workout_id : String? = ""
    var workout_schedule_id : String? = ""
    var start_time : String? = ""
    var end_time : String? = ""
    var number_of_seats : String? = ""
    var workout_days : String? = ""
    var create_time : String? = ""
    var update_time : String? = ""
    var created_by : String? = ""
    var updated_by : String? = ""
    
    func updateWorkoutSchedule(dataArray : NSArray?) -> NSMutableArray {
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for workoutScheduleObj in (dataArray as? [[String:Any]])! {
            
            let workoutScheduleBean = WorkoutSchedules()
            
            workoutScheduleBean.workout_schedule_id = workoutScheduleObj["workout_schedule_id"] as? String
            workoutScheduleBean.number_of_seats = workoutScheduleObj["number_of_seats"] as? String
            workoutScheduleBean.start_time = workoutScheduleObj["start_time"] as? String
            workoutScheduleBean.end_time = workoutScheduleObj["end_time"] as? String
            workoutScheduleBean.workout_days = workoutScheduleObj["workout_days"] as? String
            
            tempArray.add(workoutScheduleBean)
        }
        return tempArray
    }
}
