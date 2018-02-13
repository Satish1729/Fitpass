//
//  PartnerRequestViewController.swift
//  Fitpass
//
//  Created by Satish Regeti on 26/07/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import Alamofire

class PartnerRequestViewController: BaseViewController {

    @IBOutlet weak var studioNameTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var contactPersonTxtField: UITextField!
    @IBOutlet weak var emailTxtield: UITextField!
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var messageTxtView: UITextView!
    
    @IBOutlet weak var partnerScrollView:UIScrollView!
    @IBOutlet weak var submitButton:UIButton!

    override func viewDidLayoutSubviews()
    {
        self.partnerScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1100)
    }

    func isValidRequest() -> Bool {
        
        var isValidUser = false
        
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(self.studioNameTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter studio name", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        if(self.locationTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter location", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        if(self.contactPersonTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter contact person", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        if(emailTxtield.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter email", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }else{
            if(Utility().isValidEmail(testStr: emailTxtield.text!)){
                
            }else{
                AlertView.showCustomAlertWithMessage(message: "Please enter valid email", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
        }
        
        
        if(mobileNumberTxtField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter mobile number.", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }else{
            if(Utility().isValidPhone(value: mobileNumberTxtField.text!)){
                
            }else{
                AlertView.showCustomAlertWithMessage(message: "Please enter valid mobile number", yPos: 20, duration: NSInteger(2.0))
                return isValidUser
            }
        }

        if(self.messageTxtView.text?.trimmingCharacters(in: NSCharacterSet.whitespaces) == ""){
            AlertView.showCustomAlertWithMessage(message: "Please enter message", yPos: 20, duration: NSInteger(2.0))
            return isValidUser
        }
        
        isValidUser = true
        return isValidUser
    }

    func sendPartnerRequest() {
        
        if !isValidRequest() {
            return
        }

        if (appDelegate.userBean == nil) {
            return
        }
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            return;
        }
        
        
//        ProgressHUD.showProgress(targetView: self.view)
        let paramDict : [String : Any] = ["email_address" : emailTxtield.text!, "studio_name":studioNameTxtField.text!, "mobile_number":mobileNumberTxtField.text!, "location":locationTxtField.text!, "contact_person":contactPersonTxtField.text!, "query_message":messageTxtView.text!, "source":"CRM", "created_by":appDelegate.userBean?.first_name ?? ""]
            
        
       /* NetworkManager.sharedInstance.getResponseForLeadForm(url: ServerConstants.URL_LEAD_DATA , userInfo: paramDict as NSDictionary, type: "POST") { (data, response, error) in
            
            ProgressHUD.hideProgress()
            
            if error == nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    showAlertWithTitle(title: "", message: responseDic!.object(forKey: "message") as! String, forTarget: self, buttonOK: "", buttonCancel:"OK", alertOK: { (String) in
//                        self.performSegue(withIdentifier: "showHomePage", sender: nil)
                        self.moveToDashBoard()
                    }, alertCancel: { (Void) in
                        
                    })
                }
            }
            else{
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                let responseDic:NSDictionary? = jsonObject as? NSDictionary
                if (responseDic != nil) {
                    print(responseDic!)
                    AlertView.showCustomAlertWithMessage(message: responseDic?.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
                }
            }
        }*/
        
        let urlRequest = URLRequest(url: URL(string: ServerConstants.URL_LEAD_DATA)!)
        let urlString = urlRequest.url?.absoluteString
        
        let headersDict: HTTPHeaders = [
            "X-APPKEY":"jludmkiswzxmrdf3qewfuhasqrcmdjoqply",
            "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"
        ]
        
        Alamofire.request(urlString!, method: .post, parameters: paramDict, encoding: URLEncoding.httpBody, headers: headersDict).responseJSON { (response) in
            print(response.result)
            let responseDic =  response.result.value as! NSDictionary
            if(responseDic.object(forKey: "code") as! NSNumber  == 401){
                AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey: "message") as! String, yPos: 20, duration: 5)
                self.moveToLoginScreen()
            }
            else if(responseDic.object(forKey: "code") as! NSNumber  == 200){

//            if(responseDic.object(forKey:"code") as! NSNumber == 200){
                showAlertWithTitle(title: "", message: responseDic.object(forKey: "message") as! String, forTarget: self, buttonOK: "", buttonCancel:"OK", alertOK: { (String) in
                }, alertCancel: { (Void) in
                    self.performSegue(withIdentifier: "showHomePage", sender: nil)
                    self.moveToDashBoard()
                })
            }
            else{
                AlertView.showCustomAlertWithMessage(message: responseDic.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageTxtView.layer.borderColor = UIColor.lightGray.cgColor
        self.messageTxtView.layer.borderWidth = 1
        self.messageTxtView.layer.cornerRadius = 5
        
        self.submitButton.layer.cornerRadius = 5
        
        studioNameTxtField.keyboardType = .namePhonePad
        locationTxtField.keyboardType = .namePhonePad
        contactPersonTxtField.keyboardType = .namePhonePad
        emailTxtield.keyboardType = .emailAddress
        mobileNumberTxtField.keyboardType = .numberPad
        messageTxtView.keyboardType = .namePhonePad
        
        submitButton.addTarget(self, action: #selector(sendPartnerRequest), for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
