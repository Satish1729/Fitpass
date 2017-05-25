//
//  ServerConstants.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit


class ServerConstants: NSObject {
    
    static let BASE_URL_LOGIN = "http://35.154.22.28/fitpassAdminDev/public/api/"
    
    static let BASE_URL = "http://35.154.22.28/fitpassStudioDev/public/api/"
    
    static let URL_LOGIN = BASE_URL_LOGIN+"studios/login/"

    static let URL_GET_SUBSCRIPTION_PLANS_LIST = BASE_URL+"subscription_plans"
    static let URL_FORGOT_PASSWORD = BASE_URL+"reset_password"
    static let URL_ASSETS = BASE_URL+"assets"
    static let URL_GET_STAFF_ATTENDANCE = BASE_URL+"staff_attendance"
    static let URL_UPDATE_ATTENDANCE = BASE_URL+"attendance"
    static let URL_SEND_SMS = BASE_URL+"communicate/sms"
    static let URL_SEND_EMAIL = BASE_URL+"communicate/email"
    static let URL_GET_LEADS_COUNT = BASE_URL+"dashboard/leads"
    static let URL_GET_SALES_DATA = BASE_URL+"dashboard/sales"
    static let URL_GET_ALL_LEADS = BASE_URL+"leads"
    static let URL_GET_ALL_PAYMENTS = BASE_URL+"members/payments"
    static let URL_GET_ALL_MEMBERS = BASE_URL+"members"
    static let URL_STAFF = BASE_URL+"staff"
    static let URL_GET_STAFF_CONFIG_FIELDS_LIST = BASE_URL+"staff/fields_list"
    static let URL_STAFF_STATUS = BASE_URL+"staffs"

}
