//
//  StaffDetailController.swift
//  Fitpass
//
//  Created by SatishMac on 30/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class StaffDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
        var staffObj : Staffs?
        var staffDetailArray : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var staffDetailTableView: UITableView!
    
    
        var keyLabelNameArray : NSArray = ["Phone Number", "Gender", "Email", "Date of Birth", "Address", "Remarks", "Role", "Salary", "Salary Date", "Joining Date", "Created Date", "Joining Documents"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Staff Detail"
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
            return 44
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
        
        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let view : UIView = UIView()
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
            view.backgroundColor = UIColor.white
            
            let nameLabel : UILabel = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            nameLabel.textAlignment = .left
            nameLabel.text = staffObj?.name!
            nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            nameLabel.textColor = UIColor.black
            view.addSubview(nameLabel)
            
            return view
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : StaffDetailCell = tableView.dequeueReusableCell(withIdentifier: "StaffDetailCell") as! StaffDetailCell
            
            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
            var strValue : String? = ""
            switch indexPath.row {
            case 0:
                strValue = (staffObj?.contact_number)?.stringValue
            case 1:
                strValue = staffObj?.gender
            case 2:
                strValue = staffObj?.email
            case 3:
                strValue = staffObj?.dob
            case 4:
                strValue = staffObj?.address
            case 5:
                strValue = staffObj?.remarks
            case 6:
                strValue = staffObj?.role
            case 7:
                strValue = staffObj?.salary
            case 8:
                strValue = staffObj?.salary_date?.stringValue
            case 9:
                strValue = staffObj?.joining_date
            case 10:
                strValue = staffObj?.created_at
            case 11:
                strValue = staffObj?.joining_documents
            default:
                strValue = ""
            }
            
            cell.valueLabel.text = strValue
            if(indexPath.row%2 == 0){
                cell.contentView.backgroundColor = UIColor.white
            }else {
                cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            }
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
