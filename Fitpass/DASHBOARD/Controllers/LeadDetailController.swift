//
//  LeadDetailController.swift
//  Fitpass
//
//  Created by SatishMac on 27/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class LeadDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var leadObj : Leads?
    var leadDetailArray : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var leadDetailTableView: UITableView!
    
    var keyArray : NSArray = ["contact_number", "gender", "email", "lead_source", "address", "remarks", "next_follow_up", "lead_nature", "last_comment", "dob", "created_at", "updated_at"]

    var keyLabelNameArray : NSArray = ["Phone Number", "Gender", "Email", "Lead Source", "Address", "Remarks", "Next Followup", "Lead Nature", "Last Comment", "Date of Birth", "Created Date", "Updated Date"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Lead Detail"
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
        nameLabel.text = leadObj?.name!
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.textColor = UIColor.black
        view.addSubview(nameLabel)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LeadDetailCell = tableView.dequeueReusableCell(withIdentifier: "LeadDetailCell") as! LeadDetailCell
        
        cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
        var strValue : String? = ""
        switch indexPath.row {
        case 0:
            strValue = (leadObj?.contact_number)?.stringValue
        case 1:
            strValue = leadObj?.gender
        case 2:
            strValue = leadObj?.email
        case 3:
            strValue = leadObj?.lead_source
        case 4:
            strValue = leadObj?.address
        case 5:
            strValue = leadObj?.remarks
        case 6:
            strValue = leadObj?.next_follow_up
        case 7:
            strValue = leadObj?.lead_nature
        case 8:
            strValue = leadObj?.last_comment
        case 9:
            strValue = leadObj?.dob
        case 10:
            strValue = leadObj?.created_at
        case 11:
            strValue = leadObj?.updated_at
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
