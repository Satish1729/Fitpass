
    //
    //  StaffsController.swift
    //  Fitpass
    //
    //  Created by SatishMac on 13/05/17.
    //  Copyright © 2017 Satish. All rights reserved.
    //

    import UIKit
    protocol staffDelegate {
    func addNewStaffToList (staffBean: Staffs)
    func updateStaffToList (staffBean : Staffs)
    }


    class StaffsController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, staffDelegate {


    @IBOutlet weak var staffSearchBar: UISearchBar!
    @IBOutlet weak var staffTableView: UITableView!

    var staffsArray : NSMutableArray = NSMutableArray()
    var searchActive : Bool = false
    var filteredArray: NSMutableArray = NSMutableArray()
    var searchString : String? = ""
    var selectedStaffObj = Staffs()
    var editedStaffCellNumber : Int = 0

    override func viewDidLoad() {
    super.viewDidLoad()
//    staffSearchBar.showsCancelButton = true

    let addBtn = UIButton(type: .custom)
    addBtn.setImage(UIImage(named: "add"), for: .normal)
    addBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
    addBtn.addTarget(self, action: #selector(navigateToAddController), for: .touchUpInside)
    let item1 = UIBarButtonItem(customView: addBtn)
    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem = item1

    self.getStaffList()
    }

    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.title = "Staffs"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "staff_add") {
        let addStaffVC : StaffAddViewController = segue.destination as! StaffAddViewController
        addStaffVC.delegate = self
    }
    else if(segue.identifier == "staff_update") {
            let updateStaffVC : StaffUpdateViewController = segue.destination as! StaffUpdateViewController
            updateStaffVC.delegate = self
            updateStaffVC.staffObj = selectedStaffObj
    }
    else if(segue.identifier == "staff_detail") {
        let staffDetailVC : StaffDetailController = segue.destination as! StaffDetailController
        staffDetailVC.staffObj = selectedStaffObj
    }
    }

    func getStaffList() {

    if (appDelegate.userBean == nil) {
    return
    }
    if !isInternetAvailable() {
    AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
    return;
    }

    ProgressHUD.showProgress(targetView: self.view)

    NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_STAFF , userInfo: nil, type: "GET") { (data, response, error) in

    ProgressHUD.hideProgress()

    if error == nil {
        let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        let responseDic:NSDictionary? = jsonObject as? NSDictionary
        if (responseDic != nil) {
            print(responseDic!)
                self.staffsArray.addObjects(from:  Staffs().updateStaffs(responseDict : responseDic!) as [AnyObject])
                self.staffTableView.reloadData()
        }
    }
    else{
        AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
        print("Get STAFFS failed : \(String(describing: error?.localizedDescription))")
    }
    }
    }

    func getSearchStaffs() {

    if (appDelegate.userBean == nil) {
        return
    }
    if !isInternetAvailable() {
        AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
        return;
    }

    ProgressHUD.showProgress(targetView: self.view)

    let parameters : [String : Any] = ["search_text" : self.staffSearchBar.text!, "search_by" : "Name"]
    let urlString  = self.createURLFromParameters(parameters: parameters)
    let str : String = ServerConstants.URL_STAFF+urlString.absoluteString
    NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
        
        ProgressHUD.hideProgress()
        if error == nil {
            let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let responseDic:NSDictionary? = jsonObject as? NSDictionary
            if (responseDic != nil) {
                print(responseDic!)
                if(self.filteredArray.count>0){
                    self.filteredArray.removeAllObjects()
                }
                self.filteredArray.addObjects(from:  Staffs().updateStaffs(responseDict : responseDic!) as [AnyObject])
                self.staffTableView.reloadData()
            }
        }
        else{
            AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
            print("Get Search Staffs failed : \(String(describing: error?.localizedDescription))")
        }
    }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
    var arrayCount = 0
    if(searchActive) {
        arrayCount = filteredArray.count
    }
    else{
        arrayCount = staffsArray.count
    }

    var numOfSections: Int = 0
    if (arrayCount > 0){
//        tableView.separatorStyle = .singleLine
        numOfSections            = 1
        tableView.backgroundView = nil
    }
    else{
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "No staff data available"
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
    return staffsArray.count
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

    let cell = tableView.dequeueReusableCell(withIdentifier: "StaffCell") as! StaffCell
    cell.tag = indexPath.row
    if(searchActive){
        if filteredArray.count > 0 {
            let staffObj = filteredArray.object(at: indexPath.row) as! Staffs
            cell.updateStaffDetails(staffBean: staffObj)
        }
    } else {
        if staffsArray.count > 0 {
            let staffObj = staffsArray.object(at: indexPath.row) as! Staffs
            cell.updateStaffDetails(staffBean: staffObj)
        }
    }
    cell.editButton.tag = indexPath.row
    cell.editButton.addTarget(self, action: #selector(navigateToUpdateController (sender: )), for: UIControlEvents.touchUpInside)

    cell.deleteButton.tag = indexPath.row
    cell.deleteButton.addTarget(self, action: #selector(deleteStaffFromList (sender: )), for: UIControlEvents.touchUpInside)



    cell.preservesSuperviewLayoutMargins = false
    cell.separatorInset = UIEdgeInsets.zero
    cell.layoutMargins = UIEdgeInsets.zero
    cell.selectionStyle = UITableViewCellSelectionStyle.none

    return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
    if(searchActive){
        selectedStaffObj = (filteredArray.object(at: indexPath.row) as? Staffs)!
    }else {
        selectedStaffObj = (staffsArray.object(at: indexPath.row) as? Staffs)!
    }
    self.performSegue(withIdentifier: "staff_detail", sender: self)
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
    self.staffTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = true;
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = true
    self.getSearchStaffs()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }

    func navigateToAddController() {
    self.performSegue(withIdentifier: "staff_add", sender: self)
    }

    func navigateToUpdateController(sender : Any) {
        let btn : UIButton = sender as! UIButton
        editedStaffCellNumber = btn.tag
        if(searchActive){
            selectedStaffObj = (filteredArray.object(at: btn.tag) as? Staffs)!
        }else {
            selectedStaffObj = (staffsArray.object(at: btn.tag) as? Staffs)!
        }
    self.performSegue(withIdentifier: "staff_update", sender: self)
    }


    func deleteStaffFromList(sender : Any) {
        
        let btn : UIButton = sender as! UIButton
        
        showAlertWithTitle(title: "Delete Staff", message: "Are you sure you want to delete this staff?", forTarget: self, buttonOK: "Yes", buttonCancel: "No", alertOK: { (OkString) in
            self.deleteStaff(tagValue: btn.tag)
        },alertCancel: { (cancelString) in
            
        })
    }

        func deleteStaff(tagValue: Int){

        editedStaffCellNumber = tagValue
        
        if(searchActive){
            selectedStaffObj = (filteredArray.object(at: tagValue) as? Staffs)!
        }else {
            selectedStaffObj = (staffsArray.object(at: tagValue) as? Staffs)!
        }

        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let staffBean = selectedStaffObj
        let paramDict : [String : Any] = ["staff_name" : staffBean.name, "role" : staffBean.role, "email_address": staffBean.email, "contact_number": staffBean.contact_number?.stringValue ?? "", "date_of_birth" : staffBean.dob, "gender" : staffBean.gender, "address" : staffBean.address, "joining_date": staffBean.joining_date, "salary": staffBean.salary, "salary_date": staffBean.salary_date?.stringValue ?? "1" , "remarks" : staffBean.remarks ?? ""]
        
        let urlString : String = ServerConstants.URL_STAFF + "/" + (staffBean.id?.stringValue)!
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: urlString , userInfo: paramDict as NSDictionary, type: "DELETE") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    self.staffsArray.removeObject(at: self.editedStaffCellNumber)
                    self.staffTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get STAFFS failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }

    func addNewStaffToList (staffBean: Staffs) {

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

    let paramDict : [String : Any] = ["staff_name" : staffBean.name!, "role" : staffBean.role!, "email_address": staffBean.email!, "contact_number": staffBean.contact_number?.stringValue ?? "", "date_of_birth" : staffBean.dob!, "gender" : staffBean.gender!, "address" : staffBean.address!, "joining_date": staffBean.joining_date!, "salary": staffBean.salary!, "salary_date": staffBean.salary_date?.stringValue ?? ""]

    NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_STAFF , userInfo: paramDict as NSDictionary, type: "POST") { (data, response, error) in
        
        ProgressHUD.hideProgress()
        
        if error == nil {
            let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            let responseDic:NSDictionary? = jsonObject as? NSDictionary
            if (responseDic != nil) {
                print(responseDic!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let newDate = dateFormatter.string(from: Date())
                
                    staffBean.created_at = newDate
                self.staffsArray.add(staffBean)
                self.staffTableView.reloadData()
            }
        }
        else{
            AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
            print("Get STAFFS failed : \(String(describing: error?.localizedDescription))")
        }
    }
    }

    func updateStaffToList (staffBean: Staffs) {
        
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
        
        let paramDict : [String : Any] = ["staff_name" : staffBean.name!, "role" : staffBean.role!, "email_address": staffBean.email!, "contact_number": staffBean.contact_number?.stringValue ?? "", "date_of_birth" : staffBean.dob!, "gender" : staffBean.gender!, "address" : staffBean.address!, "joining_date": staffBean.joining_date!, "salary": staffBean.salary!, "salary_date": staffBean.salary_date?.stringValue ?? "", "remarks" : staffBean.remarks ?? ""]
        
        let urlString : String = ServerConstants.URL_STAFF + "/" + (staffBean.id?.stringValue)!
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: urlString , userInfo: paramDict as NSDictionary, type: "PUT") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    
                    self.staffsArray.removeObject(at: self.editedStaffCellNumber)
                    self.staffsArray.insert(staffBean, at: self.editedStaffCellNumber)
                    self.staffTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get STAFFS failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }



    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    }
