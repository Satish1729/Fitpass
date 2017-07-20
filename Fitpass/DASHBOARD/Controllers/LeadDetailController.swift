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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!

    var keyArray : NSArray = ["contact_number", "gender", "email", "lead_source", "address", "remarks", "next_follow_up", "lead_nature", "last_comment", "dob", "created_at", "updated_at"]

    var keyLabelNameArray : NSArray = ["Date of Birth", "Lead Source", "Lead Nature", "Next Followup", "Last Comment", "Created On", "Last Updated On", "Remarks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = leadObj?.name
        self.contactNumberLabel.text=leadObj?.contact_number?.stringValue
        self.emailLabel.text=leadObj?.email
        self.addressLabel.text=leadObj?.address
        if(leadObj?.gender == "Male"){
            self.profileImageView.image = UIImage(named: "man")
        }else{
            self.profileImageView.image = UIImage(named: "woman")
        }
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "img_back"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = item1
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
//        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

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
        return 0
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
        return nil
//        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LeadDetailCell = tableView.dequeueReusableCell(withIdentifier: "LeadDetailCell") as! LeadDetailCell
        
        cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
        var strValue : String? = ""
        switch indexPath.row {
        case 0:
            strValue = leadObj?.dob
            if(strValue != nil){
                strValue = Utility().getDateStringSimple(dateStr: strValue!)
            }
        case 1:
            strValue = leadObj?.lead_source
        case 2:
            strValue = leadObj?.lead_nature
        case 3:
            strValue = leadObj?.next_follow_up
            if(strValue != nil){
                strValue = Utility().getDateStringSimple(dateStr: strValue!)
            }
        case 4:
            strValue = leadObj?.last_comment
        case 5:
            strValue = leadObj?.created_at
            if(strValue != nil){
                strValue = Utility().getDateString(dateStr: strValue!)
            }

        case 6:
            strValue = leadObj?.updated_at
            if(strValue != nil){
                strValue = Utility().getDateString(dateStr: strValue!)
            }

        case 7:
            strValue = leadObj?.remarks
        default:
            strValue = ""
        }
        
        if(strValue == "" || strValue == nil){
            strValue = "NA"
        }
        cell.valueLabel.text = strValue
        if(indexPath.row%2 == 0){
            cell.contentView.backgroundColor = UIColor.white
        }else {
            cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
