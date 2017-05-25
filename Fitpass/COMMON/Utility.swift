//
//  Utility.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import PKHUD


let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)


struct DeviceInfo {
    
    let deviceFrame : CGRect = UIScreen.main.bounds
    
}

var screenStatusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}

let TAG_NETWORK_ALERT = 1000
let kFontFamilyNormal:String = "MyriadPro-Light"
let kBoldFontFamilyNormal:String = "MyriadPro-Semibold"

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone // iPhone and iPod touch style UI
    case Pad // iPad style UI
}

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

func intFromHexString(hexStr: String) -> UInt32 {
    var hexInt: UInt32 = 0
    // Create scanner
    let scanner: Scanner = Scanner(string: hexStr)
    // Tell scanner to skip the # character
    scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
    // Scan hex value
    scanner.scanHexInt32(&hexInt)
    return hexInt
}

func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
    
    // Convert hex string to an integer
    let hexint = Int(intFromHexString(hexStr: hexString))
    let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
    let alpha = alpha!
    
    // Create color object, specifying alpha as well
    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    return color
}

func boldFontWithSize(fontSize:CGFloat) -> UIFont {
    let font:UIFont = UIFont(name: kBoldFontFamilyNormal, size: fontSize)!
    return font
}

func fontWithSize(fontSize:CGFloat) -> UIFont {
    let font:UIFont = UIFont.systemFont(ofSize: fontSize) //UIFont(name: kFontFamilyNormal, size: fontSize)!
    return font
}

//MARK: - Date Extentions
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func endOfMonthOfYear() -> Date {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastDate = dateFormatter.date(from: "\(year)-12-31")
        
        return lastDate!
    }
}

// Get Key from value
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.0
    }
}
//MARK: AlertView

class AlertView: NSObject {
    
    class func showCustomAlertWithMessage(message: String, yPos:CGFloat, duration:NSInteger) {
        appDelegate.window?.addSubview(createAlertViewWithMessage(message: message, y: yPos))
        self.perform(#selector(hideAlertView), with: nil, afterDelay: TimeInterval(duration))
    }
    
    class func createAlertViewWithMessage(message:String, y:CGFloat) -> UIView {
        
        let view = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(y), width: CGFloat(DeviceInfo().deviceFrame.size.width), height: CGFloat(55)))
        view.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.8))
        view.tag = TAG_NETWORK_ALERT
        let button = UIButton(type: .custom)
        button.frame = view.bounds
        button.setTitle(message, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.font = fontWithSize(fontSize: 13)
        button.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5)
        view.addSubview(button)
        
        return view
    }
    
    class func hideAlertView() {
        var view: UIView? = ((appDelegate.window?.viewWithTag(TAG_NETWORK_ALERT))! as UIView)
        if view != nil {
            view?.removeFromSuperview()
            view = nil
        }
    }
    
}

class ProgressHUD: NSObject {
    
    class func showProgress(targetView:AnyObject) {
        HUD.show(.progress, onView: targetView as? UIView)
    }
    
    class func hideProgress() {
        HUD.hide()
    }
}


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

class Utility: NSObject {
    
    //  email validation code method
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "^([0-9a-zA-Z]+[-._+&amp;])*[0-9a-zA-Z]+@([0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$"
        if let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx) as NSPredicate? {
            return emailTest.evaluate(with: testStr)
        }
        return false
    }
    
    
    func getDeviceID()-> String? {
        return UIDevice.current.identifierForVendor!.uuidString
        
    }
    
    func getPushID() -> String? {
        return UserDefaults.standard.value(forKey: "push_id") as? String
    }
    
    
    func getIntervalTimeFromDate( date : NSDate ) -> NSInteger {
        return NSInteger(date.timeIntervalSince1970)
    }
    
    func getDateFromTimeInterval(timeInterval : NSNumber) -> NSDate {
        return Date(timeIntervalSince1970: TimeInterval(timeInterval)) as NSDate
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func getMonthAndDateFromDateString(date : NSDate) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let newDate = dateFormatter.string(from: date as Date)
        
        return newDate
    }
    
    func getDateStringFromDateWithFullFormate(dateStr : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateStr)
        
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        let newDate = dateFormatter.string(from: date! as Date)
        return newDate
    }
    
    func getDateFromTimeInterval(interval : NSNumber) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval)) as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let newDate = dateFormatter.string(from: date as Date)
        return newDate
    }
    
    func getYearStringFromTimeInterval(interval : NSNumber) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval)) as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let newDate = dateFormatter.string(from: date as Date)
        return newDate
    }
    
    func getTimeFromTimeInterval(interval : NSNumber) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval)) as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let newTime = dateFormatter.string(from: date as Date)
        return newTime
        
    }
    
    func getNSTimeIntervalFromDateString(dateStr : NSString) -> NSInteger {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: dateStr as String)! as NSDate
        return Utility().getIntervalTimeFromDate(date: s)
    }
    
    func getDateFromTimeIntervalAsNormalFormate(interval : NSNumber) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval)) as NSDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let newDate = dateFormatter.string(from: date as Date)
        return newDate
    }
    func getWeekStartandEndDates(weekNumber : Int) -> (startDate : Date, endDate : Date) {
        
        var cal = Calendar.current
        // Start of week:
        var comp = DateComponents()
        comp.weekday = cal.firstWeekday
        comp.weekOfYear = weekNumber
        // <-- fill in your week number here
        comp.year = 2015
        // <-- fill in your year here
        let startOfWeek: Date? = cal.date(from: comp)
        // Add 6 days:
        let endOfWeek :Date? = cal.date(byAdding: .day, value: 5, to: startOfWeek!, wrappingComponents: true)
        //        var endOfWeek: Date? = cal.date(byAddingUnit: .day, value: 6, to: startOfWeek, options: 0)
        // Show results:
        let fmt = DateFormatter()
        fmt.dateStyle = .short
        print("\(fmt.string(from: startOfWeek!))")
        print("\(fmt.string(from: endOfWeek!))")
        
        return (startOfWeek!, endOfWeek!)
    }
    
}


extension UIImage
{
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage
    {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


