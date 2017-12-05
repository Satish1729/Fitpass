//
//  AssetDetailController.swift
//  Fitpass
//
//  Created by SatishMac on 29/06/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class AssetDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
        var assetObj : Assets?
        var assetDetailArray : NSMutableArray = NSMutableArray()
        
        @IBOutlet weak var assetDetailTableView: UITableView!
        @IBOutlet weak var assetNameLabel: UILabel!
        @IBOutlet weak var statusLabel: UILabel!
        @IBOutlet weak var amountLabel: UILabel!
        @IBOutlet weak var statusImageView: UIImageView!
    

        var keyLabelNameArray : NSArray = ["Vendor Name", "Purchased On", "Asset Status", "Created By", "Created Date", "Bill", "Remarks"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.assetNameLabel.text = assetObj?.asset_name
            self.statusLabel.text=assetObj?.asset_status ?? ""
            self.amountLabel.text=(assetObj?.amount?.stringValue)!+"rs"
            
            self.statusImageView.layer.cornerRadius = self.statusImageView.frame.size.width / 2
            self.statusImageView.clipsToBounds = true
            switch self.statusLabel.text! {
                case "Expired":
                self.statusImageView.backgroundColor = UIColor.red
                case "Available":
                    self.statusImageView.backgroundColor = UIColor.green
                default:
                    self.statusImageView.backgroundColor = UIColor.red
            }

            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage(named: "img_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: backBtn)
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = item1
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Asset Detail"
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            self.assetDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
        
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : AssetDetailCell = tableView.dequeueReusableCell(withIdentifier: "AssetDetailCell") as! AssetDetailCell
            
            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
            var strValue : String? = ""
            switch indexPath.row {
            case 0:
                strValue = assetObj?.vendor_name
            case 1:
                strValue = assetObj?.purchased_on
                if(strValue != nil){
                    strValue = Utility().getDateStringSimple(dateStr: strValue!)
                }

            case 2:
                strValue = assetObj?.asset_status
            case 3:
                strValue = assetObj?.created_by
            case 4:
                strValue = assetObj?.created_at
                if(strValue != nil){
                    strValue = Utility().getDateString(dateStr: strValue!)
                }

            case 5:
                strValue = assetObj?.bill
            case 6:
                strValue = assetObj?.remarks
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
                cell.contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
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
