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

    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var studioTypeBtn: UIButton!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    let segues = ["showDashBoardVC", "showLeadsVC" , "showMembersVC", "showSalesReportVC", "showAssetsVC", "showStaffsVC","showPaymentsVC", "showWorkoutVC", "showReservedWorkoutsVC", "showWorkoutScheduleVC",  "showLogoutVC"]
    
    let menuArray :Array =  ["Dashboard", "Leads", "Members", "Sales Report", "Assets", "Staffs", "Payments", "Workout", "Reserved Workouts", "Workout Schedule", "Logout"]

    let imagesArray : Array = ["home", "leads", "members", "salereport", "assets", "staffs", "payments", "workout", "reservedworkouts", "workoutschedule", "logout"]
    
    private var previousIndex: NSIndexPath?
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.tableFooterView = UIView(frame: .zero)
        
        self.studioTypeBtn.setTitle(appDelegate.userBean?.studioName, for: UIControlState.normal)
        self.studioTypeBtn.addTarget(self, action: #selector(showStudioList(sender:)), for: UIControlEvents.touchUpInside)
        self.loadProfileDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews(){
    
    }
    
    func loadProfileDetails() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.layer.borderWidth = 1
        
        self.profileImageView.image = UIImage(named: "profile_empty")
        
        self.userName.text = (appDelegate.userBean?.first_name)! + " " + (appDelegate.userBean?.last_name)!
        self.emailLabel.text = appDelegate.userBean?.email
        
        let studioNamesArray : NSMutableArray = NSMutableArray()

        for studioObj in (appDelegate.userBean?.studioArray)! {
            let studioName : String = studioObj.studio_name!
            studioNamesArray.add(studioName)
        }
        dropDown.anchorView = self.studioTypeBtn
        dropDown.topOffset = CGPoint(x:-100, y:0)
        dropDown.bottomOffset = CGPoint(x:-100, y:0)
        dropDown.backgroundColor = UIColor.white
        dropDown.textColor = UIColor.lightGray
        dropDown.dataSource = studioNamesArray as! [String]
        dropDown.direction = .any
        dropDown.width = self.view.frame.size.width*2/3
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.studioTypeBtn.setTitle(item, for: UIControlState.normal)
            let selectedStudioObjArray = appDelegate.userBean!.studioArray as NSArray
            let selectedStudio = selectedStudioObjArray.object(at: index) as! StudioBean
            appDelegate.userBean?.authHeader = selectedStudio.studio_token
            appDelegate.userBean?.partner_id = selectedStudio.partner_id
            appDelegate.userBean?.auth_key = selectedStudio.auth_key
            self.refreshSelectedData()
        }
    }
    
    func refreshSelectedData(){
        
        if let index = previousIndex {
            if(index.section == 1){
                sideMenuController?.performSegue(withIdentifier: segues[index.row + menuArray.count - 5], sender: nil)
            }
            else {
                if(index.row != 7){
                    sideMenuController?.performSegue(withIdentifier: segues[index.row], sender: nil)
                }
            }
        }
    }
    
    func showStudioList(sender: Any) {
        let selectedStudioObjArray = appDelegate.userBean!.studioArray as NSArray
        if(selectedStudioObjArray.count > 1){
            dropDown.show()
        }
    }
    

     func numberOfSections(in tableView: UITableView) -> Int {
        self.menuTableView.separatorStyle = .none
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 1){
            return 5
        }
        return menuArray.count-5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if(section == 1){
            return 50
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView : UILabel = UILabel()
        hView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight)
        hView.text = "    Fitpass Workouts"
        hView.backgroundColor = UIColor(red: 2/255, green: 29/255, blue: 53/255, alpha: 1.0)
        hView.textColor = UIColor.white
        return hView
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")!
        //cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        if(indexPath.section == 1) {
            cell.textLabel?.text = menuArray[indexPath.row + menuArray.count - 5]
            cell.imageView?.image = UIImage(named : imagesArray[indexPath.row + menuArray.count - 5])
        }
        else{
            cell.textLabel?.text = menuArray[indexPath.row]
            cell.imageView?.image = UIImage(named : imagesArray[indexPath.row])
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
     func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)  {
        
        if(indexPath.section==1 && indexPath.row == 4){
            UserDefaults.standard.removeObject(forKey: "userBean")
            appDelegate.checkSingleSignIn()
            return
        }
        if let index = previousIndex {
            tableView.deselectRow(at: index as IndexPath, animated: true)
            UserDefaults.standard.removeObject(forKey: "previousindexsection")
            UserDefaults.standard.removeObject(forKey: "previousindexrow")
            
            UserDefaults.standard.set(previousIndex?.section, forKey: "previousindexsection")
            UserDefaults.standard.set(previousIndex?.row, forKey: "previousindexrow")
        }else{
            UserDefaults.standard.set(0, forKey: "previousindexsection")
            UserDefaults.standard.set(0, forKey: "previousindexrow")
        }
        
        if(indexPath.section == 1){
            sideMenuController?.performSegue(withIdentifier: segues[indexPath.row + menuArray.count - 5], sender: nil)
        }
        else {
            if(indexPath.row != 7){
                sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
            }
        }
        previousIndex = indexPath as NSIndexPath?
    }
    
    func moveToPreviousScreen(){
        if(self.previousIndex?.section == 1){
            sideMenuController?.performSegue(withIdentifier: segues[(self.previousIndex?.row)! + menuArray.count - 5], sender: nil)
        }
        else {
            if(self.previousIndex?.row != 7){
                sideMenuController?.performSegue(withIdentifier: segues[(self.previousIndex?.row)!], sender: nil)
            }
        }
    }

}
