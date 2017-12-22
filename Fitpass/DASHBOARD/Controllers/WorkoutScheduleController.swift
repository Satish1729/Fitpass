//
//  WorkoutScheduleController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class WorkoutScheduleController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scheduleScrollView: UIScrollView!
    @IBOutlet weak var workoutNameButton: UIButton!
    @IBOutlet weak var numberofSeatsTxtField: UITextField!
    @IBOutlet weak var startTimeTxtField: UITextField!
    @IBOutlet weak var endTimeTxtField: UITextField!
    @IBOutlet weak var workoutDaysButton: UIButton!
    @IBOutlet weak var workoutScheduleStatusButton: UIButton!
    
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var seatsLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var workoutdaysLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var addWorkButton: UIButton!
    
    
    
    var workoutNamesArray : NSMutableArray = NSMutableArray()
    var workoutIdsDict : NSMutableDictionary = NSMutableDictionary()
    var selectedDay :String = ""
    var isFromWorkoutDetail:Bool = false
    var selectedWorkoutName:String = ""
    let dropDown = DropDown()
    
    var delegate : workoutScheduleDelegate?
    var scheduleDict : NSDictionary = NSDictionary()

    @IBAction func workoutNameButtonSelected(_ sender: Any) {
        
        if(isFromWorkoutDetail)
        {
            return
        }
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
        
        if((appDelegate.userBean?.auth_key == "" || appDelegate.userBean?.auth_key == nil) || (appDelegate.userBean?.partner_id == "" || appDelegate.userBean?.partner_id == nil)){
//            scheduleScrollView.isHidden = true
            partnerForm.view.isHidden = false
        }else{
//            scheduleScrollView.isHidden = false
            partnerForm.view.isHidden = true
            
            if(isFromWorkoutDetail)
            {
                self.workoutNameButton.setTitle(self.selectedWorkoutName, for: UIControlState.normal)
            }

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
            
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addNewWorkoutSchedule))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            self.addWorkButton.addTarget(self, action: #selector(addNewWorkoutSchedule), for: .touchUpInside)
            self.startTimeTxtField.delegate = self
            self.endTimeTxtField.delegate = self
        }
        self.workoutLabel.attributedText = self.setRedColorForStar(str: "Select Workout")
        self.seatsLabel.attributedText = self.setRedColorForStar(str: "Number of Seats")
        self.startTimeLabel.attributedText = self.setRedColorForStar(str: "Start Time")
        self.endTimeLabel.attributedText = self.setRedColorForStar(str: "End Time")
        self.workoutdaysLabel.attributedText = self.setRedColorForStar(str: "Workout Days")
        self.statusLabel.attributedText = self.setRedColorForStar(str: "Workout Schedule Status")
    }
    
//    func setRedColorForStar(str:String) -> NSMutableAttributedString{
//        let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.red]
//        let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.black]
//        let valueString = NSMutableAttributedString(string:" *", attributes: myAttribute )
//        let myString = NSMutableAttributedString(string: str, attributes: myAttribute1 )
//        myString.append(valueString)
//
//        return myString
//    }
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
        formatter.dateFormat = "H:M"
        self.startTimeTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerEndDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "H:M"
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
        
        if((Utility().getstartendTime(dateStr: startTimeTxtField.text! as NSString)) > (Utility().getstartendTime(dateStr: endTimeTxtField.text! as NSString))){
            AlertView.showCustomAlertWithMessage(message: "Start time cannot be after the end time", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }

        if(self.workoutDaysButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == "" || self.workoutDaysButton.titleLabel?.text == nil){
            AlertView.showCustomAlertWithMessage(message: "Please select days", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(self.workoutScheduleStatusButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == "" || self.workoutScheduleStatusButton.titleLabel?.text == nil){
            AlertView.showCustomAlertWithMessage(message: "Please select status", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        isValidUser = true
        return isValidUser
    }
    
    func getWorkoutdaysNumbers(textString : String) -> String{
        var numberString : String = textString
        
        if numberString.contains("Monday") {
            numberString = numberString.replacingOccurrences(of: "Monday", with: "1")
        }
        if numberString.contains("Tuesday") {
            numberString = numberString.replacingOccurrences(of: "Tuesday", with: "2")
        }
        if numberString.contains("Wednesday") {
            numberString = numberString.replacingOccurrences(of: "Wednesday", with: "3")
        }
        if numberString.contains("Thursday") {
            numberString = numberString.replacingOccurrences(of: "Thursday", with: "4")
        }
        if numberString.contains("Friday") {
            numberString = numberString.replacingOccurrences(of: "Friday", with: "5")
        }
        if numberString.contains("Saturday") {
            numberString = numberString.replacingOccurrences(of: "Saturday", with: "6")
        }
        if numberString.contains("Sunday") {
            numberString = numberString.replacingOccurrences(of: "Sunday", with: "7")
        }
        
        return numberString
    }
    func addNewWorkoutSchedule() {
        
        if !isValidworkout() {
            return
        }
        addSchedule()
    }

    func addSchedule() {
        
        numberofSeatsTxtField.resignFirstResponder()
        startTimeTxtField.resignFirstResponder()
        endTimeTxtField.resignFirstResponder()

        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        let paramDict : Parameters = ["number_of_seats":self.numberofSeatsTxtField.text!, "start_time" : self.startTimeTxtField.text!, "end_time": self.endTimeTxtField.text!, "workout_days": self.getWorkoutdaysNumbers(textString: self.workoutDaysButton.titleLabel!.text!), "workout_id":self.workoutIdsDict.object(forKey: self.workoutNameButton.titleLabel!.text!)!, "schedule_status":self.workoutScheduleStatusButton.titleLabel!.text!]
        

        let urlRequest = URLRequest(url: URL(string: ServerConstants.URL_ADD_SCHEDULE)!)
        let urlString = urlRequest.url?.absoluteString

        let headersDict: HTTPHeaders = [
            "X-APPKEY":(appDelegate.userBean?.auth_key)!,
            "X-partner-id":(appDelegate.userBean?.partner_id)!,
            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"
        ]
            
        Alamofire.request(urlString!, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: headersDict).responseJSON { (response) in
            print(response.result)
            let responseDic =  response.result.value as! NSDictionary
            self.scheduleDict = responseDic 
            if(responseDic.object(forKey:"code") as! NSNumber == 200){
//                showAlertWithTitle(title: "", message: responseDic.object(forKey: "message") as! String, forTarget: self, buttonOK: "", buttonCancel:"OK", alertOK: { (String) in
//                }, alertCancel: { (Void) in
//                    //self.performSegue(withIdentifier: "scheduletodashboard", sender: self)
                    if(self.isFromWorkoutDetail){
                        self.dismissViewController()
                        let tempDict = responseDic.object(forKey: "data") as! NSDictionary
                        let workoutScheduleObj : WorkoutSchedulesObject = WorkoutSchedulesObject()
                        workoutScheduleObj.workout_schedule_id = tempDict["workout_schedule_id"] as? String
                        workoutScheduleObj.number_of_seats = tempDict["number_of_seats"] as? String
                        workoutScheduleObj.start_time = tempDict["start_time"] as? String
                        workoutScheduleObj.end_time = tempDict["end_time"] as? String
                        workoutScheduleObj.workout_days = tempDict["workout_days"] as? String
                        workoutScheduleObj.created_by = tempDict["created_by"] as? String
                        workoutScheduleObj.workout_id = tempDict["workout_id"] as? String
                        workoutScheduleObj.create_time = tempDict["create_time"] as? String

                        self.delegate?.addNewScheduleToList(scheduleBean: workoutScheduleObj)
                    }else{
                        self.moveToDashBoard()
                    }
//                })
            }
            else{
                AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
            }

        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
