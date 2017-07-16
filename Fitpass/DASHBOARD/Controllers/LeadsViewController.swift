//
//  LeadsViewController.swift
//  Fitpass
//
//  Created by SatishMac on 12/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

protocol leadDelegate {
    func getDictionary (searchDict: NSDictionary)
    func clearFilter ()
}

class LeadsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, leadDelegate {

    
    var statusString: String?
    var endDate: String?
    var startDate: String?
    

    @IBOutlet weak var leadsSearchBar: UISearchBar!
    @IBOutlet weak var leadsTableView: UITableView!
    
    var leadsArray : NSMutableArray = NSMutableArray()
    var searchActive : Bool = false
    var filtered: NSMutableArray = NSMutableArray()
    var searchString : String? = ""
    var selectedLeadObj : Leads?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leadsSearchBar.showsCancelButton = true
        self.navigationController?.navigationBar.isTranslucent = false;
        let filterBtn = UIButton(type: .custom)
        filterBtn.setImage(UIImage(named: "filter"), for: .normal)
        filterBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        filterBtn.addTarget(self, action: #selector(navigateToLeadsFilter), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: filterBtn)

//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named : "filter"), style: .plain, target: self, action: #selector(navigateToLeadsFilter))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = item1
        self.getLeads()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Leads"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "lead_filter") {
            let filterVC : LeadsFilterViewController = segue.destination as! LeadsFilterViewController
            filterVC.delegate = self
        }
        else if(segue.identifier == "lead_detail") {
            let leadDetailVC : LeadDetailController = segue.destination as! LeadDetailController
            leadDetailVC.leadObj = selectedLeadObj
        }
    }
  
    func getLeads() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_ALL_LEADS , userInfo: nil, type: "GET") { (data, response, error) in
            
        ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    self.leadsArray.addObjects(from:  Leads().updateLeads(responseDict : responseDic!) as [AnyObject])
                    self.leadsTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Leads failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func getSearchLeads() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)

        let parameters : [String : Any] = ["search_text" : self.leadsSearchBar.text!, "search_by" : "Name"]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_ALL_LEADS+urlString.absoluteString
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    self.filtered.addObjects(from:  Leads().updateLeads(responseDict : responseDic!) as [AnyObject])
                    self.leadsTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Search Leads failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }

    func getSearchFilterLeads() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let parameters : [String : Any] = ["lead_nature" : self.statusString! , "date_range_to" : self.endDate!, "date_range_from" : self.startDate!]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_ALL_LEADS+urlString.absoluteString
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
            if(self.filtered.count > 0){
                self.filtered.removeAllObjects()
            }
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    self.filtered.addObjects(from:  Leads().updateLeads(responseDict : responseDic!) as [AnyObject])
                    self.leadsTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Filter Leads failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var arrayCount = 0
        if(searchActive) {
            arrayCount = filtered.count
        }
        else{
            arrayCount = leadsArray.count
        }

        var numOfSections: Int = 0
        if (arrayCount > 0){
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No leads data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return leadsArray.count
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
        leadsLabel.text = "    Leads"
        leadsLabel.font = UIFont.systemFont(ofSize: 15)
        leadsLabel.textColor = UIColor.lightGray
        view.addSubview(leadsLabel)


        let createdAtLabel : UILabel = UILabel(frame: CGRect(x: view.frame.size.width/3 , y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
        createdAtLabel.textAlignment = .center
        createdAtLabel.text = "                Created At"
        createdAtLabel.font = UIFont.systemFont(ofSize: 15)
        createdAtLabel.textColor = UIColor.lightGray
        view.addSubview(createdAtLabel)

        let statusLabel : UILabel = UILabel(frame: CGRect(x: view.frame.size.width/3 + view.frame.size.width/3 , y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
        statusLabel.textAlignment = .center
        statusLabel.text = "               Status"
        statusLabel.font = UIFont.systemFont(ofSize: 15)
        statusLabel.textColor = UIColor.lightGray
        view.addSubview(statusLabel)

        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadsCell") as! LeadsCell
        if(searchActive){
            if filtered.count > 0 {
                let leadObj = filtered.object(at: indexPath.row) as! Leads
                cell.updateLeadsDetails(leadBean: leadObj)
            }
        } else {
            if leadsArray.count > 0 {
                let leadObj = leadsArray.object(at: indexPath.row) as! Leads
                cell.updateLeadsDetails(leadBean: leadObj)
            }
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        if(searchActive){
            selectedLeadObj = filtered.object(at: indexPath.row) as? Leads
        }else {
            selectedLeadObj = leadsArray.object(at: indexPath.row) as? Leads
        }
        self.performSegue(withIdentifier: "lead_detail", sender: self)
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
        self.filtered.removeAllObjects()
        self.leadsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = true
        self.getSearchLeads()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    func navigateToLeadsFilter() {
        self.performSegue(withIdentifier: "lead_filter", sender: self)
    }
    
    func clearFilter() {
        searchActive = false;
        self.filtered.removeAllObjects()
        self.leadsTableView.reloadData()
    }

    func getDictionary(searchDict: NSDictionary) {
        self.statusString = searchDict.object(forKey: "status") as? String
        self.startDate = searchDict.object(forKey: "startdate") as? String
        self.endDate = searchDict.object(forKey: "enddate") as? String
        searchActive = true
        self.getSearchFilterLeads()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
