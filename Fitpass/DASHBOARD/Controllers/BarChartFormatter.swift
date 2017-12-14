//
//  BarChartFormatter.swift
//  Fitpass
//
//  Created by SatishMac on 15/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import Charts
@objc(BarChartFormatter)

class BarChartFormatter: NSObject, IAxisValueFormatter {
    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the x-axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    
    var months: [String]! = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
//    var months: [String]! = ["JAN","MAR", "MAY","JUL", "SEP", "NOV"]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value)]
    }
    var labels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//
    public func stringForValue(value: Double, axis: AxisBase?) -> String {
        
        return months[Int(value)]
    }

//    func stringForValue(_ value: Int, axis: AxisBase?) -> String {
//        return labels[value]
//    }
//    
//    init(labels: [String]) {
//        super.init()
//        self.labels = labels
//    }
}
