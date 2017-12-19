//
//  AssetsFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 29/06/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class AssetsFilterController: BaseViewController, UITextFieldDelegate, HalfModalPresentable {
        
        var delegate : assetDelegate?
        
        @IBOutlet weak var purchasedOnTxtField: UITextField!
        @IBOutlet weak var expiryDateTxtField: UITextField!
    
        var filterDataDict : NSMutableDictionary?
    
        @IBAction func cancelButtonClicked(_ sender: Any) {
            if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
                delegate.interactiveDismiss = false
            }
            dismiss(animated: true, completion: nil)
        }
        
        @IBAction func resetButtonClicked(_ sender: Any) {
            self.clearFilterValues()
        }
        
        @IBAction func searchButtonClicked(_ sender: Any) {
            
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
                return
            }
            
            dismiss(animated: true, completion: nil)
            let tempDict : NSMutableDictionary = ["purchase_date_from" : purchasedOnTxtField.text!, "purchase_date_to" : expiryDateTxtField.text!]
            
            delegate?.getDictionary(searchDict: tempDict)
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
    
        func clearFilterValues () {
            //        self.dismissViewController()
            self.purchasedOnTxtField.text = ""
            self.expiryDateTxtField.text = ""
            self.filterDataDict?.removeAllObjects()
            self.filterDataDict = nil
            dismiss(animated: true, completion: nil)
            
            delegate?.clearFilter()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Lead Filter"
            if(self.filterDataDict != nil){
                self.purchasedOnTxtField.text = self.filterDataDict?.object(forKey: "purchase_date_from") as? String
                self.expiryDateTxtField.text = self.filterDataDict?.object(forKey: "purchase_date_to") as? String;
            }
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if textField == purchasedOnTxtField {
                let datePicker = UIDatePicker()
                textField.inputView = datePicker
                datePicker.datePickerMode = .date
                datePicker.maximumDate = Date()
                datePicker.addTarget(self, action: #selector(datePickerStartDateChanged(sender:)), for: .valueChanged)
            }
            else if textField == expiryDateTxtField {
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                textField.inputView = datePicker
                datePicker.maximumDate = Date()
                datePicker.addTarget(self, action: #selector(datePickerEndDateChanged(sender:)), for: .valueChanged)
            }
        }
        
        func datePickerStartDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            //        formatter.dateStyle = .medium
            formatter.dateFormat = "dd-MMM-yyyy"
            self.purchasedOnTxtField.text = formatter.string(from: sender.date)
        }
        
        func datePickerEndDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            //        formatter.dateStyle = .medium
            formatter.dateFormat = "dd-MMM-yyyy"
            self.expiryDateTxtField.text = formatter.string(from: sender.date)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
}
/*
Splash screen missing - Fixed
Login - Background image missing - Fixed
Login - Password icon must be solid and same as android - -  required password images (15,30,45 sizes)
Login - Password eye to show the password is missing - Fixed
Forgot password - Design is different -  For a single input its not suggestible to navigate the user to new screen, if that is required will do the same way but its not native thing in iOS
Dashboard - Sales graph should be same as android-  Todo
Dashboard - Total leads and members gauge going out of screen - Refer screenshot.-  Fixed
Dashboard - Total members - Upcoming dues --- 0 should have left margin with text.-  Fixed
Side navigation - Increase width-  Fixed
Side navigation- Profile - Default profile pic should come as android-  Fixed
Side navigation - email id should not be bold-  Fixed
Side navigation - <studioname> arrow should also be there (refer android)-  Fixed
Side navigation -><studio name > click -> studio names should appear as popup just like android-  Fixed
Side navigation --> Sales report screen is missing-  Fixed
Side navigation -- > Payments should be moved under "Fitpass workouts"-  Fixed
Side navigation -- > Divider should not appear-  Fixed
Leads- Color of label is wrong. Use this  - Yellow - #fdc643, Red - #fd4343, Blue - #4381fd-  Fixed
Leads - Search - Search for Jn --> 2 records will appear --> Now search for Jn again without clearing previous result --> It will append to same result again.-  Fixed
Leads - Filter - Should be in bottom (If not feasible let me know) --  Not Feasible
Leads - Filter - Design is completely different than android.-  Todo
Leads - Filter - Apply some filter --> Then go to filter again. It should show previous selected values.-  Todo
Leads - Filter --> Filter by status is missing-  Added(partially working)
Leads - filter -> Date is not mandatory. User can see data based on Lead status as well.-  Fixed
Leads - Filter --> Don't select HOT by default. User may wants to see data of all type of status. Better follow android design and make it as radio button.-  Fixed
Leads - Download button missing-  ToDo(require related API)
Leads - Lead type "Member" icon has to be changed-  Please provide same image
Lead detail - Font size of email, contact number and address should be little bigger-  Fixed
Lead detail - All right side content should be bold-  Fixed
Lead detail - Last comment should be multiline and should come before remarks. Remarks should also be multiple line-  Fixed
Lead detail - Ordering of content has to be same as android-  Fixed
Members - Time slot should not be bold-  Fixed
Members - Expiry date color is wrong-  Todo
Member detail - Its old screen. Please revise the design-  Fixed
Asset detail -  Its old screen. Please revise the design-  Fixed
Asset detail - You need to show bill preview. On click it should open in full screen-  Todo
Staff - Date is going out of screen. Please remove text "Edit" and "Delete"-  Todo
Update/Add staff- Upload documents missing-  Todo
Workout - Workout category should be in second line-  Todo.
Workout - Date is going out of screen. Please remove text "Edit" and "Delete"- Date is looking good for me, please provide me latest android apk will change accordingly
Reserve Workout - Top right - Validate URC Number screen missing-  Todo
Add schedule - Workout days design should show the multiple selection-  Todo
Add schedule - End time is mandatory-  Todo

General
Mobile number (complete number not just icon) should be clickable and should open dialer to make call. Use alert box same as android-  Native feature not feasible to customise
Email (complete Email not just icon) should be clickable and should open Email application. Use alert box same as android-  Todo
Search is appending result in existing result set-  Fixed
Download button is missing in every screen-  Todo(Please provide API)
Filter designs are not revised anywhere.-  Working on
Filter should retain previous selected values if opened again-  Working on
Use color  Yellow - #fdc643, Red - #fd4343, Blue - #4381fd, green - #acf037-  Fixed
Mobile number is truncating in all the screens. Its most important information and must be accomodated in the screen anyhow.-  Valid numbers are not truncating (numbers with 10 digits as we are doing it in India I believe)
In every form show * in red color-  Todo
Most of the detail screen is still not revised.-  80% completed
*/
