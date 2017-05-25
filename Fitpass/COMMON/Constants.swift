//
//  Constants.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class Constants: NSObject {

}

extension Notification.Name {
    static let selectedSideMenuNotify = Notification.Name("Selected side menu notification")
    static let attendanceLogNotify = Notification.Name("Attendance log Notification")
}

struct StringFiles {
    
    let CONNECTIONFAILUREALERT:String = "Please check your internet connection."
    let FORGOTPASSWORDMESSAGE : String = "The new password will be sent to your registered email id"
    let FORGOTPASSWORDFAILMESSAGE: String = "Forgot password failed"
    let FORGOTPASSWORDTITLE : String = "Forgot Password ?"
    let SEND : String = "SEND"
    let CANCEL : String = "CANCEL"
    let EMAIL_ID : String = "Email Id"
    
    static let ALERT_SOMETHING : String = "Something went wrong..."

    //Login Validations
    let EMPTYLOGINCREDENTIALS : String = "Please enter valid email-id and password"
    let INVALIDEMAILID : String = "Please enter valid email-id"
    let LOGIN_FAILED : String = "The Sign In credentials are not recognized."
    
    let PROFILE_GET_DETAILS_FAILED : String = "Unable to get the userdetails..."
    let PROFILE_DETAILS_UPDATE_FAILED : String = "Unable to update the profile details..."
    let PROFILE_DETAILS_UPDATE_SUCCESS : String = "Profile details updated successfully..."
    
    // Logout
    let LOGOUT_FAILS : String = "SignOut failed, please check your connection"
    let LOGOUT_SUCCESS : String = "User successfully signout"
}

struct MenuList {
    let DASHBOARD:String = "Dashboard"
    let LEADS:String = "Leads"
    let MEMBERS:String = "Members"
    let PAYMENTS:String = "Payments"
    let ASSESTS:String = "Assests"
    let STAFFS:String = "Staffs"
    let SEND_SMA:String = "Send SMA"
    let SUPPORTS:String = "Supports"
    let LOGOUT:String = "Logout"
    let WORKOUT:String = "Workout"
    let RESERVED_WORKOUTS:String = "Reserved Workouts"
    let WORKOUT_SCHEDULE:String = "Workout Schedule"
}


