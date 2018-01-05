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
    var imageFull : UIImage?

        @IBOutlet weak var assetDetailTableView: UITableView!
        @IBOutlet weak var assetNameLabel: UILabel!
        @IBOutlet weak var statusLabel: UILabel!
        @IBOutlet weak var amountLabel: UILabel!
        @IBOutlet weak var statusImageView: UIImageView!
    

        var keyLabelNameArray : NSArray = ["Vendor Name", "Purchased On", "Asset Status", "Created By", "Created Date", "Remarks" ,"Bill"]
        
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
            if (indexPath.row == 6){
                if (assetObj?.bill) != nil{
                    
                    return 170
                }else{
                    return 44
                }
            }
            return 44
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
        }
        
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : AssetDetailCell = tableView.dequeueReusableCell(withIdentifier: "AssetDetailCell") as! AssetDetailCell
            
//            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
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
                strValue = assetObj?.remarks
            case 6:
                strValue = assetObj?.bill
            default:
                strValue = ""
            }
            if(strValue == "" || strValue == nil){
                strValue = "NA"
            }

            if(indexPath.row == 6){
                let docLabel : UILabel = UILabel.init(frame: CGRect(x:5, y:2, width:350, height:21))
                docLabel.text = "Bill"
                docLabel.textColor = UIColor.lightGray
                docLabel.font = UIFont.systemFont(ofSize: 12.0)
                let docImageView = UIImageView.init(frame: CGRect(x: 5, y: 30, width: 350, height: 130))
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                docImageView.isUserInteractionEnabled = true
                docImageView.addGestureRecognizer(tapGestureRecognizer)
                
                if let joiningDoc = assetObj?.bill{
                    //                    let strDoc = joiningDoc.replacingOccurrences(of: "", with: "")
                    if let url = URL(string:joiningDoc){
                        if let data1 = try? Data(contentsOf: url){
                            docImageView.image = UIImage(data: data1)
                            cell.contentView.addSubview(docImageView)
                        }else{
                            cell.valueLabel.text = "NA"

                        }
                    }else{
                        cell.valueLabel.text = "NA"

                    }
                }
                else{
                    cell.valueLabel.text = "NA"
                }
                cell.contentView.addSubview(docLabel)
                cell.keyLabel.text = ""
                
            }else{
                cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
                cell.valueLabel.text = strValue
            }

            
            
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
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        imageFull = tappedImage.image
        self.performSegue(withIdentifier: "assetFullSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "assetFullSegue") {
            let staffFull : FullImageViewController = segue.destination as! FullImageViewController
            staffFull.image = imageFull
        }
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
}
