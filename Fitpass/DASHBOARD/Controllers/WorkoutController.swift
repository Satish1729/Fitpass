//
//  WorkoutController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

protocol workoutDelegate {
    func addNewWorkoutToList (workoutBean: Workouts)
    func updateWorkoutToList (workoutBean : Workouts)
}

class WorkoutController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, workoutDelegate {
    
    
    @IBOutlet weak var workoutSearchBar: UISearchBar!
    @IBOutlet weak var workoutTableView: UITableView!
    
    var workoutsArray : NSMutableArray = NSMutableArray()
    var searchActive : Bool = false
    var filteredArray: NSMutableArray = NSMutableArray()
    var searchString : String? = ""
    var selectedWorkoutObj = Workouts()
    var editedWorkoutCellNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        workoutSearchBar.showsCancelButton = true
        
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(UIImage(named: "add"), for: .normal)
        addBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        addBtn.addTarget(self, action: #selector(navigateToAddController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: addBtn)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = item1
        
        self.getWorkoutsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Workouts"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "workout_add") {
            let addWorkoutVC : WorkoutAddController = segue.destination as! WorkoutAddController
            addWorkoutVC.delegate = self
        }
        else if(segue.identifier == "workout_update") {
            let updateWorkoutVC : WorkoutUpdateController = segue.destination as! WorkoutUpdateController
            updateWorkoutVC.delegate = self
            updateWorkoutVC.workoutObj = selectedWorkoutObj
        }
        else if(segue.identifier == "workout_detail") {
            let workoutDetailVC : WorkoutDetailController = segue.destination as! WorkoutDetailController
            workoutDetailVC.workoutObj = selectedWorkoutObj
        }
    }
    
    func getWorkoutsList() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_WORKOUTS , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    self.workoutsArray.addObjects(from:  workouts().updateworkouts(responseDict : responseDic!) as [AnyObject])
                    self.workoutTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func getSearchworkouts() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let parameters : [String : Any] = ["search_text" : self.workoutSearchBar.text!, "search_by" : "Name"]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_workout+urlString.absoluteString
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    self.filteredArray.addObjects(from:  workouts().updateworkouts(responseDict : responseDic!) as [AnyObject])
                    self.workoutTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Search Leads failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredArray.count
        }
        return workoutsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view : UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
        view.backgroundColor = UIColor.white
        
        let leadsLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
        leadsLabel.textAlignment = .left
        leadsLabel.text = "    Name"
        leadsLabel.font = UIFont.systemFont(ofSize: 15)
        leadsLabel.textColor = UIColor.lightGray
        view.addSubview(leadsLabel)
        
        
        let createdAtLabel : UILabel = UILabel(frame: CGRect(x: view.frame.size.width/3 , y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
        createdAtLabel.textAlignment = .center
        createdAtLabel.text = "        Joining Date"
        createdAtLabel.font = UIFont.systemFont(ofSize: 15)
        createdAtLabel.textColor = UIColor.lightGray
        view.addSubview(createdAtLabel)
        
        let statusLabel : UILabel = UILabel(frame: CGRect(x: view.frame.size.width/3 + view.frame.size.width/3 , y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
        statusLabel.textAlignment = .right
        statusLabel.text = "               Actions  "
        statusLabel.font = UIFont.systemFont(ofSize: 15)
        statusLabel.textColor = UIColor.lightGray
        view.addSubview(statusLabel)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! workoutCell
        cell.tag = indexPath.row
        if(searchActive){
            if filteredArray.count > 0 {
                let workoutObj = filteredArray.object(at: indexPath.row) as! workouts
                cell.updateworkoutDetails(workoutBean: workoutObj)
            }
        } else {
            if workoutsArray.count > 0 {
                let workoutObj = workoutsArray.object(at: indexPath.row) as! workouts
                cell.updateworkoutDetails(workoutBean: workoutObj)
            }
        }
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(navigateToUpdateController (sender: )), for: UIControlEvents.touchUpInside)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteworkoutFromList (sender: )), for: UIControlEvents.touchUpInside)
        
        
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if(searchActive){
            selectedworkoutObj = (filteredArray.object(at: indexPath.row) as? workouts)!
        }else {
            selectedworkoutObj = (workoutsArray.object(at: indexPath.row) as? workouts)!
        }
        self.performSegue(withIdentifier: "workout_detail", sender: self)
    }
    
    /////// Search Methods
    
    func searchBarTextDidBeginEditing( _ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.filteredArray.removeAllObjects()
        self.workoutTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = true
        self.getSearchworkouts()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func navigateToAddController() {
        self.performSegue(withIdentifier: "workout_add", sender: self)
    }
    
    func navigateToUpdateController(sender : Any) {
        let btn : UIButton = sender as! UIButton
        editedworkoutCellNumber = btn.tag
        if(searchActive){
            selectedworkoutObj = (filteredArray.object(at: btn.tag) as? workouts)!
        }else {
            selectedworkoutObj = (workoutsArray.object(at: btn.tag) as? workouts)!
        }
        self.performSegue(withIdentifier: "workout_update", sender: self)
    }
    
    func deleteworkoutFromList(sender : Any) {
        let btn : UIButton = sender as! UIButton
        editedworkoutCellNumber = btn.tag
        
        if(searchActive){
            selectedworkoutObj = (filteredArray.object(at: btn.tag) as? workouts)!
        }else {
            selectedworkoutObj = (workoutsArray.object(at: btn.tag) as? workouts)!
        }
        
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let workoutBean = selectedworkoutObj
        let paramDict : [String : Any] = ["name" : workoutBean.name, "role" : workoutBean.role, "email": workoutBean.email, "contact_number": workoutBean.contact_number?.stringValue ?? "", "dob" : workoutBean.dob, "gender" : workoutBean.gender, "address" : workoutBean.address, "joining_date": workoutBean.joining_date, "salary": workoutBean.salary, "salary_date": workoutBean.salary_date?.stringValue , "remarks" : workoutBean.remarks]
        
        let urlString : String = ServerConstants.URL_workout + "/" + (workoutBean.id?.stringValue)!
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: urlString , userInfo: paramDict as NSDictionary, type: "DELETE") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    self.workoutsArray.removeObject(at: self.editedworkoutCellNumber)
                    self.workoutTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func addNewworkoutToList (workoutBean: workouts) {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        //        ["Name", "Role", "Email", "Contact No.", "Date of Birth", "Gender", "Address", "Joining Date", "Salary", "Salary Date
        
        //         address  contact_number   created_at   dob   email  gender   id   is_active  is_deleted joining_date :   joining_documents  name   remarks    role   salary   salary_date   updated_at :
        
        let paramDict : [String : Any] = ["name" : workoutBean.name!, "role" : workoutBean.role!, "email": workoutBean.email!, "contact_number": workoutBean.contact_number?.stringValue ?? "", "dob" : workoutBean.dob!, "gender" : workoutBean.gender!, "address" : workoutBean.address!, "joining_date": workoutBean.joining_date!, "salary": workoutBean.salary!, "salary_date": workoutBean.salary_date?.stringValue ?? ""]
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_workout , userInfo: paramDict as NSDictionary, type: "POST") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    self.workoutsArray.add(workoutBean)
                    self.workoutTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func updateworkoutToList (workoutBean: workouts) {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        //        ["Name", "Role", "Email", "Contact No.", "Date of Birth", "Gender", "Address", "Joining Date", "Salary", "Salary Date
        
        //         address  contact_number   created_at   dob   email  gender   id   is_active  is_deleted joining_date :   joining_documents  name   remarks    role   salary   salary_date   updated_at :
        
        let paramDict : [String : Any] = ["name" : workoutBean.name!, "role" : workoutBean.role!, "email": workoutBean.email!, "contact_number": workoutBean.contact_number?.stringValue ?? "", "dob" : workoutBean.dob!, "gender" : workoutBean.gender!, "address" : workoutBean.address!, "joining_date": workoutBean.joining_date!, "salary": workoutBean.salary!, "salary_date": workoutBean.salary_date?.stringValue ?? "", "remarks" : workoutBean.remarks ?? ""]
        
        let urlString : String = ServerConstants.URL_workout + "/" + (workoutBean.id?.stringValue)!
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: urlString , userInfo: paramDict as NSDictionary, type: "PUT") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    self.workoutsArray.removeObject(at: self.editedworkoutCellNumber)
                    self.workoutsArray.insert(workoutBean, at: self.editedworkoutCellNumber)
                    self.workoutTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
