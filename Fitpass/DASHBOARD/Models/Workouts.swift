//
//  Workouts.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Workouts: NSObject {
    
    var create_time : String? = ""
    var created_by : String? = ""
    var is_active : NSNumber?
    var update_time : String? = ""
    var updated_by : String? = ""
    var workout_category_id : String?
    var workout_category_name : String?
    var workout_description : String? = ""
    var workout_id : NSNumber?
    var workout_image : String?
    var workout_name : String? = ""
    var workout_schedules : [WorkoutSchedulesObject] = []
    
    
    func updateWorkouts(responseDict : NSDictionary?) -> NSMutableArray {
        
        let dataArray : NSArray = responseDict!.object(forKey: "data") as! NSArray
        
        let tempArray : NSMutableArray = NSMutableArray()
        
        for workoutObj in (dataArray as? [[String:Any]])! {
            
            let workoutBean : Workouts = Workouts()
            
            workoutBean.create_time = workoutObj["create_time"] as? String
            workoutBean.created_by = workoutObj["created_by"] as? String
            workoutBean.is_active = workoutObj["is_active"] as? NSNumber
            workoutBean.update_time = workoutObj["update_time"] as? String
            workoutBean.updated_by = workoutObj["updated_by"] as? String
            workoutBean.workout_category_id = workoutObj["workout_category_id"] as? String
            workoutBean.workout_category_name = workoutObj["workout_category_name"] as? String
            workoutBean.workout_description = workoutObj["workout_description"] as? String
            workoutBean.workout_id = workoutObj["workout_id"] as? NSNumber
            workoutBean.workout_image = workoutObj["workout_image"] as? String
            workoutBean.workout_name = workoutObj["workout_name"] as? String
            
            let workoutSchedulesArray = workoutObj["workout_schedules"] as! NSArray
            
            
            for studioObj in (workoutSchedulesArray as? [[String:Any]])! {
                
                let workoutScheduleBean : WorkoutSchedulesObject = WorkoutSchedulesObject()
                
                workoutScheduleBean.create_time = studioObj["create_time"] as? String
                workoutScheduleBean.created_by = studioObj["created_by"] as? String
                workoutScheduleBean.end_time = studioObj["end_time"] as? String
                workoutScheduleBean.number_of_seats = studioObj["number_of_seats"] as? NSNumber
                workoutScheduleBean.schedule_status = studioObj["schedule_status"] as? String
                workoutScheduleBean.start_time = studioObj["start_time"] as? String
                workoutScheduleBean.update_time = studioObj["update_time"] as? String
                workoutScheduleBean.updated_by = studioObj["updated_by"] as? String
                workoutScheduleBean.workout_days = studioObj["workout_days"] as? String
                workoutScheduleBean.workout_id = studioObj["workout_id"] as? NSNumber
                workoutScheduleBean.workout_schedule_id = studioObj["workout_schedule_id"] as? NSNumber
                
                workoutBean.workout_schedules.append(workoutScheduleBean)
            }

            tempArray.add(workoutBean)
        }
        return tempArray
    }
}


class WorkoutSchedulesObject: NSObject {
    var create_time : String? = ""
    var created_by : String? = ""
    var end_time : String? = ""
    var number_of_seats : NSNumber?
    var schedule_status : String? = ""
    var start_time : String? = ""
    var update_time : String? = ""
    var updated_by : String? = ""
    var workout_days : String? = ""
    var workout_id : NSNumber?
    var workout_schedule_id : NSNumber?
}


