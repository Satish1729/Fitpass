//
//  PaymentsFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 08/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class PaymentsFilterController: BaseViewController, UITextFieldDelegate {
    
    var delegate : paymentDelegate?
    
    @IBOutlet weak var paymentDateTxtField: UITextField!
    @IBOutlet weak var paymentMonthTxtField: UITextField!
    @IBOutlet weak var bankUtrNumberTextField: UITextField!
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        
        if bankUtrNumberTextField.text == "" {
            AlertView.showCustomAlertWithMessage(message: "Please enter bank UTR number" , yPos: 20, duration: NSInteger(2.0))
            return
        }
        else if paymentDateTxtField.text == "" {
            AlertView.showCustomAlertWithMessage(message: "Select payment date" , yPos: 20, duration: NSInteger(2.0))
            return
            
        }else if(paymentMonthTxtField.text == "") {
            AlertView.showCustomAlertWithMessage(message: "Select payment month", yPos: 20, duration: NSInteger(2.0))
            return
            
        }else if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return
        }
        self.dismissViewController()
        let tempDict : NSDictionary = ["paymentDate" : paymentDateTxtField.text!, "paymentMonth" : paymentMonthTxtField.text!, "bankUtrNumber" : bankUtrNumberTextField.text!]
        delegate?.getDictionary(searchDict: tempDict)
    }
    
    let dropDown = DropDown()
    
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
        
        
//        dropDown.anchorView = self.statusButton
//        dropDown.bottomOffset = CGPoint(x: 0, y: self.statusButton.frame.size.height)
//        dropDown.width = self.statusButton.frame.size.width
//        dropDown.dataSource = ["HOT", "DEAD", "COLD"]
//        dropDown.direction = .any
//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.statusButton.setTitle(item, for: UIControlState.normal)
//        }
//        
//        self.statusButton.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
    }
    
    func changeStatus() {
        self.dropDown.show()
    }
    
    func clearFilterValues () {
        self.dismissViewController()
        delegate?.clearFilter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Payments Filter"
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

