//
//  SalesReportController.swift
//  Fitpass
//
//  Created by Quantela on 28/11/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

protocol salesReportDelegate {
    func getFilterDictionary (searchDict: NSMutableDictionary)
    func clearFilter ()
}

class SalesReportController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, salesReportDelegate {
    var subscriptionPlan: String?
    var statusString: String?
    var paidDate: String?
    var filterDict: NSMutableDictionary?
    var halfModalTransitioningDelegate : HalfModalTransitioningDelegate?
    @IBOutlet weak var salesReportSearchBar: UISearchBar!
    @IBOutlet weak var salesReportTableView: UITableView!
    
    var salesReportArray : NSMutableArray = NSMutableArray()
    var searchActive : Bool = false
    var filteredArray: NSMutableArray = NSMutableArray()
    var searchString : String? = ""
    var selectedSalesObj : SalesReport?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        salesReportSearchBar.showsCancelButton = true
        
        let filterBtn = UIButton(type: .custom)
        filterBtn.setImage(UIImage(named: "filter"), for: .normal)
        filterBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        filterBtn.addTarget(self, action: #selector(navigateTosalesReportFilter), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: filterBtn)
        
        let downloadBtn = UIButton(type: .custom)
        downloadBtn.setImage(UIImage(named: "download"), for: .normal)
        downloadBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        downloadBtn.addTarget(self, action: #selector(downloadSaleseport), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: downloadBtn)
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [item1, item2]

        self.getsalesReport()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Sales Report"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "salesreport_filter") {
            
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
            
            let filterVC : SalesReportFilterController = segue.destination as! SalesReportFilterController
            filterVC.delegate = self
            filterVC.filterDataDict = self.filterDict

        }
        else if(segue.identifier == "sales_report_detail") {
            let salesDetailVC : SalesReportDetailController = segue.destination as! SalesReportDetailController
            salesDetailVC.salesReportObj = selectedSalesObj
        }
    }
    
    func getsalesReport() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_SALESREPORT , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    self.salesReportArray.addObjects(from:  SalesReport().updateSalesReport(responseDict : responseDic!) as [AnyObject])
                    self.salesReportTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get salesReport failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func getSearchsalesReport() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let parameters : [String : Any] = ["search_text" : self.salesReportSearchBar.text!, "search_by" : "member_name"]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_SALESREPORT+urlString.absoluteString
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
                    self.filteredArray.addObjects(from:  SalesReport().updateSalesReport(responseDict : responseDic!) as [AnyObject])
                    self.salesReportTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Search salesReport failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func getSearchFiltersalesReport() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        let parameters : [String : Any] = ["paid_date" : Utility().getFilterDateFromString(dateStr: self.paidDate!), "status":self.statusString!]

        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_SALESREPORT+urlString.absoluteString
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
            if(self.filteredArray.count > 0){
                self.filteredArray.removeAllObjects()
            }
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    self.filteredArray.addObjects(from:  SalesReport().updateSalesReport(responseDict : responseDic!) as [AnyObject])
                    self.salesReportTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Filter salesReport failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    // Tableview delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var arrayCount = 0
        if(searchActive) {
            arrayCount = filteredArray.count
        }
        else{
            arrayCount = salesReportArray.count
        }
        
        var numOfSections: Int = 0
        if (arrayCount > 0){
            //                tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No sales report data available"
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
        return salesReportArray.count
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
        
        let salesReportLabel : UILabel = UILabel(frame: CGRect(x: 4, y: 0, width: view.frame.size.width/2, height: view.frame.size.height))
        salesReportLabel.textAlignment = .left
        salesReportLabel.text = "Sales Report"
        salesReportLabel.font = UIFont.systemFont(ofSize: 15)
        salesReportLabel.textColor = UIColor.lightGray
        view.addSubview(salesReportLabel)
        
        let plansLabel : UILabel = UILabel(frame: CGRect(x: view.frame.size.width/2 , y: 0, width: view.frame.size.width/2-4, height: view.frame.size.height))
        plansLabel.textAlignment = .right
        plansLabel.text = "Plans"
        plansLabel.font = UIFont.systemFont(ofSize: 15)
        plansLabel.textColor = UIColor.lightGray
        view.addSubview(plansLabel)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesReportCell") as! SalesReportCell
        if(searchActive){
            if filteredArray.count > 0 {
                let salesReportObj = filteredArray.object(at: indexPath.row) as! SalesReport
                cell.updateSalesReportDetails(salesReportBean: salesReportObj)
            }
        } else {
            if salesReportArray.count > 0 {
                let salesReportObj = salesReportArray.object(at: indexPath.row) as! SalesReport
                cell.updateSalesReportDetails(salesReportBean: salesReportObj)
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
            selectedSalesObj = filteredArray.object(at: indexPath.row) as? SalesReport
        }else {
            selectedSalesObj = salesReportArray.object(at: indexPath.row) as? SalesReport
        }
        self.performSegue(withIdentifier: "sales_report_detail", sender: self)
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
        self.salesReportTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = true
        self.getSearchsalesReport()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func navigateTosalesReportFilter() {
        self.performSegue(withIdentifier: "salesreport_filter", sender: self)
    }
    
    func clearFilter() {
        searchActive = false;
        self.filteredArray.removeAllObjects()
        self.salesReportTableView.reloadData()
    }
    
    func getFilterDictionary(searchDict: NSMutableDictionary) {
        self.filterDict = searchDict
        if let statusStr = searchDict.object(forKey: "status") as? String{
            self.statusString = statusStr
        }else{
            self.statusString = ""
        }
        if let paiddate = searchDict.object(forKey: "paid_date") as? String{
            self.paidDate = paiddate
        }else{
            self.paidDate = ""
        }
        searchActive = true
        self.getSearchFiltersalesReport()
    }

    func downloadSaleseport(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


