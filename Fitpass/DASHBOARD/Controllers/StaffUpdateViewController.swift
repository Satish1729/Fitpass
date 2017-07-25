//
//  StaffUpdateViewController.swift
//  Fitpass
//
//  Created by Satish Regeti on 25/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class StaffUpdateViewController: BaseViewController {
    
    
    var delegate : staffDelegate?
    var staffObj : Staffs?
    
    @IBOutlet weak var addScrollView: UIScrollView!
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var roleButton: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var contactNumberTxtField: UITextField!
    @IBOutlet weak var dobTxtField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var joiningDateTxtField: UITextField!
    @IBOutlet weak var salaryTxtField: UITextField!
    @IBOutlet weak var salaryDateButton: UIButton!
    
    var rolesArray : NSMutableArray = NSMutableArray()
    var roleIdsDict : NSMutableDictionary = NSMutableDictionary()
    
    let dropDown = DropDown()

    @IBAction func roleButtonSelected(_ sender: Any) {
        
        if(rolesArray.count > 0) {
            dropDown.anchorView = self.roleButton
            dropDown.bottomOffset = CGPoint(x:0, y:self.roleButton.frame.size.height)
            dropDown.width = self.roleButton.frame.size.width
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.roleButton.setTitle(item, for: UIControlState.normal)
            }
            dropDown.dataSource = self.rolesArray as! [String]
            dropDown.show()
        }else{
            getRolesList()
        }
    }
    @IBAction func genderButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.genderButton
        dropDown.topOffset = CGPoint(x:0, y:-self.genderButton.frame.size.height)
        dropDown.width = self.genderButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderButton.setTitle(item, for: UIControlState.normal)
        }
        dropDown.dataSource = ["Male", "Female"]
        dropDown.show()
    }
    @IBAction func salaryDateButtonSelected(_ sender: Any) {
        dropDown.anchorView = self.salaryDateButton
        dropDown.topOffset = CGPoint(x:0, y:-self.salaryDateButton.frame.size.height)
        dropDown.width = self.salaryDateButton.frame.size.width
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.salaryDateButton.setTitle(item, for: UIControlState.normal)
        }
        dropDown.dataSource = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25", "26","27","28"]
        dropDown.show()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "img_back"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = item1
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateStaff))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        setButtonsCornerRadius()
        
        self.nameTxtField.keyboardType = .namePhonePad
        self.emailTxtField.keyboardType = .emailAddress
        self.contactNumberTxtField.keyboardType = .numberPad
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        self.dobTxtField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerDOBChanged(sender:)), for: .valueChanged)
        
        self.addressTxtField.keyboardType = .namePhonePad
        
        let datePicker1 = UIDatePicker()
        datePicker1.datePickerMode = .date
        datePicker1.maximumDate = Date()
        self.joiningDateTxtField.inputView = datePicker1
        datePicker1.addTarget(self, action: #selector(datePickerJoiningDateChanged(sender:)), for: .valueChanged)
        
        salaryTxtField.keyboardType = .numberPad
    }
    
    func setButtonsCornerRadius(){
        self.roleButton.layer.borderColor = UIColor.lightGray.cgColor
        self.roleButton.layer.borderWidth = 1
        self.roleButton.layer.cornerRadius = 5
        
        self.genderButton.layer.borderColor = UIColor.lightGray.cgColor
        self.genderButton.layer.borderWidth = 1
        self.genderButton.layer.cornerRadius = 5
        
        self.salaryDateButton.layer.borderColor = UIColor.lightGray.cgColor
        self.salaryDateButton.layer.borderWidth = 1
        self.salaryDateButton.layer.cornerRadius = 5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Update Staff"
    }
    
    func dismissViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews()
    {
        self.addScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
    }
    

    func datePickerDOBChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dobTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerJoiningDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.joiningDateTxtField.text = formatter.string(from: sender.date)
    }
    
    func updateStaff() {
        
        if !isValidStaff() {
            return
        }
        self.dismissViewController()

        let staffBean : Staffs = Staffs()
        
        staffBean.name = nameTxtField.text!
        staffBean.role = roleButton.titleLabel!.text!
        staffBean.email = emailTxtField.text!
        let myInteger = contactNumberTxtField.text!
        staffBean.contact_number = NSNumber(value : Int(myInteger)!)
        staffBean.dob = dobTxtField.text!
        staffBean.gender = genderButton.titleLabel?.text!
        staffBean.address = addressTxtField.text!
        staffBean.joining_date = joiningDateTxtField.text!
        staffBean.salary = salaryTxtField.text!
        staffBean.salary_date = NSNumber(value: Int((salaryDateButton.titleLabel?.text)!)!)
        
        staffBean.id = staffObj?.id
        staffBean.is_active = staffObj?.is_active
        staffBean.is_deleted = staffObj?.is_deleted
        staffBean.created_at = staffObj?.created_at
        staffBean.updated_at = staffObj?.updated_at
        staffBean.joining_documents = staffObj?.joining_documents
        staffBean.remarks = staffObj?.remarks
        
        self.delegate?.updateStaffToList(staffBean: staffBean)
    }
    
    //MARK: Validations
    func isValidStaff() -> Bool {
        
        var isValidUser = false
        
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
        }
        
        if(nameTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter name", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(roleButton.titleLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select role", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(emailTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter email", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(contactNumberTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter Contact No.", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(dobTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter date of birth", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(genderButton.titleLabel!.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select gender", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(addressTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter address", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(joiningDateTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter joining date", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(salaryTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter salary", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(salaryDateButton.titleLabel!.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please select salary date", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        isValidUser = true
        return isValidUser
    }

    func getRolesList() {
        
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
                    let dataArray : NSArray = responseDic!.object(forKey: "data") as! NSArray
                    for roleObj in (dataArray as? [[String:Any]])! {
                        self.rolesArray.add(roleObj["workout_name"] ?? "")
                        self.roleIdsDict.setObject(roleObj["workout_id"]!, forKey: roleObj["workout_name"]! as! NSCopying)
                    }
                    self.dropDown.anchorView = self.roleButton
                    self.dropDown.bottomOffset = CGPoint(x:0, y:self.roleButton.frame.size.height)
                    self.dropDown.width = self.roleButton.frame.size.width
                    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.roleButton.setTitle(item, for: UIControlState.normal)
                    }
                    self.dropDown.dataSource = self.rolesArray as! [String]
                    self.dropDown.show()
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
