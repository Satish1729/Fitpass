//
//  SalesReportFilterController.swift
//  Fitpass
//
//  Created by Quantela on 28/11/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown
import DLRadioButton

class SalesReportFilterController: BaseViewController, UITextFieldDelegate, HalfModalPresentable {
        
        var delegate : salesReportDelegate?
        var filterDataDict : NSMutableDictionary?
        
        @IBOutlet weak var paymentMonthTxtField: UITextField!
    
        @IBOutlet weak var paidButton: DLRadioButton!
        
        @IBOutlet weak var dueButton: DLRadioButton!
    
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
            
            //        self.dismissViewController()
            dismiss(animated: true, completion: nil)
            
            var strStatus = ""
            if let statusStr = self.paidButton.selected()?.titleLabel?.text{
                strStatus = statusStr
            }
            let tempDict : NSMutableDictionary = ["paid_date" : paymentMonthTxtField.text!, "status" : strStatus]
            
            delegate?.getFilterDictionary(searchDict: tempDict)
        }
        
        let dropDown = DropDown()
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        func clearFilterValues () {
            //        self.dismissViewController()
            self.paymentMonthTxtField.text = ""
            self.paidButton.isSelected = false
            self.dueButton.isSelected = false
            self.filterDataDict?.removeAllObjects()
            self.filterDataDict = nil
            dismiss(animated: true, completion: nil)
            
            delegate?.clearFilter()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if(self.filterDataDict != nil){
                self.paymentMonthTxtField.text = self.filterDataDict?.object(forKey: "paid_date") as? String
                if let statusStr:String = (self.filterDataDict?.object(forKey: "status") as? String){
                    switch (statusStr){
                    case "Paid" :             self.paidButton.isSelected = true
                    break;
                    case "Due" :            self.dueButton.isSelected = true
                    break;
                    default:
                        break;
                    }
                }
            }
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if textField == paymentMonthTxtField {
                let datePicker = UIDatePicker()
                textField.inputView = datePicker
                datePicker.datePickerMode = .date
                datePicker.maximumDate = Date()
                datePicker.addTarget(self, action: #selector(datePickerStartDateChanged(sender:)), for: .valueChanged)
            }
        }
        
        func datePickerStartDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            //        formatter.dateStyle = .medium
            formatter.dateFormat = "yyyy-MM"//"dd-MMM-yyyy"
            self.paymentMonthTxtField.text = formatter.string(from: sender.date)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
}
