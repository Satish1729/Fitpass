//
//  PaymentsController.swift
//  Fitpass
//
//  Created by SatishMac on 13/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//


import UIKit

protocol paymentDelegate {
    func getFilterDictionary (searchDict: NSMutableDictionary)
    func clearFilter ()
}

class PaymentsController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, paymentDelegate {
    
    
    @IBOutlet weak var paymentsSearchBar: UISearchBar!
    @IBOutlet weak var paymentsTableView: UITableView!
    
    var bankUtrNumber: String?
    var paymentDate: String?
    var paymentMonth: String?
    var paymentsArray : NSMutableArray = NSMutableArray()
    var searchActive : Bool = false
    var filtered: NSMutableArray = NSMutableArray()
    var searchString : String? = ""
    var selectedPaymentObj : Payments?
    var filterDict: NSMutableDictionary?
    var halfModalTransitioningDelegate : HalfModalTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let partnerForm = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"PartnerRequestViewController") as! PartnerRequestViewController
        partnerForm.view.frame = CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height)
        self.addChildViewController(partnerForm)
        self.view.addSubview(partnerForm.view)
        
        if((appDelegate.userBean?.auth_key == "" || appDelegate.userBean?.auth_key == nil) || (appDelegate.userBean?.partner_id == "" || appDelegate.userBean?.partner_id == nil)){
            paymentsSearchBar.isHidden = true
            paymentsTableView.isHidden = true
            partnerForm.view.isHidden = false
        }else{
            paymentsSearchBar.isHidden = false
            paymentsTableView.isHidden = false
            partnerForm.view.isHidden = true
            
            let filterBtn = UIButton(type: .custom)
            filterBtn.setImage(UIImage(named: "filter"), for: .normal)
            filterBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            filterBtn.addTarget(self, action: #selector(navigateToPaymentsFilter), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: filterBtn)
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = item1
//            paymentsSearchBar.showsCancelButton = true
            self.getPayments()

        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Payments"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "payment_filter") {
            self.halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: segue.destination)
            segue.destination.modalPresentationStyle = .custom
            segue.destination.transitioningDelegate = self.halfModalTransitioningDelegate
            
            let paymentVC : PaymentsFilterController = segue.destination as! PaymentsFilterController
            paymentVC.delegate = self
            paymentVC.filterDataDict = self.filterDict

        }
        else if(segue.identifier == "payment_detail") {
            let paymentDetailVC : PaymentDetailController = segue.destination as! PaymentDetailController
            paymentDetailVC.paymentObj = selectedPaymentObj
        }
    }
    
    func getPayments() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GET_ALL_PAYMENTS , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic?.object(forKey: "code") as! NSNumber  == 401){
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                        self.moveToLoginScreen()
                    }
                    else if(responseDic?.object(forKey: "code") as! NSNumber  == 200){

//                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.paymentsArray.addObjects(from:  Payments().updatePayments(responseDict : responseDic!) as [AnyObject])
                        self.paymentsTableView.reloadData()
                    }else{
                        self.paymentsArray.removeAllObjects()
                        self.paymentsTableView.reloadData()
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Payments failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    func getSearchPayments() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let parameters : [String : Any] = ["bank_utr_number" : self.paymentsSearchBar.text!]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_ALL_PAYMENTS+urlString.absoluteString
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: str , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    if(responseDic?.object(forKey: "code") as! String  == "401"){
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                        self.moveToLoginScreen()
                    }
                    else if(responseDic?.object(forKey: "code") as! String  == "200"){
//                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        if(self.filtered.count>0){
                            self.filtered.removeAllObjects()
                        }
                        self.filtered.addObjects(from:  Payments().updatePayments(responseDict : responseDic!) as [AnyObject])
                        self.paymentsTableView.reloadData()
                    }else{
                        self.filtered.removeAllObjects()
                        self.paymentsTableView.reloadData()
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }

                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Search Payments failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func getSearchFilterPayments() {
        
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        
        let parameters : [String : Any] = ["payment_of_month" : self.paymentMonth! , "payment_date" : self.paymentDate!, "bank_utr_number" : self.bankUtrNumber!]
        let urlString  = self.createURLFromParameters(parameters: parameters)
        let str : String = ServerConstants.URL_GET_ALL_PAYMENTS+urlString.absoluteString
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
                    if(responseDic?.object(forKey: "code") as! String  == "401"){
                        AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: 5)
                        self.moveToLoginScreen()
                    }
                    else if(responseDic?.object(forKey: "code") as! String  == "200"){

//                    if(responseDic!.object(forKey:"code") as! NSNumber == 200){
                        self.filtered.addObjects(from:  Payments().updatePayments(responseDict : responseDic!) as [AnyObject])
                        self.paymentsTableView.reloadData()
                    }else{
                        self.filtered.removeAllObjects()
                        self.paymentsTableView.reloadData()
                        AlertView.showCustomAlertWithMessage(message: responseDic!.object(forKey:"message") as! String, yPos: 20, duration: NSInteger(2.0))
                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Filter Payments failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var arrayCount = 0
        if(searchActive) {
            arrayCount = filtered.count
        }
        else{
            arrayCount = paymentsArray.count
        }
        
        var numOfSections: Int = 0
        if (arrayCount > 0){
//            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No results found"
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
        return paymentsArray.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsCell") as! PaymentsCell
        if(searchActive){
            if filtered.count > 0 {
                let paymentObj = filtered.object(at: indexPath.row) as! Payments
                cell.updatePaymentsDetails(paymentBean: paymentObj)
            }
        } else {
            if paymentsArray.count > 0 {
                let paymentObj = paymentsArray.object(at: indexPath.row) as! Payments
                cell.updatePaymentsDetails(paymentBean: paymentObj)
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
            selectedPaymentObj = filtered.object(at: indexPath.row) as? Payments
        }else {
            selectedPaymentObj = paymentsArray.object(at: indexPath.row) as? Payments
        }
        self.performSegue(withIdentifier: "payment_detail", sender: self)
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
        self.paymentsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = true
        self.getSearchPayments()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func navigateToPaymentsFilter() {
        self.performSegue(withIdentifier: "payment_filter", sender: self)
    }
    
    func clearFilter() {
        searchActive = false;
        self.filtered.removeAllObjects()
        self.paymentsTableView.reloadData()
    }
    
    func getFilterDictionary(searchDict: NSMutableDictionary) {
        self.filterDict = searchDict
        if let bankutr = searchDict.object(forKey: "bankUtrNumber") as? String{
            self.bankUtrNumber = bankutr
        }else{
            self.bankUtrNumber = ""
        }
        if let paymentdate = searchDict.object(forKey: "paymentDate") as? String{
            self.paymentDate = paymentdate
        }else{
            self.paymentDate = ""
        }
        if let paymentmonth = searchDict.object(forKey: "paymentMonth") as? String{
            self.paymentMonth = paymentmonth
        }else{
            self.paymentMonth = ""
        }
        searchActive = true
        self.getSearchFilterPayments()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
