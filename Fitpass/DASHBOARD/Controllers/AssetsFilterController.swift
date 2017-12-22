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

