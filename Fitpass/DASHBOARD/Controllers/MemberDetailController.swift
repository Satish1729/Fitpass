//
//  MemberDetailController.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class MemberDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
        var memberObj : Members?
        var memberDetailArray : NSMutableArray = NSMutableArray()
        
        @IBOutlet weak var memberDetailTableView: UITableView!
        
        var keyArray : NSArray = ["contact_number", "gender", "email", "lead_source", "address", "remarks", "next_follow_up", "lead_nature", "last_comment", "dob", "created_at", "updated_at"]
        
        var keyLabelNameArray : NSArray = ["Phone Number", "Gender", "Email", "Lead Source", "Address", "Remarks", "Next Followup", "Lead Nature", "Last Comment", "Date of Birth", "Created Date", "Updated Date"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Member Detail"
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
            nameLabel.text = memberObj?.name!
            nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            nameLabel.textColor = UIColor.black
            view.addSubview(nameLabel)
            
            return view
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : MembersDetailCell = tableView.dequeueReusableCell(withIdentifier: "MembersDetailCell") as! MembersDetailCell
            
            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
            var strValue : String? = ""
            switch indexPath.row {
            case 0:
                strValue = (memberObj?.contact_number)?.stringValue
            case 1:
                strValue = memberObj?.gender
            case 2:
                strValue = memberObj?.email
            case 3:
                strValue = memberObj?.lead_source
            case 4:
                strValue = memberObj?.address
            case 5:
                strValue = memberObj?.remarks
            case 6:
                strValue = memberObj?.next_follow_up
            case 7:
                strValue = memberObj?.lead_nature
            case 8:
                strValue = memberObj?.last_comment
            case 9:
                strValue = memberObj?.dob
            case 10:
                strValue = memberObj?.created_at
            case 11:
                strValue = memberObj?.updated_at
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
