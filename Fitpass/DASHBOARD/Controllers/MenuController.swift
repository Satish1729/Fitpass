//
//  MenuController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var studioTypeBtn: UIButton!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    let segues = ["showDashBoardVC", "showLeadsVC" , "showMembersVC", "showPaymentsVC", "showAssetsVC", "showStaffsVC", "showSendSMAVC", "showSupportsVC", "showWorkoutVC", "showReservedWorkoutsVC", "showWorkoutScheduleVC",  "showLogoutVC"]
    
    let menuArray :Array =  ["Dashboard", "Leads", "Members", "Payments", "Assets", "Staffs", "Send SMS", "Supports", "Workout", "Reserved Workouts", "Workout Schedule", "Logout"]

    let imagesArray : Array = ["home", "leads", "members", "payments", "assets", "staffs", "SMS", "supports", "workout", "workout", "workout", "logout"]
    
    private var previousIndex: NSIndexPath?
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadProfileDetails()
        menuTableView.tableFooterView = UIView(frame: .zero)
        self.profileView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.studioTypeBtn.setTitle(appDelegate.userBean?.studioName, for: UIControlState.normal)
        self.studioTypeBtn.addTarget(self, action: #selector(showStudioList(sender:)), for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadProfileDetails() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.image = UIImage(named : "profileEmpty")
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.layer.borderWidth = 1
        
        self.userName.text = (appDelegate.userBean?.first_name)! + " " + (appDelegate.userBean?.last_name)!
        self.emailLabel.text = appDelegate.userBean?.email
        
        let studioNamesArray : NSMutableArray = NSMutableArray()

        for studioObj in (appDelegate.userBean?.studioArray as? [StudioBean])! {
            let studioName : String = studioObj.studio_name!
            studioNamesArray.add(studioName)
        }

        
        dropDown.anchorView = self.studioTypeBtn
        dropDown.dataSource = studioNamesArray as! [String]
        dropDown.direction = .any
        dropDown.width = 280
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.studioTypeBtn.setTitle(item, for: UIControlState.normal)
        }
    }
    
    func showStudioList(sender: Any) {
        dropDown.show()
    }
    

     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 4
        }
        return menuArray.count-4
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1) {
            tableView.headerView(forSection: 1)?.tintColor = UIColor.red
            return "Fitpass Workouts"
        }
        return ""
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        //cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        if(indexPath.section == 1) {
            cell.textLabel?.text = menuArray[indexPath.row + menuArray.count - 4]
            cell.imageView?.image = UIImage(named : imagesArray[indexPath.row + menuArray.count - 4])
        }
        else{
            cell.textLabel?.text = menuArray[indexPath.row]
            cell.imageView?.image = UIImage(named : imagesArray[indexPath.row])
        }
        
        cell.textLabel?.textColor = UIColor.white
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
            sideMenuController?.performSegue(withIdentifier: segues[indexPath.row + menuArray.count - 4], sender: nil)
        }
        else {
            if(indexPath.row != 7){
                sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
            }
        }
        previousIndex = indexPath as NSIndexPath?
    }
}
