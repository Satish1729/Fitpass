//
//  AssetsController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

protocol assetDelegate {
    func getDictionary (searchDict: NSDictionary)
    func clearFilter ()
}

class AssetsController:  BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, assetDelegate {
        
        var purchaseDateFrom: String?
        var purchaseDateTo: String?
        
        
        @IBOutlet weak var assetsSearchBar: UISearchBar!
        @IBOutlet weak var assetsTableView: UITableView!
        
        var assetsArray : NSMutableArray = NSMutableArray()
        var searchActive : Bool = false
        var filtered: NSMutableArray = NSMutableArray()
        var searchString : String? = ""
        var selectedAssetObj : Assets?
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
//            assetsSearchBar.showsCancelButton = true
            
            let filterBtn = UIButton(type: .custom)
            filterBtn.setImage(UIImage(named: "filter"), for: .normal)
            filterBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            filterBtn.addTarget(self, action: #selector(navigateToAssetsFilter), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: filterBtn)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = item1
            self.getAssets()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Assets"
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "asset_filter") {
                let filterVC : AssetsFilterController = segue.destination as! AssetsFilterController
                filterVC.delegate = self
            }
            else if(segue.identifier == "asset_detail") {
                let assetDetailVC : AssetDetailController = segue.destination as! AssetDetailController
                assetDetailVC.assetObj = selectedAssetObj
            }
        }
        
        func getAssets() {
            
            if (appDelegate.userBean == nil) {
                return
            }
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
                return;
            }
            
            ProgressHUD.showProgress(targetView: self.view)
            
            NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_ASSETS , userInfo: nil, type: "GET") { (data, response, error) in
                
                ProgressHUD.hideProgress()
                
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDic:NSDictionary? = jsonObject as? NSDictionary
                    if (responseDic != nil) {
                        print(responseDic!)
                        self.assetsArray.addObjects(from:  Assets().updateAssets(responseDict : responseDic!) as [AnyObject])
                        self.assetsTableView.reloadData()
                    }
                }
                else{
                    AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                    print("Get Assets failed : \(String(describing: error?.localizedDescription))")
                }
            }
        }
        
        func getSearchAssets() {
            
            if (appDelegate.userBean == nil) {
                return
            }
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
                return;
            }
            
            ProgressHUD.showProgress(targetView: self.view)
            
            let parameters : [String : Any] = ["search_text" : self.assetsSearchBar.text!, "search_by" : "Asset Name"]
            let urlString  = self.createURLFromParameters(parameters: parameters)
            let str : String = ServerConstants.URL_ASSETS+urlString.absoluteString
            NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
                ProgressHUD.hideProgress()
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDic:NSDictionary? = jsonObject as? NSDictionary
                    if (responseDic != nil) {
                        print(responseDic!)
                        if(self.filtered.count>0){
                            self.filtered.removeAllObjects()
                        }
                        self.filtered.addObjects(from:  Assets().updateAssets(responseDict : responseDic!) as [AnyObject])
                        self.assetsTableView.reloadData()
                    }
                }
                else{
                    AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                    print("Get Search Assets failed : \(String(describing: error?.localizedDescription))")
                }
            }
        }
        
        func getSearchFilterAssets() {
            
            if (appDelegate.userBean == nil) {
                return
            }
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
                return;
            }
            
            ProgressHUD.showProgress(targetView: self.view)
            
//            let parameters : [String : Any] = ["purchased_on" : self.purchaseDateFrom!, "expire_date" : self.purchaseDateTo!]
            let parameters : [String : Any] = ["purchase_date_from" : Utility().getFilterDateFromString(dateStr: self.purchaseDateFrom!), "purchase_date_to" : Utility().getFilterDateFromString(dateStr: self.purchaseDateTo!)]
            
            let urlString  = self.createURLFromParameters(parameters: parameters)
            let str : String = ServerConstants.URL_ASSETS+urlString.absoluteString
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
                        if(self.filtered.count>0){
                            self.filtered.removeAllObjects()
                        }
                        self.filtered.addObjects(from:  Assets().updateAssets(responseDict : responseDic!) as [AnyObject])
                        self.assetsTableView.reloadData()
                    }
                }
                else{
                    AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                    print("Get Filter Assets failed : \(String(describing: error?.localizedDescription))")
                }
            }
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            var arrayCount = 0
            if(searchActive) {
                arrayCount = filtered.count
            }
            else{
                arrayCount = assetsArray.count
            }
            
            var numOfSections: Int = 0
            if (arrayCount > 0){
//                tableView.separatorStyle = .singleLine
                numOfSections            = 1
                tableView.backgroundView = nil
            }
            else{
                let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No assets data available"
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
            return assetsArray.count
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
            
//            let leadsLabel : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: view.frame.size.height))
//            leadsLabel.textAlignment = .left
//            leadsLabel.text = "    Leads"
//            leadsLabel.font = UIFont.systemFont(ofSize: 15)
//            leadsLabel.textColor = UIColor.lightGray
//            view.addSubview(leadsLabel)
            
            
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssetsCell") as! AssetsCell
            if(searchActive){
                if filtered.count > 0 {
                    let assetObj = filtered.object(at: indexPath.row) as! Assets
                    cell.updateAssetsDetails(assetBean: assetObj)
                }
            } else {
                if assetsArray.count > 0 {
                    let assetObj = assetsArray.object(at: indexPath.row) as! Assets
                    cell.updateAssetsDetails(assetBean: assetObj)
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
                selectedAssetObj = filtered.object(at: indexPath.row) as? Assets
            }else {
                selectedAssetObj = assetsArray.object(at: indexPath.row) as? Assets
            }
            self.performSegue(withIdentifier: "asset_detail", sender: self)
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
            self.assetsTableView.reloadData()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchActive = true;
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = true
            self.getSearchAssets()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
        }
        
        func navigateToAssetsFilter() {
            self.performSegue(withIdentifier: "asset_filter", sender: self)
        }
        
        func clearFilter() {
            searchActive = false;
            self.filtered.removeAllObjects()
            self.assetsTableView.reloadData()
        }
        
        func getDictionary(searchDict: NSDictionary) {
            self.purchaseDateFrom = searchDict.object(forKey: "purchase_date_from") as? String
            self.purchaseDateTo = searchDict.object(forKey: "purchase_date_to") as? String
            searchActive = true
            self.getSearchFilterAssets()
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
}
