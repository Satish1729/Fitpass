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
import UICircularProgressRing

class DashboardViewController: BaseViewController, ChartViewDelegate {
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var totalLeadsLabel: UILabel!
    @IBOutlet weak var salesCircle: UICircularProgressRingView!
    @IBOutlet weak var openCircle: UICircularProgressRingView!
    @IBOutlet weak var memberCircle: UICircularProgressRingView!
    @IBOutlet weak var deadCircle: UICircularProgressRingView!

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
        
//        salesCircle.setProgress(value: 56, animationDuration: 2) {
//            self.salesCircle.ringStyle = .ontop
//        }

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
