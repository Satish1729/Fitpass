//
//  MembersFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class MembersFilterController: BaseViewController{
/*, UITextFieldDelegate {
        
        var delegate : memberDelegate?
        
        @IBOutlet weak var startDateTxtField: UITextField!
        @IBOutlet weak var endDateTxtField: UITextField!
        @IBOutlet weak var subscriptionPlanButton: UIButton!
        
        @IBAction func searchButtonClicked(_ sender: Any) {
            self.dismissViewController()
            
            let tempDict : NSDictionary = ["startdate" : startDateTxtField.text!, "enddate" : endDateTxtField.text!, "status" : subscriptionPlanButton.titleLabel?.text! ?? ""]
            delegate?.getFilterDictionary(searchDict: tempDict)
        }
        
        let dropDown = DropDown()
        
  */      override func viewDidLoad() {
            super.viewDidLoad()
  /*          self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearFilterValues))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            
            dropDown.anchorView = self.subscriptionPlanButton
            dropDown.dataSource = [""]
            dropDown.direction = .any
            dropDown.width = 280
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.subscriptionPlanButton.setTitle(item, for: UIControlState.normal)
            }
            
            self.subscriptionPlanButton.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
      */  }
        
     /*   func changeStatus() {
            self.dropDown.show()
        }
        
        func clearFilterValues () {
            self.dismissViewController()
            delegate?.clearFilter()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Member Filter"
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if textField == startDateTxtField {
                let datePicker = UIDatePicker()
                textField.inputView = datePicker
                datePicker.datePickerMode = .date
                datePicker.addTarget(self, action: #selector(datePickerStartDateChanged(sender:)), for: .valueChanged)
            }
            else if textField == endDateTxtField {
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                textField.inputView = datePicker
                datePicker.addTarget(self, action: #selector(datePickerEndDateChanged(sender:)), for: .valueChanged)
            }
        }
        
        func datePickerStartDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.startDateTxtField.text = formatter.string(from: sender.date)
        }
        
        func datePickerEndDateChanged(sender: UIDatePicker) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.endDateTxtField.text = formatter.string(from: sender.date)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            
        }
   */     
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
}
