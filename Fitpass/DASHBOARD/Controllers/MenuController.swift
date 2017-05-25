//
//  MenuController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var studioTypeBtn: UIButton!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    let segues = ["showDashBoardVC", "showLeadsVC" , "showMembersVC", "showPaymentsVC", "showAssetsVC", "showStaffsVC", "showSendSMAVC", "showSupportsVC",  "showLogoutVC", "showWorkoutVC", "showReservedWorkoutsVC", "showWorkoutScheduleVC"]
    
    let menuArray :Array =  ["Dashboard", "Leads", "Members", "Payments", "Assets", "Staffs", "Send SMA", "Supports", "Logout", "Workout", "Reserved Workouts", "Workout Schedule"]

        //[MenuList().DASHBOARD, MenuList().LEADS, MenuList().MEMBERS, MenuList().PAYMENTS, MenuList().ASSESTS, MenuList().STAFFS, MenuList().SEND_SMA, MenuList().SUPPORTS, MenuList().LOGOUT, MenuList().WORKOUT, MenuList().RESERVED_WORKOUTS, MenuList().WORKOUT_SCHEDULE]
    
    private var previousIndex: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadProfileDetails()
        menuTableView.tableFooterView = UIView(frame: .zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProfileDetails() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.userName.text = appDelegate.userBean?.first_name!
        self.emailLabel.text = appDelegate.userBean?.email
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 3
        }
        return menuArray.count-3
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1) {
            return "Fitpass Workouts"
        }
        return ""
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        if(indexPath.section == 1) {
            cell.textLabel?.text = menuArray[indexPath.row + menuArray.count - 3]
        }
        else{
            cell.textLabel?.text = menuArray[indexPath.row]
        }
        
        cell.imageView?.image = UIImage(named : "sidemenu")
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }
    
     func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)  {
        
        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        if(indexPath.section == 1){
            sideMenuController?.performSegue(withIdentifier: segues[indexPath.row + menuArray.count - 3], sender: nil)
        }
        else {
            if(indexPath.row != 8){
                sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
            }
        }
        previousIndex = indexPath as NSIndexPath?
    }
}
