//
//  AssetsFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 29/06/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class AssetsFilterController: BaseViewController, UITextFieldDelegate {
        
        var delegate : assetDelegate?
        
        @IBOutlet weak var purchasedOnTxtField: UITextField!
        @IBOutlet weak var expiryDateTxtField: UITextField!
    
        @IBAction func searchButtonClicked(_ sender: Any) {
            self.dismissViewController()
            
            let tempDict : NSDictionary = ["purchase_date_from" : purchasedOnTxtField.text!, "purchase_date_to" : expiryDateTxtField.text!]
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
            
            
//            dropDown.anchorView = self.statusButton
//            dropDown.dataSource = ["HOT", "DEAD", "COLD"]
//            dropDown.direction = .any
//            dropDown.width = 280
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                self.statusButton.setTitle(item, for: UIControlState.normal)
//            }
            
//            self.statusButton.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
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
            self.navigationItem.title = "Asset Filter"
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if textField == purchasedOnTxtField {
                let datePicker = UIDatePicker()
                textField.inputView = datePicker
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(datePickerPurchasedOnDateChanged(sender:)), for: .valueChanged)
            }
            else if textField == expiryDateTxtField {
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                textField.inputView = datePicker
                datePicker.addTarget(self, action: #selector(datePickerExpiryDateChanged(sender:)), for: .valueChanged)
            }
        }
        
        func datePickerPurchasedOnDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.purchasedOnTxtField.text = formatter.string(from: sender.date)
        }
        
        func datePickerExpiryDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.expiryDateTxtField.text = formatter.string(from: sender.date)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
}
