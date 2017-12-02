//
//  LeadsFilterViewController.swift
//  Fitpass
//
//  Created by SatishMac on 28/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown
import DLRadioButton

class LeadsFilterViewController: BaseViewController, UITextFieldDelegate, HalfModalPresentable {

    var delegate : leadDelegate?
    
    @IBOutlet weak var startDateTxtField: UITextField!
    @IBOutlet weak var endDateTxtField: UITextField!

    @IBOutlet weak var hotButton: DLRadioButton!
    
    @IBOutlet weak var warmButton: DLRadioButton!
    
    @IBOutlet weak var coldButton: DLRadioButton!
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {

        if startDateTxtField.text == "" {
            AlertView.showCustomAlertWithMessage(message: "Select start date" , yPos: 20, duration: NSInteger(2.0))
            return
            
        }else if(endDateTxtField.text == "") {
            AlertView.showCustomAlertWithMessage(message: "Select end date", yPos: 20, duration: NSInteger(2.0))
            return
            
        }
        
        else if((Utility().getTimeFromString(dateStr: startDateTxtField.text! as NSString)) > (Utility().getTimeFromString(dateStr: endDateTxtField.text! as NSString))){
            AlertView.showCustomAlertWithMessage(message: "End date has to be after start date", yPos: 20, duration: NSInteger(2.0))
            return
            
        }else if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return
        }

//        self.dismissViewController()
        dismiss(animated: true, completion: nil)

        let tempDict : NSDictionary = ["startdate" : startDateTxtField.text!, "enddate" : endDateTxtField.text!, "status" :"Hot"]
        delegate?.getDictionary(searchDict: tempDict)
//        let tempDict : NSDictionary = ["startdate" : startDateTxtField.text!, "enddate" : endDateTxtField.text!, "status" : statusButton.titleLabel?.text! ?? "Hot"]
//        delegate?.getDictionary(searchDict: tempDict)
    }
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
//        let backBtn = UIButton(type: .custom)
//        backBtn.setImage(UIImage(named: "img_back"), for: .normal)
//        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
//        backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
//        let item1 = UIBarButtonItem(customView: backBtn)
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//        self.navigationItem.leftBarButtonItem = item1
//
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearFilterValues))
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//
//
//        dropDown.anchorView = self.statusButton
//        dropDown.bottomOffset = CGPoint(x: 0, y: self.statusButton.frame.size.height)
//        dropDown.width = self.statusButton.frame.size.width
//        dropDown.dataSource = ["Hot", "Warm", "Cold"]
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
        self.navigationItem.title = "Lead Filter"
        
        
    }

    func dismissViewController() {
        _ = self.navigationController?.popViewController(animated: true)        
    }
    
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == startDateTxtField {
            let datePicker = UIDatePicker()
            textField.inputView = datePicker
            datePicker.datePickerMode = .date
            datePicker.maximumDate = Date()
            datePicker.addTarget(self, action: #selector(datePickerStartDateChanged(sender:)), for: .valueChanged)
        }
        else if textField == endDateTxtField {
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
        self.startDateTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerEndDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
        formatter.dateFormat = "dd-MMM-yyyy"
        self.endDateTxtField.text = formatter.string(from: sender.date)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}
