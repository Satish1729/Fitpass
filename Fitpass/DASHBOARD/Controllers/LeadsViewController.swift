//
//  LeadsViewController.swift
//  Fitpass
//
//  Created by SatishMac on 12/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class LeadsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var leadsTableView: UITableView!
    
    var leadsArray : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLeads()
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
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    print(responseDict!)
//                    self.leadsArray.addObjects(from:  AgencyBean().getAgencyDetails(agencyDict: responseDict!) as [AnyObject])
//                    self.leadsArray.addObjects(from:  AgencyBean().getAgencyDetails(agencyDict: responseDict!) as [AnyObject])
                    
                    self.leadsTableView.reloadData()
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Agencies list failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//leadsArray!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeadsCell")!
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15)
//        cell.textLabel?.text = menuArray[indexPath.row]
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath)  {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
