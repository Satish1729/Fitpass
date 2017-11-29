//
//  WorkoutController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import Alamofire

protocol workoutDelegate {
    func addNewWorkoutToList(workoutBean: Workouts)
    func updateWorkoutToList(workoutBean: Workouts)
    func updateSchdeulesArray(scheduleObj:WorkoutSchedulesObject)
}

class WorkoutController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, workoutDelegate {
   
    func updateSchdeulesArray(scheduleObj: WorkoutSchedulesObject) {
        
        let workoutBean : Workouts = self.workoutsArray.object(at: selectedWorkoutCellNumber) as! Workouts
        let workoutBeanObj : Workouts = Workouts()
        workoutBeanObj.create_time = workoutBean.create_time
        workoutBeanObj.created_by = workoutBean.created_by
        workoutBeanObj.is_active = workoutBean.is_active
        workoutBeanObj.update_time = workoutBean.update_time
        workoutBeanObj.updated_by = workoutBean.updated_by
        workoutBeanObj.workout_category_id = workoutBean.workout_category_id
        workoutBeanObj.workout_category_name = workoutBean.workout_category_name
        workoutBeanObj.workout_description = workoutBean.workout_description
        workoutBeanObj.workout_id = workoutBean.workout_id
        workoutBeanObj.workout_image = workoutBean.workout_image
        workoutBeanObj.workout_name = workoutBean.workout_name
        workoutBeanObj.workout_schedules = [scheduleObj]
        
        self.workoutsArray.replaceObject(at: selectedWorkoutCellNumber, with: workoutBeanObj)
    }


    @IBOutlet weak var workoutSearchBar: UISearchBar!
    @IBOutlet weak var workoutTableView: UITableView!
    
    var workoutsArray : NSMutableArray = NSMutableArray()
    var searchActive : Bool = false
    var filteredArray: NSMutableArray = NSMutableArray()
    var searchString : String? = ""
    var selectedWorkoutObj = Workouts()
    var editedWorkoutCellNumber : Int = 0
    var selectedWorkoutCellNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let partnerForm = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"PartnerRequestViewController") as! PartnerRequestViewController
        partnerForm.view.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        self.addChildViewController(partnerForm)
        self.view.addSubview(partnerForm.view)

        if((appDelegate.userBean?.auth_key == "" || appDelegate.userBean?.auth_key == nil) || (appDelegate.userBean?.partner_id == "" || appDelegate.userBean?.partner_id == nil)){
            workoutSearchBar.isHidden = true
            workoutTableView.isHidden = true
            partnerForm.view.isHidden = false
        }else{
            workoutSearchBar.isHidden = false
            workoutTableView.isHidden = false
            partnerForm.view.isHidden = true
            
            let addBtn = UIButton(type: .custom)
            addBtn.setImage(UIImage(named: "add"), for: .normal)
            addBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            addBtn.addTarget(self, action: #selector(navigateToAddController), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: addBtn)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = item1

            workoutSearchBar.showsCancelButton = true
            self.getWorkoutsList()
        }
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
            workoutDetailVC.delegate = self
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
        
       
        let urlRequest = URLRequest(url: URL(string: ServerConstants.URL_GET_WORKOUTS)!)
        let urlString = urlRequest.url?.absoluteString
        
        let headersDict: HTTPHeaders = [
            "X-APPKEY":(appDelegate.userBean?.auth_key)!,
            "X-partner-id":(appDelegate.userBean?.partner_id)!
        ]
        
    Alamofire.request(urlString!, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headersDict).responseJSON { (response) in
        print(response.result)
        let responseDic =  response.result.value as! NSDictionary
        if(responseDic.object(forKey:"code") as! NSNumber == 200){
            self.workoutsArray.removeAllObjects()
            self.workoutsArray.addObjects(from:  Workouts().updateWorkouts(responseDict : responseDic) as [AnyObject])
            self.workoutTableView.reloadData()
        }
        else{
            self.workoutsArray.removeAllObjects()
            self.workoutTableView.reloadData()
            AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
        }
    }
        

        
        
        /*ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_WORKOUTS , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.workoutsArray.removeAllObjects()
                        self.workoutsArray.addObjects(from:  Workouts().updateWorkouts(responseDict : responseDic!) as [AnyObject])
                        self.workoutTableView.reloadData()
                    }else{
                        self.workoutsArray.removeAllObjects()
                        self.workoutTableView.reloadData()
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }
        */
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
        
        let parameters : [String : Any] = ["workout_name" : self.workoutSearchBar.text!]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_WORKOUTS+urlString.absoluteString
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.filteredArray.addObjects(from:  Workouts().updateWorkouts(responseDict : responseDic!) as [AnyObject])
                        self.workoutTableView.reloadData()
                    }else{
                        self.filteredArray.removeAllObjects()
                        self.workoutTableView.reloadData()
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Search Leads failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var arrayCount = 0
        if(searchActive) {
            arrayCount = filteredArray.count
        }
        else{
            arrayCount = workoutsArray.count
        }
        
        var numOfSections: Int = 0
        if (arrayCount > 0){
//            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No workouts data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredArray.count
        }
        return workoutsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell") as! WorkoutCell
        cell.tag = indexPath.row
        if(searchActive){
            if filteredArray.count > 0 {
                let workoutObj = filteredArray.object(at: indexPath.row) as! Workouts
                cell.updateWorkoutDetails(workoutBean: workoutObj)
            }
        } else {
            if workoutsArray.count > 0 {
                let workoutObj = workoutsArray.object(at: indexPath.row) as! Workouts
                cell.updateWorkoutDetails(workoutBean: workoutObj)
            }
        }
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(navigateToUpdateController (sender: )), for: UIControlEvents.touchUpInside)
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteWorkoutFromList (sender: )), for: UIControlEvents.touchUpInside)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if(searchActive){
            selectedWorkoutObj = (filteredArray.object(at: indexPath.row) as? Workouts)!
        }else {
            selectedWorkoutObj = (workoutsArray.object(at: indexPath.row) as? Workouts)!
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
        editedWorkoutCellNumber = btn.tag
        if(searchActive){
            selectedWorkoutObj = (filteredArray.object(at: btn.tag) as? Workouts)!
        }else {
            selectedWorkoutObj = (workoutsArray.object(at: btn.tag) as? Workouts)!
        }
        self.performSegue(withIdentifier: "workout_update", sender: self)
    }
    
    func deleteWorkoutFromList(sender : Any) {
        let btn : UIButton = sender as! UIButton

        showAlertWithTitle(title: "Delete Workout", message: "Are you sure you want to delete this workout?", forTarget: self, buttonOK: "Yes", buttonCancel: "No", alertOK: { (OkString) in
        self.deleteWorkout(tagValue: btn.tag)
        },alertCancel: { (cancelString) in
            
        })
    }
    
    func deleteWorkout(tagValue: Int){
        
        editedWorkoutCellNumber = tagValue
        
        if(searchActive){
            selectedWorkoutObj = (filteredArray.object(at: tagValue) as? Workouts)!
        }else {
            selectedWorkoutObj = (workoutsArray.object(at: tagValue) as? Workouts)!
        }
        
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
//        ProgressHUD.showProgress(targetView: self.view)
        
        let workoutBean = selectedWorkoutObj
        let paramDict : [String : Any] = ["delete_status" : "Yes", "workout_id" : workoutBean.workout_id!]//, "partner_id": workoutBean.]
        
        
        let urlRequest = URLRequest(url: URL(string: ServerConstants.URL_DELETE_WORKOUT)!)
        let urlString = urlRequest.url?.absoluteString
        
        let headersDict: HTTPHeaders = [
            "X-APPKEY":(appDelegate.userBean?.auth_key)!,
            "X-partner-id":(appDelegate.userBean?.partner_id)!,
            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"
        ]
        
        
        Alamofire.request(urlString!, method: .delete, parameters: paramDict, encoding: URLEncoding.default, headers: headersDict).responseJSON { (response) in
            print(response.result.value ?? "Nojsondata")
            let responseDic =  response.result.value as! NSDictionary
            if(responseDic.object(forKey:"code") as! NSNumber == 200){
                self.workoutsArray.removeObject(at: self.editedWorkoutCellNumber)
                self.workoutTableView.reloadData()
            }
            else{
                AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
            }
        }

        /*
        let urlString : String = ServerConstants.URL_DELETE_WORKOUT
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: urlString , userInfo: paramDict as NSDictionary, type: "DELETE") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.workoutsArray.removeObject(at: self.editedWorkoutCellNumber)
                        self.workoutTableView.reloadData()
                    }else{
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }

                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }*/
    }
    func addNewWorkoutToList(workoutBean: Workouts) {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        
        let paramDict : [String : Any] = ["workout_category_id" : workoutBean.workout_category_id!, "workout_name" : workoutBean.workout_name!, "workout_description": workoutBean.workout_description!, "workout_status": workoutBean.is_active!]

        let urlRequest = URLRequest(url: URL(string: ServerConstants.URL_ADD_WORKOUT)!)
        let urlString = urlRequest.url?.absoluteString
        
        let headersDict: HTTPHeaders = [
            "X-APPKEY":(appDelegate.userBean?.auth_key)!,
            "X-partner-id":(appDelegate.userBean?.partner_id)!,
            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"
        ]

        
        Alamofire.request(urlString!, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: headersDict).responseJSON { (response) in
            print(response.result)
            let responseDic =  response.result.value as! NSDictionary
            if(responseDic.object(forKey:"code") as! NSNumber == 200){
                let workoutBeanObj : Workouts = Workouts()
                let tempDict = responseDic.object(forKey: "data") as! NSDictionary

                workoutBeanObj.workout_description = tempDict.object(forKey: "workout_description") as? String
                workoutBeanObj.is_active = tempDict.object(forKey: "workout_status") as? String
                workoutBeanObj.workout_name = tempDict.object(forKey: "workout_name") as? String
                workoutBeanObj.workout_category_id = tempDict.object(forKey: "workout_category_id") as? String
                workoutBeanObj.workout_id = tempDict.object(forKey: "workout_id") as? String
                workoutBeanObj.created_by = appDelegate.userBean?.first_name ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let newDate = dateFormatter.string(from: Date())
                
                workoutBeanObj.create_time = newDate

                self.workoutsArray.add(workoutBeanObj)
                self.workoutTableView.reloadData()
//                workoutBean.workout_id = responseDic.object(forKey: "workout_id") as? String
                
//                self.workoutsArray.add(workoutBean)
//                self.getWorkoutsList()
            }
            else{
                AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
            }
        }
    }
    
    func updateWorkoutToList(workoutBean: Workouts) {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        
        let paramDict : [String : Any] = ["workout_id" : workoutBean.workout_id!, "workout_category_id" : workoutBean.workout_category_id!, "workout_name": workoutBean.workout_name!, "workout_description": workoutBean.workout_description!, "workout_status" : workoutBean.is_active!]
        
        let urlRequest = URLRequest(url: URL(string: ServerConstants.URL_UPDATE_WORKOUT)!)
        let urlString = urlRequest.url?.absoluteString
        
        let headersDict: HTTPHeaders = [
            "X-APPKEY":(appDelegate.userBean?.auth_key)!,
            "X-partner-id":(appDelegate.userBean?.partner_id)!,
            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"
        ]
        
        
        Alamofire.request(urlString!, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: headersDict).responseJSON { (response) in
            print(response.result)
            let responseDic =  response.result.value as! NSDictionary
            if(responseDic.object(forKey:"code") as! NSNumber == 200){
                self.workoutsArray.removeObject(at: self.editedWorkoutCellNumber)
                self.workoutsArray.insert(workoutBean, at: self.editedWorkoutCellNumber)
                self.workoutTableView.reloadData()
            }
            else{
                AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
            }
        }

       /* let urlString : String = ServerConstants.URL_UPDATE_WORKOUT
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: urlString , userInfo: paramDict as NSDictionary, type: "POST") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.workoutsArray.removeObject(at: self.editedWorkoutCellNumber)
                        self.workoutsArray.insert(workoutBean, at: self.editedWorkoutCellNumber)
                        self.workoutTableView.reloadData()
                    }else{
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get workoutS failed : \(String(describing: error?.localizedDescription))")
            }
        }*/
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
