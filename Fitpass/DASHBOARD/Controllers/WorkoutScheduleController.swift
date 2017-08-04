//
//  WorkoutScheduleController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class WorkoutScheduleController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scheduleScrollView: UIScrollView!
    @IBOutlet weak var workoutNameButton: UIButton!
    @IBOutlet weak var numberofSeatsTxtField: UITextField!
    @IBOutlet weak var startTimeTxtField: UITextField!
    @IBOutlet weak var endTimeTxtField: UITextField!
    @IBOutlet weak var workoutDaysButton: UIButton!
    @IBOutlet weak var workoutScheduleStatusButton: UIButton!
    
    var workoutNamesArray : NSMutableArray = NSMutableArray()
    var workoutIdsDict : NSMutableDictionary = NSMutableDictionary()
    var selectedDay :String = ""

    let dropDown = DropDown()
    
    @IBAction func workoutNameButtonSelected(_ sender: Any) {
        
        if(workoutNamesArray.count > 0) {
            dropDown.anchorView = self.workoutNameButton
            dropDown.bottomOffset = CGPoint(x:0, y:self.workoutNameButton.frame.size.height)
            dropDown.width = self.workoutNameButton.frame.size.width
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.workoutNameButton.setTitle(item, for: UIControlState.normal)
            }
            dropDown.dataSource = self.workoutNamesArray as! [String]
            dropDown.show()
        }else{
            getWorkoutNamesList()
        }
    }
    @IBAction func workoutDaysButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.workoutDaysButton
        dropDown.topOffset = CGPoint(x:0, y:-self.workoutDaysButton.frame.size.height)
        dropDown.width = self.workoutDaysButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if(self.selectedDay == ""){
                self.selectedDay = item
            }else{
                if(self.selectedDay.contains(","+item)){
                    self.selectedDay = self.selectedDay.replacingOccurrences(of: ","+item, with: "")
                }else if(self.selectedDay.contains(item)){
                    self.selectedDay = self.selectedDay.replacingOccurrences(of: item, with: "")
                }
                else{
                    self.selectedDay = self.selectedDay+","+item
                }
            }
            self.workoutDaysButton.setTitle(self.selectedDay, for: UIControlState.normal)
        }
        dropDown.dataSource = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        dropDown.show()

    }
    @IBAction func scheduleStatusButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.workoutScheduleStatusButton
        dropDown.topOffset = CGPoint(x:0, y:-self.workoutScheduleStatusButton.frame.size.height)
        dropDown.width = self.workoutScheduleStatusButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.workoutScheduleStatusButton.setTitle(item, for: UIControlState.normal)
        }
        dropDown.dataSource = ["Yes", "No"]
        dropDown.show()

    }
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let partnerForm = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"PartnerRequestViewController") as! PartnerRequestViewController
        partnerForm.view.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        self.addChildViewController(partnerForm)
        self.view.addSubview(partnerForm.view)
        
        if(appDelegate.userBean?.auth_key == "" && appDelegate.userBean?.partner_id == ""){
            scheduleScrollView.isHidden = true
            partnerForm.view.isHidden = false
        }else{
            scheduleScrollView.isHidden = false
            partnerForm.view.isHidden = true
            
            dropDown.direction = .any
            
            self.workoutNameButton.layer.borderColor = UIColor.lightGray.cgColor
            self.workoutNameButton.layer.borderWidth = 1
            self.workoutNameButton.layer.cornerRadius = 5
            
            self.workoutDaysButton.layer.borderColor = UIColor.lightGray.cgColor
            self.workoutDaysButton.layer.borderWidth = 1
            self.workoutDaysButton.layer.cornerRadius = 5
            
            self.workoutScheduleStatusButton.layer.borderColor = UIColor.lightGray.cgColor
            self.workoutScheduleStatusButton.layer.borderWidth = 1
            self.workoutScheduleStatusButton.layer.cornerRadius = 5
            
            numberofSeatsTxtField.keyboardType = .numberPad
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addNewWorkoutSchedule))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            self.startTimeTxtField.delegate = self
            self.endTimeTxtField.delegate = self
        }
        
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == startTimeTxtField {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.datePickerMode = UIDatePickerMode.time
            datePicker.addTarget(self, action: #selector(datePickerStartDateChanged(sender:)), for: .valueChanged)
        }
        else if textField == endTimeTxtField {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = UIDatePickerMode.time
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(datePickerEndDateChanged(sender:)), for: .valueChanged)
        }
    }
    
    func datePickerStartDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "h:m a"
        self.startTimeTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerEndDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "h:m a"
        self.endTimeTxtField.text = formatter.string(from: sender.date)
    }

    func dismissViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func getWorkoutNamesList() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_WORKOUTS , userInfo: nil, type: "GET") { (data, response, error) in
            ProgressHUD.hideProgress()
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDic:NSDictionary? = jsonObject as? NSDictionary
                    if (responseDic != nil) {
                        print(responseDic!)
                        if(responseDic!.object(forKey:"code") as! NSNumber == 200){

                            let dataArray : NSArray = responseDic!.object(forKey: "data") as! NSArray
                            for workoutObj in (dataArray as? [[String:Any]])! {
                                self.workoutNamesArray.add(workoutObj["workout_name"] ?? "")
                                self.workoutIdsDict.setObject(workoutObj["workout_id"]!, forKey: workoutObj["workout_name"]! as! NSCopying)
                            }
                            self.dropDown.anchorView = self.workoutNameButton
                            self.dropDown.bottomOffset = CGPoint(x:0, y:self.workoutNameButton.frame.size.height)
                            self.dropDown.width = self.workoutNameButton.frame.size.width
                            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                                self.workoutNameButton.setTitle(item, for: UIControlState.normal)
                            }
                            self.dropDown.dataSource = self.workoutNamesArray as! [String]
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
    
    
    //MARK: Validations
    func isValidworkout() -> Bool {
        
        var isValidUser = false
        
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(self.workoutNameButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == "" || self.workoutNameButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == "Please Select"){
            AlertView.showCustomAlertWithMessage(message: "Please select workout name", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        if(self.numberofSeatsTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter number of seats", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        if(self.startTimeTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter start time", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        if(self.endTimeTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter end time", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
//        if((Utility().getTimeFromTimeInterval(interval: NSNumber(value : Int(startTimeTxtField.text!)!))) > (Utility().getTimeFromTimeInterval(interval: NSNumber(value : Int(endTimeTxtField.text!)!)))){
//            AlertView.showCustomAlertWithMessage(message: "Start time cannot be after the end time", yPos: 20, duration: NSInteger(2.0))
//            return isValidUser
//            
//        }
        if(startTimeTxtField.text! > endTimeTxtField.text!){
            AlertView.showCustomAlertWithMessage(message: "Start time cannot be after the end time", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
            
        }

        if(self.workoutDaysButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select days", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(self.workoutScheduleStatusButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select status", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        isValidUser = true
        return isValidUser
    }
    
    
    func addNewWorkoutSchedule() {
        
        if !isValidworkout() {
            //AlertView.showCustomAlertWithMessage(message: "Please enter required details", yPos: 20, duration: NSInteger(2.0))
            return
        }
        addSchedule()
    }

    func addSchedule() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        let paramDict : [String : Any] = ["number_of_seats" : self.numberofSeatsTxtField.text!, "start_time" : self.startTimeTxtField.text!, "end_time": self.endTimeTxtField.text!, "workout_days": self.workoutDaysButton.titleLabel!.text!, "workout_id":self.workoutIdsDict.object(forKey: self.workoutNameButton.titleLabel!.text!)!, "schedule_status":self.workoutScheduleStatusButton.titleLabel!.text!]
        
//        let parameterString : String = NSString.init(format: "%@?number_of_seats=%@&start_time=%@&end_time=%@&workout_days=%@&workout_id=%@schedule_status=%@",ServerConstants.URL_ADD_SCHEDULE, self.numberofSeatsTxtField.text!, self.startTimeTxtField.text!,self.endTimeTxtField.text!,self.workoutDaysButton.titleLabel!.text!, self.workoutIdsDict.object(forKey: self.workoutNameButton.titleLabel!.text!)! as! CVarArg,self.workoutScheduleStatusButton.titleLabel!.text!) as String
        
//        let urlString : String = ServerConstants.URL_ADD_SCHEDULE+parameterString
        NetworkManager.sharedInstance.getResponseForURLForm(url: ServerConstants.URL_ADD_SCHEDULE , userInfo: paramDict as NSDictionary, type: "POST") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.performSegue(withIdentifier: "scheduletodashboard", sender: self)
                    }
                }
            }
            else{
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
                }
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
