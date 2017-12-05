//
//  ReservedWorkoutDetailController.swift
//  Fitpass
//
//  Created by Satish Regeti on 13/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class ReservedWorkoutDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
        var reservedWorkoutObj : ReservedWorkouts?
        var reservedWorkoutDetailArray : NSMutableArray = NSMutableArray()
        
        @IBOutlet weak var reservedWorkoutDetailTableView: UITableView!
        @IBOutlet weak var workoutNameLabel: UILabel!
        @IBOutlet weak var profileImageView: UIImageView!
        
        var keyLabelNameArray : NSArray = ["User Name", "Phone Number", "Membership Id", "Workout Status", "Workout Date", "Schedule Id"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.workoutNameLabel.text = reservedWorkoutObj?.workout_name
            self.profileImageView.image = UIImage(named: "workout_detail")
            
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
            self.navigationItem.title = "Workout Detail"
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
            view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0)
            
            return view
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell : ReservedWorkoutDetailCell = tableView.dequeueReusableCell(withIdentifier: "ReservedWorkoutDetailCell") as! ReservedWorkoutDetailCell
            
            cell.keyLabel.text = keyLabelNameArray.object(at: indexPath.row) as? String
            var strValue : String? = ""
            switch indexPath.row {
            case 0:
                strValue = reservedWorkoutObj?.user_name
            case 1:
                strValue = reservedWorkoutObj?.user_mobile
            case 2:
                strValue = reservedWorkoutObj?.user_membership_id
            case 3:
                strValue = reservedWorkoutObj?.status
            case 4:
                strValue = reservedWorkoutObj?.workout_date
                if(strValue != nil){
                    strValue = Utility().getDateStringSimple(dateStr: strValue!)
                }
            case 5:
                strValue = reservedWorkoutObj?.user_schedule_id
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
