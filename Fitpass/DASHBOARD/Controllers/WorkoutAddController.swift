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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addWorkoutButton: UIButton!
    
    let dropDown = DropDown()
    var workoutCategoriesArray : NSMutableArray = NSMutableArray()
    var workoutIdsDict : NSMutableDictionary = NSMutableDictionary()

    var delegate : workoutDelegate?
    @IBAction func categoryButtonSelected(_ sender: Any) {
        
        if(workoutCategoriesArray.count>0){
            dropDown.anchorView = self.workoutCategoryButton
            dropDown.bottomOffset = CGPoint(x:0, y:self.workoutCategoryButton.frame.size.height)
            dropDown.width = self.workoutCategoryButton.frame.size.width
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.workoutCategoryButton.setTitle(item, for: UIControlState.normal)
            }
            dropDown.dataSource = self.workoutCategoriesArray as! [String]
            dropDown.show()
        }else{
            getWorkoutCategoriesList()
        }
    }
    
    @IBAction func statusButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.workoutStatusButton
        dropDown.bottomOffset = CGPoint(x:0, y:self.workoutStatusButton.frame.size.height)
        dropDown.width = self.workoutStatusButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.workoutStatusButton.setTitle(item, for: UIControlState.normal)
        }
        dropDown.dataSource = ["Yes", "No"]
        dropDown.show()
    }
    
    
//        var keyLabelNameArray : NSArray = ["Workout Name*", "Workout Category*", "Workout Status*", "Workout Description*"]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage(named: "img_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: backBtn)
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = item1
            
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addNewWorkout))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            self.workoutCategoryButton.layer.borderColor = UIColor.lightGray.cgColor
            self.workoutCategoryButton.layer.borderWidth = 1
            self.workoutCategoryButton.layer.cornerRadius = 5
            
            self.workoutStatusButton.layer.borderColor = UIColor.lightGray.cgColor
            self.workoutStatusButton.layer.borderWidth = 1
            self.workoutStatusButton.layer.cornerRadius = 5

            dropDown.direction = .any
            
            self.nameLabel.attributedText = self.setRedColorForStar(str: "Workout Name")
            self.categoryLabel.attributedText = self.setRedColorForStar(str: "Workout Category")
            self.statusLabel.attributedText = self.setRedColorForStar(str: "Workout Status")
            self.descriptionLabel.attributedText = self.setRedColorForStar(str: "Workout Description")
            self.addWorkoutButton.addTarget(self, action: #selector(addNewWorkout), for: .touchUpInside)
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
                return isValidUser
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
            workoutBean.workout_category_name = self.workoutCategoryButton.titleLabel?.text!
            workoutBean.workout_description = self.workoutDescriptionButton.text!
            workoutBean.is_active = self.workoutStatusButton.titleLabel?.text!
            workoutBean.workout_name = self.workoutNameTxtField.text!
            workoutBean.workout_category_id = (self.workoutIdsDict.object(forKey: self.workoutCategoryButton.titleLabel!.text!) as! String)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let newDate = dateFormatter.string(from: Date())

            workoutBean.create_time = newDate
            self.delegate?.addNewWorkoutToList(workoutBean: workoutBean)
//            let paramDict : [String : Any] = ["workout_category_id" : workoutBean.workout_category_id!, "workout_category_name" : workoutBean.workout_name!, "workout_description": workoutBean.workout_description!, "workout_status": workoutBean.is_active!]

        }
    
    func getWorkoutCategoriesList() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_WORKOUTS_CATEGORY , userInfo: nil, type: "GET") { (data, response, error) in
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        
                        let dataArray : NSArray = responseDic!.object(forKey: "data") as! NSArray
                        for workoutObj in (dataArray as? [[String:Any]])! {
                            self.workoutCategoriesArray.add(workoutObj["workout_category_name"] ?? "")
                            self.workoutIdsDict.setObject(workoutObj["workout_category_id"]!, forKey: workoutObj["workout_category_name"]! as! NSCopying)
                        }
                        self.dropDown.anchorView = self.workoutCategoryButton
                        self.dropDown.bottomOffset = CGPoint(x:0, y:self.workoutCategoryButton.frame.size.height)
                        self.dropDown.width = self.workoutCategoryButton.frame.size.width
                        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            self.workoutCategoryButton.setTitle(item, for: UIControlState.normal)
                        }
                        self.dropDown.dataSource = self.workoutCategoriesArray as! [String]
                        self.dropDown.show()
                    }else{
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
                else{
                    AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                    print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
