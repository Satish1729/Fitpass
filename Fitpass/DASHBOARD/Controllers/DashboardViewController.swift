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
import KYCircularProgress

class DashboardViewController: BaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var totalLeadsLabel: UILabel!
    @IBOutlet weak var salesCircle: KYCircularProgress!
    @IBOutlet weak var openCircle: KYCircularProgress!
    @IBOutlet weak var memberCircle: KYCircularProgress!
    @IBOutlet weak var deadCircle: KYCircularProgress!
    @IBOutlet private weak var salesPercentLabel: UILabel!
    @IBOutlet private weak var openPercentLabel: UILabel!
    @IBOutlet private weak var memberPercentLabel: UILabel!
    @IBOutlet private weak var deadPercentLabel: UILabel!

    private var progress: UInt8 = 0

    var months: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
         months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        barChartView.chartDescription?.text = ""
        barChartView.tintColor = UIColor.green
        barChartView.gridBackgroundColor  = UIColor.lightText
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        self.getLeadsCount()
        self.getSalesData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Home"
    }

    func getLeadsCount() {
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        ProgressHUD.showProgress(targetView: self.view)
        NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_GRAPH_DATA , userInfo: nil , type: "GET") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDict:NSDictionary? = jsonObject as? NSDictionary
                if (responseDict != nil) {
                    print(responseDict!)
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
                    
                    self.setChart(dataPoints: xValuesArray as! [Int], values: yValuesArray as! [Double], labelname: tempName)
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Leads count failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func getSalesData() {
        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
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
                        self.totalLeadsLabel.text = "Total Leads ("+leadsCount.stringValue+")"
                        let resultArray: NSArray = responseDict!.object(forKey: "result") as! NSArray
    //                    let tempDict : NSDictionary = resultArray.object(at: 0) as! NSDictionary
                        let tempDict  = NSMutableDictionary()
                        for tempObj in resultArray{
                            let localDict = tempObj as! [String:Any]
                            tempDict.setObject(localDict["key2"]!, forKey: localDict["displayName"] as! NSCopying)
                        }
                        self.salesCircle.progressChanged {
                            (progress: Double, circularProgress: KYCircularProgress) in
                            self.salesPercentLabel.text = String.init(format: "%.0f", progress*100.0) + "%"
                        }
                        var progress1: UInt8 = 0
                        progress1 = tempDict.object(forKey: "Sales") as! UInt8
                        let normalizedProgress = Double(progress1)/Double(100)
                        self.salesCircle.colors = [UIColor(red: 4/255, green: 30/255, blue: 52/255, alpha: 1.0)]
                        self.salesCircle.progress = normalizedProgress

                        /////////
                        self.openCircle.progressChanged {
                            (progress: Double, circularProgress: KYCircularProgress) in
                            self.openPercentLabel.text = String.init(format: "%.0f", progress*100.0) + "%"
                        }
                        var progress2: UInt8 = 35
                        progress2 = tempDict.object(forKey: "Open") as! UInt8
                        let normalizedProgress2 = Double(progress2)/Double(100)
                        self.openCircle.colors = [UIColor(red: 6/255, green: 22/255, blue: 39/255, alpha: 1.0)]
                        self.openCircle.progress = normalizedProgress2
                        
                        //////////
                        self.memberCircle.progressChanged {
                            (progress: Double, circularProgress: KYCircularProgress) in
                            self.memberPercentLabel.text = String.init(format: "%.0f", progress*100.0) + "%"
                        }
                        var progress3: UInt8 = 75
                        progress3 = tempDict.object(forKey: "Member") as! UInt8
                        let normalizedProgress3 = Double(progress3)/Double(100)
                        self.memberCircle.colors = [UIColor(red: 4/255, green: 30/255, blue: 52/255, alpha: 1.0)]
                        self.memberCircle.progress = normalizedProgress3

                        ///////////
                        self.deadCircle.progressChanged {
                            (progress: Double, circularProgress: KYCircularProgress) in
                            self.deadPercentLabel.text = String.init(format: "%.0f", progress*100.0) + "%"
                        }
                        var progress4: UInt8 = 0
                        progress4 = tempDict.object(forKey: "Dead") as! UInt8
                        let normalizedProgress4 = Double(progress4)/Double(100)
                        self.deadCircle.colors = [UIColor(red: 4/255, green: 30/255, blue: 52/255, alpha: 1.0)]
                        self.deadCircle.progress = normalizedProgress4

                    }
                }
            }
            else{
                AlertView.showCustomAlertWithMessage(message: StringFiles.ALERT_SOMETHING, yPos: 20, duration: NSInteger(2.0))
                print("Get Leads count failed : \(String(describing: error?.localizedDescription))")
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
