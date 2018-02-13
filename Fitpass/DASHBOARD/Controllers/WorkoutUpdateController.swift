//
//  WorkoutUpdateController.swift
//  Fitpass
//
//  Created by Satish Regeti on 11/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class WorkoutUpdateController: BaseViewController{
        
    @IBOutlet weak var workoutUpdateTableview: UITableView!
    @IBOutlet weak var workoutNameTxtField: UITextField!
    @IBOutlet weak var workoutCategoryButton: UIButton!
    @IBOutlet weak var workoutStatusButton: UIButton!
    @IBOutlet weak var workoutDescriptionButton: UITextField!

    @IBOutlet weak var updateWorkoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    let dropDown = DropDown()
    
    var workoutCategoriesArray : NSMutableArray = NSMutableArray()
    var workoutIdsDict : NSMutableDictionary = NSMutableDictionary()
  
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
            
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateWorkout))
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
            self.updateWorkoutButton.addTarget(self, action: #selector(updateWorkout), for: .touchUpInside)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Update Workout"
            self.workoutNameTxtField.text = workoutObj?.workout_name ?? ""
            self.workoutCategoryButton.setTitle(workoutObj?.workout_category_name ?? "", for: UIControlState.normal)
            self.workoutStatusButton.setTitle(workoutObj?.is_active ?? "", for: UIControlState.normal)
            self.workoutDescriptionButton.text = workoutObj?.workout_description ?? ""
        }
    
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
    
        func updateWorkout() {
            self.dismissViewController()
            let workoutBean : Workouts = Workouts()
            
            workoutBean.is_active = workoutStatusButton.titleLabel?.text!
            workoutBean.workout_category_name = workoutCategoryButton.titleLabel?.text!
            workoutBean.workout_name = workoutNameTxtField.text
            workoutBean.workout_description = workoutDescriptionButton.text
            if(self.workoutIdsDict.count > 0){
                workoutBean.workout_category_id = (self.workoutIdsDict.object(forKey: self.workoutCategoryButton.titleLabel!.text!) as! String)
            }
            else{
                workoutBean.workout_category_id = workoutObj?.workout_category_id
            }
            workoutBean.workout_id = workoutObj?.workout_id
            workoutBean.created_by = workoutObj?.created_by
            workoutBean.create_time = workoutObj?.create_time
            
            self.delegate?.updateWorkoutToList(workoutBean: workoutBean)
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
                    if(responseDic?.object(forKey: "code") as! NSNumber  == 401){
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                        self.moveToLoginScreen()
                    }
                    else if(responseDic?.object(forKey: "code") as! NSNumber  == 200){

//                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        
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
