//
//  ServerConstants.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit


class ServerConstants: NSObject {
    
    static let BASE_URL_CLIENT = "http://dev.fitpass.co.in/partner/" //"http://devapi.fitpass.co.in/studio/"
    
    static let BASE_URL_LOGIN = "http://fitpasscrm.com/api/" //"http://35.154.22.28/fitpassAdminDev/public/api/"
    
//    static let BASE_URL_LOGIN_ADMIN = "http://35.154.22.28/fitpassAdminDev/public/api/"
    
    static let BASE_URL = "http://partner_studio.fitpasscrm.com/api/"
    
    //"http://35.154.22.28/fitpassStudioDev/public/api/"
    
    static let URL_LOGIN = BASE_URL_LOGIN+"studios/login"

    static let URL_GET_SUBSCRIPTION_PLANS_LIST = BASE_URL+"subscription_plans"
    static let URL_FORGOT_PASSWORD = BASE_URL_LOGIN+"postForgotPassword"//BASE_URL+"postForgotPassword"
    static let URL_ASSETS = BASE_URL+"assets"
    static let URL_GET_STAFF_ATTENDANCE = BASE_URL+"staff_attendance"
    static let URL_UPDATE_ATTENDANCE = BASE_URL+"attendance"
    static let URL_SEND_SMS = BASE_URL+"send_sms"
    static let URL_SEND_EMAIL = BASE_URL+"communicate/email"
    static let URL_GET_LEADS_COUNT = BASE_URL+"leadscount"
    static let URL_GET_SALES_DATA = BASE_URL+"dashboard/sales"
    static let URL_GET_ALL_LEADS = BASE_URL+"leads"
//    static let URL_GET_ALL_PAYMENTS = BASE_URL+"members/payments"
    static let URL_GET_ALL_MEMBERS = BASE_URL+"members"
    static let URL_STAFF = BASE_URL+"staff"
    static let URL_GET_STAFF_CONFIG_FIELDS_LIST = BASE_URL+"staff/fields_list"
    static let URL_STAFF_STATUS = BASE_URL+"staffs"
    static let URL_GRAPH_DATA = BASE_URL+"graph_data"
    static let URL_GAUGE_DATA = BASE_URL+"gauge_data"
    static let URL_MEMBERS_DATA = BASE_URL+"gauge_data/members"
    static let URL_GET_SALESREPORT = BASE_URL+"members/payments"
    static let URL_URC = BASE_URL_CLIENT+"urcverification/confirmworkouts"
    static let URL_ASSETS_DOWNLOAD = BASE_URL+"assets/sendReport"
    static let URL_STAFFS_DOWNLOAD = BASE_URL+"staff/sendReport"
    static let URL_LEADS_DOWNLOAD = BASE_URL+"leads/sendReport"
    static let URL_MEMBERS_DOWNLOAD = BASE_URL+"members/sendReport"
    static let URL_SALESREPORT_DOWNLOAD = BASE_URL+"members/payments/sendReport"

    static let URL_GET_ALL_PAYMENTS = BASE_URL_CLIENT+"sales/report"
    static let URL_GET_WORKOUTS = BASE_URL_CLIENT+"workouts/workoutslist"
    static let URL_GET_RESERVED_WORKOUTS = BASE_URL_CLIENT+"workout-schedules/userreservedschedules"
    static let URL_ADD_WORKOUT = BASE_URL_CLIENT+"workouts/addworkouts"
    static let URL_DELETE_WORKOUT = BASE_URL_CLIENT+"workouts/deleteworkouts"
    static let URL_UPDATE_WORKOUT = BASE_URL_CLIENT+"workouts/updateworkouts"
    static let URL_WORKOUTS_CATEGORY = BASE_URL_CLIENT+"workout-activities/activities"
    static let URL_ADD_SCHEDULE = BASE_URL_CLIENT+"workout-schedules/addschedule"
    static let URL_GET_STAFF_ROLES = BASE_URL+"studioStaffRoles"
    static let URL_LEAD_DATA = BASE_URL_CLIENT+"lead-data"//"http://devapi.fitpass.co.in/lead-data"
//    static let workout-schedules/updateschedule
}

