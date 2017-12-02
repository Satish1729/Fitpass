//
//  DashboardViewController.swift
//  Fitpass
//
//  Created by SatishMac on 08/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import SideMenuController
import Charts
import MBCircularProgressBar

class DashboardViewController: BaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    
    @IBOutlet weak var salesBorderView: UIView!
    @IBOutlet weak var leadsBorderView: UIView!
    @IBOutlet weak var membersBorderView: UIView!
    @IBOutlet weak var salesHeaderLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var openProgress: MBCircularProgressBarView!
    @IBOutlet weak var totalLeadsLabel: UILabel!
    @IBOutlet weak var deadProgress: MBCircularProgressBarView!

    @IBOutlet weak var memberProgress: MBCircularProgressBarView!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var deadLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    
    @IBOutlet weak var membersHeaderLabel: UILabel!

    @IBOutlet weak var activeProgress: MBCircularProgressBarView!
    @IBOutlet weak var expiredProgress: MBCircularProgressBarView!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var upcomingdueLabel: UILabel!
    
    private var progress: UInt8 = 0

    var months: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.homeScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
         months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        barChartView.chartDescription?.text = ""
        barChartView.tintColor = UIColor.red
        barChartView.gridBackgroundColor  = UIColor.clear
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        self.getSalesData()
        self.getLeadsCount()
        self.getMembersCount()
    }

    func setChart(dataPoints: [Int], values: [Double], labelname:String) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y:values[i], data: months as AnyObject )
            dataEntries.append(dataEntry)
        }
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        barChartView.xAxis.granularity = 1
        let chartDataSet = BarChartDataSet(values: dataEntries, label: labelname)
        
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        barChartView.data?.setDrawValues(false)
        barChartView.backgroundColor = UIColor.white

    }
    override func viewDidLayoutSubviews()
    {
        self.homeScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1320)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
    }

    func getSalesData() {
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        self.salesBorderView.layer.borderWidth = 1.0
        self.salesBorderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.salesBorderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.salesBorderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.salesBorderView.layer.shadowOpacity = 1.0
        self.salesBorderView.layer.shadowRadius = 0.0
        self.salesBorderView.layer.masksToBounds = false
        self.salesBorderView.layer.cornerRadius = 1.0

        ProgressHUD.showProgress(targetView: self.view)
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GRAPH_DATA , userInfo: nil , type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    print(responseDict!)
                    if(responseDict?.object(forKey: "status") as! String  == "200"){
                     
                        let resultArray: NSArray = responseDict!.object(forKey: "result") as! NSArray
                        let tempDict : NSDictionary = resultArray.object(at: 0) as! NSDictionary
                        let dataArray : NSArray = tempDict.object(forKey: "data") as! NSArray
                        
                        let xTotalArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                        let xValuesArray = NSMutableArray()
                        let yValuesArray = NSMutableArray()
                        for valueDict in dataArray{
                            xValuesArray.add((valueDict as! NSDictionary)[ "x"]!)
                            yValuesArray.add((valueDict as! NSDictionary)[ "y"]!)
                        }
                        
                        for i in 0..<xTotalArray.count{
                            if(xValuesArray.contains(i)){
                                
                            }
                            else{
                                xValuesArray.insert(0, at: i)
                                yValuesArray.insert(Double(0), at: i)
                            }
                        }
                        
                        let tempName = tempDict.object(forKey: "displayName") as! String
                        self.salesHeaderLabel.text = "SALES"
                        self.barChartView.isHidden = false
                        self.setChart(dataPoints: xValuesArray as! [Int], values: yValuesArray as! [Double], labelname: tempName)
                    }else{
                        self.barChartView.isHidden = true
                        self.salesHeaderLabel.text = "No Sales data available"

                    }
                    
                }
            }
            else{
//                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                self.barChartView.isHidden = true
                self.salesHeaderLabel.text = "No Sales data available"
                
            }
        }
    }
    
    func getLeadsCount() {
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        self.leadsBorderView.layer.borderWidth = 1.0
        self.leadsBorderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.leadsBorderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.leadsBorderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.leadsBorderView.layer.shadowOpacity = 1.0
        self.leadsBorderView.layer.shadowRadius = 0.0
        self.leadsBorderView.layer.masksToBounds = false
        self.leadsBorderView.layer.cornerRadius = 1.0

        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GAUGE_DATA , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    print(responseDict!)
                    if(responseDict?.object(forKey: "status") as! String  == "200"){
                        
                        let leadsCount = responseDict?.object(forKey: "message") as! NSNumber
                        self.isHideLeadsCircles(isAvail: false)
                        self.totalLeadsLabel.text = "TOTAL LEADS ("+leadsCount.stringValue+")"
                        let resultArray: NSArray = responseDict!.object(forKey: "result") as! NSArray
                        let tempDict  = NSMutableDictionary()
                        for tempObj in resultArray{
                            let localDict = tempObj as! [String:Any]
                            tempDict.setObject(localDict["key1"]!, forKey: localDict["displayName"] as! NSCopying)
                        }
                        
                        var progress2: UInt8 = 0
                        progress2 = tempDict.object(forKey: "Open") as! UInt8
                        self.openProgress.value = CGFloat(progress2)
                        var progress3: UInt8 = 0
                        progress3 = tempDict.object(forKey: "Member") as! UInt8
                        self.memberProgress.value = CGFloat(progress3)
                        var progress4: UInt8 = 0
                        progress4 = tempDict.object(forKey: "Dead") as! UInt8
                        self.deadProgress.value = CGFloat(progress4)
                    }else{
                        self.totalLeadsLabel.text = "No Leads data available"
                        self.isHideLeadsCircles(isAvail: true)
                    }
                }
            }
            else{
                self.totalLeadsLabel.text = "No Leads data available"
                self.isHideLeadsCircles(isAvail: true)
            }
        }
    }

    func getMembersCount() {
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        self.membersBorderView.layer.borderWidth = 1.0
        self.membersBorderView.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.membersBorderView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.membersBorderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.membersBorderView.layer.shadowOpacity = 1.0
        self.membersBorderView.layer.shadowRadius = 0.0
        self.membersBorderView.layer.masksToBounds = false
        self.membersBorderView.layer.cornerRadius = 1.0

        ProgressHUD.showProgress(targetView: self.view)
        
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_MEMBERS_DATA , userInfo: nil, type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    print(responseDict!)
                    if(responseDict?.object(forKey: "status") as! String  == "200"){

                        let leadsCount = responseDict?.object(forKey: "message") as! NSNumber
                        self.isHideLeadsCircles(isAvail: false)
                        self.membersHeaderLabel.text = "TOTAL MEMBERS ("+leadsCount.stringValue+")"
                        let resultArray: NSArray = responseDict!.object(forKey: "result") as! NSArray
                        let tempDict  = NSMutableDictionary()
                        for tempObj in resultArray{
                            let localDict = tempObj as! [String:Any]
                            tempDict.setObject(localDict["key1"]!, forKey: localDict["displayName"] as! NSCopying)
                        }
                        var progress2: UInt8 = 35
                        progress2 = tempDict.object(forKey: "Active") as! UInt8
                        self.activeProgress.value = CGFloat(progress2)
                        var progress3: UInt8 = 75
                        progress3 = tempDict.object(forKey: "Expired") as! UInt8
                        self.expiredProgress.value = CGFloat(progress3)
                        let str = responseDict!.object(forKey: "due_payment_count") as! UInt8;
                        let myAttribute = [ NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)]
                        let valueString = NSMutableAttributedString(string: "\(str)", attributes: myAttribute )
                        let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
                        let myString = NSMutableAttributedString(string: "    Upcoming dues this month ", attributes: myAttribute1 )
                        myString.append(valueString)
                        self.upcomingdueLabel.attributedText = myString
                    }else{
                        self.membersHeaderLabel.text = "No Members data available"
                        self.isHideMemberCircles(isAvail: true)
                    }
                }
            }
            else{
                self.membersHeaderLabel.text = "No Members data available"
                self.isHideMemberCircles(isAvail: true)
            }
        }
    }

    func isHideLeadsCircles(isAvail : Bool){
        openLabel.isHidden = isAvail
        memberLabel.isHidden = isAvail
        deadLabel.isHidden = isAvail
        openProgress.isHidden = isAvail
        memberProgress.isHidden = isAvail
        deadProgress.isHidden = isAvail
    }

    func isHideMemberCircles(isAvail : Bool){
        activeLabel.isHidden = isAvail
        expiredLabel.isHidden = isAvail
        activeProgress.isHidden = isAvail
        expiredProgress.isHidden = isAvail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
