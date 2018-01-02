//
//  SalesReportDetailController.swift
//  Fitpass
//
//  Created by Quantela on 28/11/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class SalesReportDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
        var salesReportObj : SalesReport?
        var salesReportDetailArray : NSMutableArray = NSMutableArray()
        
        @IBOutlet weak var salesReportDetailTableView: UITableView!
        @IBOutlet weak var profileImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var callButton: UIButton!
        @IBOutlet weak var contactNumberLabel: UILabel!
        @IBOutlet weak var borderview: UIView!
            
        var smsString : String = ""
        
        
        var keyLabelNameArray : NSArray = ["Order Id", "Order Amount", "Paid Amount", "Paid Date", "Due Date", "Payment Status"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.nameLabel.text = salesReportObj?.member_name
            self.callButton.setTitle(salesReportObj?.contact_number?.stringValue, for: UIControlState.normal)
//            self.contactNumberLabel.text=salesReportObj?.contact_number?.stringValue
            
            self.callButton.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
            
            self.profileImageView.image = UIImage(named: "profile_empty")
            
            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage(named: "img_back"), for: .normal)
            backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: backBtn)
            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = item1
            
            let filterBtn = UIButton(type: .custom)
            filterBtn.setImage(UIImage(named: "sms"), for: .normal)
            filterBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            filterBtn.addTarget(self, action: #selector(showSendSMSView), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: filterBtn)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
            self.navigationItem.rightBarButtonItem = item2
            
            self.borderview.layer.borderWidth = 1.0
            self.borderview.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
            self.borderview.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.borderview.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            self.borderview.layer.shadowOpacity = 1.0
            self.borderview.layer.shadowRadius = 0.0
            self.borderview.layer.masksToBounds = false
            self.borderview.layer.cornerRadius = 1.0
        }
        
        func showSendSMSView(){
            showAlertWithTextFieldAndTitle(title: "Send sms to "+(salesReportObj?.member_name)!, message: "", forTarget: self, buttonOK: "Send SMS", buttonCancel: "Cancel", isEmail: false, textPlaceholder: "Message", alertOK: { (msgString) in
                self.smsString = msgString
                self.sendSMS()
            }) { (Void) in
                
            }
        }
        
        func sendSMS(){
            if (appDelegate.userBean == nil) {
                return
            }
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
                return;
            }
            
            ProgressHUD.showProgress(targetView: self.view)
            
            let paramDict : [String : Any] = ["mobile" : self.callButton.titleLabel?.text ?? "", "text" : self.smsString]
            
            NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_SEND_SMS , userInfo: paramDict as NSDictionary, type: "POST") { (data, response, error) in
                
                ProgressHUD.hideProgress()
                
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDic:NSDictionary? = jsonObject as? NSDictionary
                    if (responseDic != nil) {
                        print(responseDic!)
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
                else{
                    AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                    print("sending message to sales failed : \(String(describing: error?.localizedDescription))")
                }
            }
        }
        
        func call(){
            callTheNumber(numberString: (self.callButton.titleLabel?.text)!)
        }
        
//        func email(){
//            sendMailTo(mailString: self.emailLabel.text!)
//        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Sales Report Detail"
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            self.salesReportDetailTableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
            nameLabel.text = salesReportObj?.member_name!
            nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            nameLabel.textColor = UIColor.black
            view.addSubview(nameLabel)
            
            return view
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : SalesReportDetailCell = tableView.dequeueReusableCell(withIdentifier: "SalesReportDetailCell") as! SalesReportDetailCell
            
            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
            var strValue : String? = ""
            switch indexPath.row {
            case 0:
                strValue = salesReportObj?.order_id?.stringValue
            case 1:
                strValue = salesReportObj?.total_order_amount?.stringValue
            case 2:
                strValue = salesReportObj?.total_paid_amount?.stringValue
            case 3:
                strValue = salesReportObj?.paid_date
                if(strValue != nil){
                    strValue = Utility().getDateStringSimple(dateStr: strValue!)
                }
            case 4:
                strValue = salesReportObj?.due_date
                if(strValue != nil){
                    strValue = Utility().getDateStringSimple(dateStr: strValue!)
                }
            case 5:
                strValue = salesReportObj?.status
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

