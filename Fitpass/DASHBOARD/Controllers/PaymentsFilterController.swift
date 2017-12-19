//
//  PaymentsFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 08/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class PaymentsFilterController: BaseViewController, UITextFieldDelegate, HalfModalPresentable {
    
    var delegate : paymentDelegate?
    var filterDataDict : NSMutableDictionary?

    @IBOutlet weak var paymentDateTxtField: UITextField!
    @IBOutlet weak var paymentMonthTxtField: UITextField!
    @IBOutlet weak var bankUtrNumberTextField: UITextField!
    
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
        
        let tempDict : NSMutableDictionary = ["paymentDate" : paymentDateTxtField.text!, "paymentMonth" : paymentMonthTxtField.text!, "bankUtrNumber" : bankUtrNumberTextField.text!]
        delegate?.getFilterDictionary(searchDict: tempDict)
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearFilterValues))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func clearFilterValues () {
        self.bankUtrNumberTextField.text = ""
        self.paymentDateTxtField.text = ""
        self.paymentMonthTxtField.text = ""
        self.filterDataDict?.removeAllObjects()
        self.filterDataDict = nil
        dismiss(animated: true, completion: nil)
        delegate?.clearFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.filterDataDict != nil){
            self.bankUtrNumberTextField.text = self.filterDataDict?.object(forKey: "bankUtrNumber") as? String
            self.paymentDateTxtField.text = self.filterDataDict?.object(forKey: "paymentDate") as? String
            self.paymentMonthTxtField.text = self.filterDataDict?.object(forKey: "paymentMonth") as? String
        }
    }
    
    func dismissViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == paymentDateTxtField {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(datePickerPaymentDateChanged(sender:)), for: .valueChanged)
        }
        else if textField == paymentMonthTxtField {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            textField.inputView = datePicker
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(datePickerPaymentMonthChanged(sender:)), for: .valueChanged)
        }
    }
    
    func datePickerPaymentDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        self.paymentDateTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerPaymentMonthChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        self.paymentMonthTxtField.text = formatter.string(from: sender.date)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

