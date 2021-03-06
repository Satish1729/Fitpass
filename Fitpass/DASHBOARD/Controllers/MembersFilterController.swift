//
//  MembersFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class MembersFilterController: BaseViewController {
        
        var delegate : memberDelegate?
    var selectedPlanIndex:Int = 0
    var subscriptionsArray : NSMutableArray = NSMutableArray()
    var filterDataDict : NSMutableDictionary?

    @IBAction func cancelButtonClicked(_ sender: Any) {
        if let delegate = navigationController?.transitioningDelegate as? HalfModalTransitioningDelegate {
            delegate.interactiveDismiss = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        self.clearFilterValues()
    }
    
    @IBOutlet weak var subscriptionPlanButton: UIButton!
        
        @IBAction func searchButtonClicked(_ sender: Any) {
            self.dismissViewController()
            if(self.subscriptionsArray.count > 0){
                let selectedSubscription:  Subscriptions = self.subscriptionsArray.object(at: selectedPlanIndex) as! Subscriptions
                let tempDict : NSMutableDictionary = ["plan" : selectedSubscription.id!]
                delegate?.getFilterDictionary(searchDict: tempDict)
                dismiss(animated: true, completion: nil)
            }
        }
        
        let dropDown = DropDown()
        
    override func viewDidLoad() {
            super.viewDidLoad()
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
//            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "img_back"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = item1

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearFilterValues))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
            getSubscriptionPlans()
        }
        
        func changeStatus() {
            self.dropDown.show()
        }
    
    func getSubscriptionPlans() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_SUBSCRIPTION_PLANS_LIST , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic?.object(forKey: "status") as! String  == "401"){
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                        self.moveToLoginScreen()
                    }
                    else if(responseDic?.object(forKey: "status") as! String  == "200"){
                        
                        self.subscriptionsArray.addObjects(from:  Subscriptions().updateSubscriptions(responseDict : responseDic!) as [AnyObject])
                        
                        
                        let tempArr = NSMutableArray()
                        
                        if(self.subscriptionsArray.count > 0) {
                            for subscriptionObj in (self.subscriptionsArray as? [Subscriptions])!{
                                tempArr.add(subscriptionObj.plan_name!)
                            }
                            
                            self.dropDown.anchorView = self.subscriptionPlanButton
                            self.dropDown.bottomOffset = CGPoint(x: 0, y: self.subscriptionPlanButton.frame.size.height)
                            self.dropDown.width = self.subscriptionPlanButton.frame.size.width
                            self.dropDown.dataSource = tempArr as! [String]//["Pearl Hart", "Gold Plan", "Silver Plan"]
                            self.dropDown.direction = .any
                            if let plantitle = self.filterDataDict?.object(forKey: "plan") as? NSNumber {
                                let subscriptTitle = self.subscriptionsArray.object(at: (Int(plantitle)-1)) as! Subscriptions
                                self.subscriptionPlanButton.setTitle(subscriptTitle.plan_name, for:UIControlState.normal)
                            }else{
                                self.subscriptionPlanButton.setTitle(tempArr.object(at:0) as? String, for: UIControlState.normal)
                            }
                            
                            
                            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                                self.subscriptionPlanButton.setTitle(item, for: UIControlState.normal)
                                self.selectedPlanIndex = index
                            }
                            
                            self.subscriptionPlanButton.addTarget(self, action: #selector(self.changeStatus), for: .touchUpInside)
                        }else{
                            self.subscriptionPlanButton.setTitle("No Subscription Plans", for: UIControlState.normal)
                        }
                    }
                    else{
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Leads failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    

    
        func clearFilterValues () {
            self.subscriptionPlanButton.setTitle("Basic Plan", for: .normal)
            self.filterDataDict?.removeAllObjects()
            self.filterDataDict = nil
            dismiss(animated: true, completion: nil)
            delegate?.clearFilter()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Member Filter"
            
//            if let plantitle = self.filterDataDict?.object(forKey: "plan") as? String {
//                self.subscriptionPlanButton.setTitle(plantitle , for: UIControlState.normal)
//            }else{
//                self.subscriptionPlanButton.setTitle("Basic Plan", for: UIControlState.normal)
//            }

        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
}
