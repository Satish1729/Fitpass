//
//  PaymentDetailController.swift
//  Fitpass
//
//  Created by SatishMac on 08/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class PaymentDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var paymentObj : Payments?
    var paymentDetailArray : NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var paymentDetailTableView: UITableView!
    @IBOutlet weak var bankUtrNumberLabel: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var keyLabelNameArray : NSArray = ["Bank Utr Number", "Total Amount", "Pay Amount", "Workout Reserved", "Attended Workout", "Payment Status", "Payment Date", "Payment Month", "Comments"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bankUtrNumberLabel.text = paymentObj?.bank_utr_number?.stringValue
        self.paymentStatusLabel.text=paymentObj?.payment_status
        self.profileImageView.image = UIImage(named: "man")
        
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
        self.navigationItem.title = "Payment Detail"
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
//        nameLabel.text = leadObj?.name!
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.textColor = UIColor.black
        view.addSubview(nameLabel)
        return nil
        //        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : PaymentDetailCell = tableView.dequeueReusableCell(withIdentifier: "PaymentDetailCell") as! PaymentDetailCell
        
        cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
        var strValue : String? = ""
        switch indexPath.row {
        case 0:
            strValue = paymentObj?.bank_utr_number?.stringValue
        case 1:
            strValue = paymentObj?.total_amount
        case 2:
            strValue = paymentObj?.pay_amount
        case 3:
            strValue = paymentObj?.workout_reserved
        case 4:
            strValue = paymentObj?.attended_workout
        case 5:
            strValue = paymentObj?.payment_status
        case 6:
            strValue = paymentObj?.payment_date
        case 7:
            strValue = paymentObj?.payment_of_month
        case 8:
            strValue = paymentObj?.comment
        default:
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
