//
//  WorkoutAddController.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class WorkoutAddController: BaseViewController {
        
    @IBOutlet weak var workoutNameTxtField: UITextField!
    @IBOutlet weak var workoutCategoryButton: UIButton!
    @IBOutlet weak var workoutStatusButton: UIButton!
    @IBOutlet weak var workoutDescriptionButton: UITextField!

    @IBAction func categoryButtonSelected(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = self.workoutCategoryButton
        dropDown.backgroundColor = UIColor.darkGray
        dropDown.dataSource = ["Satish", "yoga", "swimming"]
        dropDown.direction = .any
        dropDown.width = self.workoutCategoryButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.workoutCategoryButton.setTitle(item, for: UIControlState.normal)
        }
    }
    
    @IBAction func statusButtonSelected(_ sender: Any) {
        
    }
    
    var delegate : workoutDelegate?
        
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
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addNewWorkout))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Add Workout"
            self.workoutNameTxtField.text = ""
            self.workoutCategoryButton.setTitle("", for: UIControlState.normal)
            self.workoutStatusButton.setTitle("", for: UIControlState.normal)
            self.workoutDescriptionButton.text = ""
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    
        //MARK: Validations
        func isValidworkout() -> Bool {
            
            var isValidUser = false
            
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            }
            
            if(self.workoutNameTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
                AlertView.showCustomAlertWithMessage(message: "Please enter workout name", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
            
            
            if(self.workoutCategoryButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
                AlertView.showCustomAlertWithMessage(message: "Please enter workout category", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
            
            if(self.workoutStatusButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
                AlertView.showCustomAlertWithMessage(message: "Please enter Contact No.", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
            
            if(self.workoutDescriptionButton.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
                AlertView.showCustomAlertWithMessage(message: "Please enter workout description", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
            
            isValidUser = true
            return isValidUser
        }
        
        
        func addNewWorkout() {
            
            if !isValidworkout() {
                AlertView.showCustomAlertWithMessage(message: "Please enter required details", yPos: 20, duration: NSInteger(2.0))
                return
            }
            self.dismissViewController()
            let workoutBean : Workouts = Workouts()
            
            self.delegate?.addNewWorkoutToList(workoutBean: workoutBean)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
