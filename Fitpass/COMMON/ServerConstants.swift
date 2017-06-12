//
//  ServerConstants.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit


class ServerConstants: NSObject {
    
    static let BASE_URL_CLIENT = "http://devapi.fitpass.co.in/studio/"
    
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
    static let URL_GET_LEADS_COUNT = BASE_URL+"leadscount"
    static let URL_GET_SALES_DATA = BASE_URL+"dashboard/sales"
    static let URL_GET_ALL_LEADS = BASE_URL+"leads"
    static let URL_GET_ALL_PAYMENTS = BASE_URL+"members/payments"
    static let URL_GET_ALL_MEMBERS = BASE_URL+"members"
    static let URL_STAFF = BASE_URL+"staff"
    static let URL_GET_STAFF_CONFIG_FIELDS_LIST = BASE_URL+"staff/fields_list"
    static let URL_STAFF_STATUS = BASE_URL+"staffs"

}
/*
 @GET("users")
 Call<PojoUser> getAllusers();
 @GET("users")
 Call<PojoUser> getWorldUsers();
 @FormUrlEncoded
 @POST("users")
 Call<PojoUser> register(@Field("name") String name, @Field("email") String email,
 @Field("mobileNo") String mobileNo, @Field("password") String password, @Field("deviceType") String deviceType
 , @Field("pushId") String pushId, @Field("imei") String imei);
 @FormUrlEncoded
 @POST("studios/login")
 Call<PojoUser> login(@Field("email") String email, @Field("password") String password);
 
 @FormUrlEncoded
 @PUT("users/changepassword")
 Call<PojoUser> updatePassword(@Field("userId") String userId, @Field("oldPass") String oldPass, @Field("newPass") String newPass);
 @GET("staff")
 Call<PojoStaff> getStaffList(@Header("x-auth-token") String token,@Query("search_by") String search_by,@Query("search_text") String search_text);
 @DELETE("staff/{id}")
 Call<PojoStaff> deleteStaff(@Header("x-auth-token") String token,@Path("id") int id);
 @GET("assets")
 Call<PojoAssets> getAssetsList(@Header("x-auth-token") String token,@Query("search_by") String search_by,@Query("search_text") String search_text,@Query("purchased_on") String purchased_on,@Query("expire_date") String expire_date);
 
 @GET("assets")
 Call<PojoAssets> getAssestsList(@Header("x-auth-token") String token,@Query("search_by") String search_by,@Query("search_text") String search_text);
 @GET("leads")
 Call<PojoLead> getAllLeads(@Header("x-auth-token") String token,@Query("search_by") String search_by,@Query("search_text") String search_text);
 @GET("leads")
 Call<PojoLead> getAllFilterLeads(@Header("x-auth-token") String token, @Query("date_range_from") String date_range_from,@Query("date_range_to") String date_range_to,@Query("lead_nature") String status);
 @GET("leadscount")
 Call<PojoLeadCount> getLeadCount(@Header("x-auth-token") String token, @Query("selected_month") String selected_month);
 
 
 @GET("members")
 Call<PojoMember> getAllMember(@Header("x-auth-token") String token,@Query("search_by") String search_by,@Query("search_text") String search_text);
 @GET("members")
 Call<PojoMember> getAllFilterMember(@Header("x-auth-token") String token,@Query("subscription_plan") int subscription_plan);
 
 @GET("subscription_plans")
 Call<PojoPlan> getSubscriptionPlans(@Header("x-auth-token") String token);
 @POST("staff")
 Call<PojoStaff> addStaff(@Header("x-auth-token") String token,@Body BoStaff user);
 @PUT("staff/{id}")
 Call<PojoStaff> updateStaff(@Header("x-auth-token") String token,@Body BoStaff user,@Path("id") int id);
 @GET("workoutlist")
 Call<PojoWorkout> getAllWorkouts(@Header("X-APPKEY") String apiKey,@Query("search_by") String search_by,@Query("search_text") String search_text);
 @DELETE("workouts/delete")
 Call<PojoWorkout> deleteWorkout(@Header("X-APPKEY") String apiKey,@Query("workout_id") String workout_id,@Query("delete_status") String delete_status);
 @GET("workouts/reservedworkouts")
 Call<PojoReWorkout> getAllReservedWorkouts(@Header("X-APPKEY") String apiKey);
 
 @GET("workouts/category")
 Call<PojoWCategory> getAllWorkoutCategory(@Header("X-APPKEY") String apiKey,@Header("X-AUTHKEY") String authKey,@Header("X_DEVICE_ID") String deviceId
 );
 
 @FormUrlEncoded
 @POST("workouts/add")
 Call<PojoAddWorkout>   addWorkout(@Header("X-APPKEY") String apiKey, @Field("workout_image") String workout_image, @Field("partner_id") String partner_id
 , @Field("workout_category_id") String workout_category, @Field("workout_name") String workout_name, @Field("workout_description") String workout_description
 , @Field("workout_status") String workout_status);
 
 @FormUrlEncoded
 @POST("workouts/update")
 Call<PojoAddWorkout>   updateWorkout(@Header("X-APPKEY") String apiKey, @Field("workout_image") String workout_image, @Field("partner_id") String partner_id
 , @Field("workout_category_id") String workout_category_id, @Field("workout_name") String workout_name, @Field("workout_description") String workout_description
 , @Field("workout_status") String workout_status);
 
 @FormUrlEncoded
 @POST("workouts/addschedule")
 Call<PojoAddWorkout> addWorkoutSchedule(@Header("X-APPKEY") String apiKey, @Field("number_of_seats") String number_of_seats, @Field("start_time") String start_time,
 @Field("end_time") String end_time, @Field("workout_days") String workout_days,
 @Field("workout_id") String workout_id,@Field("schedule_status") String schedule_status
 );
 @GET("staff/fields_list")
 Call<PojoConfigFields> getConfigFields(@Header("x-auth-token") String token);
 
 @GET("studioStaffRoles")
 Call<PojoRoles> getRoles(@Header("x-auth-token") String token);

 */
