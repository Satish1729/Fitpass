//
//  StaffUpdateController.swift
//  Fitpass
//
//  Created by SatishMac on 30/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class StaffUpdateController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
        @IBOutlet weak var staffUpdateTableview: UITableView!

        var delegate : staffDelegate?
        var staffObj : Staffs?
        var keyLabelNameArray : NSArray = ["Name", "Role", "Email", "Contact No.", "Date of Birth", "Gender", "Address", "Joining Date", "Salary", "Salary Date"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
//            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage(named: "img_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: backBtn)
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = item1

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateStaff))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Update Staff"
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.keyLabelNameArray.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : StaffAddCell = tableView.dequeueReusableCell(withIdentifier: "StaffUpdateCell") as! StaffAddCell
            
            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
//            cell.valueTxtField.placeholder = keyLabelNameArray.object(at: indexPath.row) as? String
            
            //            cell.valueTxtField.delegate = self as! UITextFieldDelegate
            cell.tag = indexPath.row
            
            switch indexPath.row {
            case 0:
                cell.valueTxtField.text = staffObj?.name ?? ""
                cell.valueTxtField.keyboardType = .namePhonePad
            case 1:
                cell.valueTxtField.text = staffObj?.role ?? ""
                cell.valueTxtField.keyboardType = .namePhonePad

            case 2:
                cell.valueTxtField.text = staffObj?.email ?? ""
                cell.valueTxtField.keyboardType = .emailAddress

            case 3:
                cell.valueTxtField.text = staffObj?.contact_number?.stringValue ?? ""
                cell.valueTxtField.keyboardType = .numberPad

            case 4:
                cell.valueTxtField.text = staffObj?.dob ?? ""
//                cell.valueTxtField.keyboardType = .numbersAndPunctuation
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                cell.valueTxtField.inputView = datePicker
                datePicker.addTarget(self, action: #selector(datePickerDOBChanged(sender:)), for: .valueChanged)

            case 5:
                cell.valueTxtField.text = staffObj?.gender ?? ""
                cell.valueTxtField.keyboardType = .namePhonePad

            case 6:
                cell.valueTxtField.text = staffObj?.address ?? ""
                cell.valueTxtField.keyboardType = .namePhonePad

            case 7:
                cell.valueTxtField.text = staffObj?.joining_date ?? ""
//                cell.valueTxtField.keyboardType = .namePhonePad
                let datePicker1 = UIDatePicker()
                datePicker1.datePickerMode = .date
                cell.valueTxtField.inputView = datePicker1
                datePicker1.addTarget(self, action: #selector(datePickerJoiningDateChanged(sender:)), for: .valueChanged)

            case 8:
                cell.valueTxtField.text = staffObj?.salary ?? ""
                cell.valueTxtField.keyboardType = .numberPad

            case 9:
                cell.valueTxtField.text = staffObj?.salary_date?.stringValue ?? ""
                cell.valueTxtField.keyboardType = .numberPad

            default:
                cell.valueTxtField.text = ""
                cell.valueTxtField.keyboardType = .default

            }
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
    func datePickerDOBChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let cell7  = staffUpdateTableview.cellForRow(at: IndexPath(row:7,  section:0)) as! StaffAddCell
        cell7.valueTxtField.text = formatter.string(from: sender.date)
    }
    
    func datePickerJoiningDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let cell4  = staffUpdateTableview.cellForRow(at: IndexPath(row:4,  section:0)) as! StaffAddCell
        cell4.valueTxtField.text = formatter.string(from: sender.date)
    }
    
        func updateStaff() {
            self.dismissViewController()
            let staffBean : Staffs = Staffs()
            
            let cell  = staffUpdateTableview.cellForRow(at: IndexPath(row:0,  section:0)) as! StaffAddCell
            staffBean.name = cell.valueTxtField.text ?? ""
            
            let cell1  = staffUpdateTableview.cellForRow(at: IndexPath(row:1,  section:0)) as! StaffAddCell
            staffBean.role = cell1.valueTxtField.text ?? ""
            
            let cell2  = staffUpdateTableview.cellForRow(at: IndexPath(row:2,  section:0)) as! StaffAddCell
            staffBean.email = cell2.valueTxtField.text ?? ""
            
            let cell3  = staffUpdateTableview.cellForRow(at: IndexPath(row:3,  section:0)) as! StaffAddCell
            let myInteger = cell3.valueTxtField.text!
            staffBean.contact_number = NSNumber(value : Int(myInteger)!)
            
            let cell4  = staffUpdateTableview.cellForRow(at: IndexPath(row:4,  section:0)) as! StaffAddCell
            staffBean.dob = cell4.valueTxtField.text ?? ""
            
            let cell5  = staffUpdateTableview.cellForRow(at: IndexPath(row:5,  section:0)) as! StaffAddCell
            staffBean.gender = cell5.valueTxtField.text ?? ""
            
            let cell6  = staffUpdateTableview.cellForRow(at: IndexPath(row:6,  section:0)) as! StaffAddCell
            staffBean.address = cell6.valueTxtField.text ?? ""
            
            let cell7  = staffUpdateTableview.cellForRow(at: IndexPath(row:7,  section:0)) as! StaffAddCell
            staffBean.joining_date = cell7.valueTxtField.text ?? ""
            
            let cell8  = staffUpdateTableview.cellForRow(at: IndexPath(row:8,  section:0)) as! StaffAddCell
            staffBean.salary = cell8.valueTxtField.text ?? ""
            
            if let cell9  = staffUpdateTableview.cellForRow(at: IndexPath(row:9,  section:0)) {
                let myInteger1 = (cell9 as! StaffAddCell).valueTxtField.text!
                staffBean.salary_date = NSNumber(value : Int(myInteger1)!)
            }else{
                let myInteger2 = staffObj?.salary_date?.stringValue ?? ""
                staffBean.salary_date = NSNumber(value : Int(myInteger2)!)
            }
            
            staffBean.id = staffObj?.id
            staffBean.is_active = staffObj?.is_active
            staffBean.is_deleted = staffObj?.is_deleted
            staffBean.created_at = staffObj?.created_at
            staffBean.updated_at = staffObj?.updated_at
            staffBean.joining_documents = staffObj?.joining_documents
            staffBean.remarks = staffObj?.remarks
            
            self.delegate?.updateStaffToList(staffBean: staffBean)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
