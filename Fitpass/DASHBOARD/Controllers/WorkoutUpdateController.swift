//
//  WorkoutUpdateController.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class WorkoutUpdateController: BaseViewController{
        
    @IBOutlet weak var workoutUpdateTableview: UITableView!
    @IBOutlet weak var workoutNameTxtField: UITextField!
    @IBOutlet weak var workoutCategoryButton: UIButton!
    @IBOutlet weak var workoutStatusButton: UIButton!
    @IBOutlet weak var workoutDescriptionButton: UITextField!

        var delegate : workoutDelegate?
        var workoutObj : Workouts?
        var keyLabelNameArray : NSArray = ["Workout Name*", "Workout Category*", "Workout Status*", "Workout Description*"]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage(named: "img_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: backBtn)
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = item1
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateWorkout))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Update Workout"
            self.workoutNameTxtField.text = workoutObj?.workout_name ?? ""
            self.workoutCategoryButton.setTitle(workoutObj?.workout_category_name ?? "", for: UIControlState.normal)
            self.workoutStatusButton.setTitle(workoutObj?.is_active?.stringValue ?? "", for: UIControlState.normal)
            self.workoutDescriptionButton.text = workoutObj?.workout_description ?? ""
        }
    
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    
        func updateWorkout() {
            self.dismissViewController()
            let workoutBean : Workouts = Workouts()
            
            workoutBean.is_active = NSNumber.init(value: Int((workoutStatusButton.titleLabel?.text)!)!)
            workoutBean.workout_category_name = workoutCategoryButton.titleLabel?.text!
            workoutBean.workout_name = workoutNameTxtField.text
            workoutBean.workout_description = workoutDescriptionButton.text
            
            self.delegate?.updateWorkoutToList(workoutBean: workoutBean)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
