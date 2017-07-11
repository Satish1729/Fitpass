//
//  LoginViewController.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var emailIdTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateCornorLayouts()
        
        self.emailIdTxt.borderStyle = .roundedRect
        self.passwordTxt.borderStyle = .roundedRect
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.emailIdTxt.text = ""//"chiranjeevi@irinnovative.com"
        self.passwordTxt.text = ""//"123456"
    }
    
    func updateCornorLayouts() {
        
        self.signInBtn.layer.cornerRadius = 5.0
        self.signInBtn.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideTextFields() {
        self.emailIdTxt.resignFirstResponder()
        self.passwordTxt.resignFirstResponder()
    }
    
    //MARK: SignIn
    @IBAction func signInBtnAction(_ sender: Any) {
        self.hideTextFields()
        if isValidEmailAndPassword() {
            
            ProgressHUD.showProgress(targetView: self.view)
            
            let email = self.emailIdTxt.text
            let password = self.passwordTxt.text
            let parameters : [String : Any] = ["email" : email!, "password" : password!]

            print("URL : \(ServerConstants.URL_LOGIN)\n parameters :  \(parameters)" as Any)
            
            NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_LOGIN, userInfo: parameters as NSDictionary?, type: "POST", completion: { (data, response, error) in
                
                ProgressHUD.hideProgress()
                
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDict:NSDictionary? = jsonObject as? NSDictionary
                    print(responseDict!)
                    
                    let jsonResponseDict: NSDictionary = responseDict!.object(forKey: "data") as! NSDictionary
                    
                    UserBean().updateUserBean(responseDict: jsonResponseDict)
                    
                    var userDet = [UserBean]()
                    userDet.append(appDelegate.userBean!)
                    let encodeUserBean = NSKeyedArchiver.archivedData(withRootObject: userDet)
                    UserDefaults.standard.set(encodeUserBean, forKey: "userBean")
                    
//                    UserDefaults.standard.set(userDet, forKey: "userBean")
                    self.performSegue(withIdentifier: "showCustomVC", sender: self)
                    
                }
                else{
                    print("Device registration failed : \(String(describing: error?.localizedDescription))")
                    AlertView.showCustomAlertWithMessage(message: StringFiles().LOGIN_FAILED, yPos: 20, duration: NSInteger(2.0))
                }
            })
        }
    }
    
    //MARK: Forgot Password
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        
        self.hideTextFields()
        
        showAlertWithTextFieldAndTitle(title: StringFiles().FORGOTPASSWORDTITLE, message: StringFiles().FORGOTPASSWORDMESSAGE, forTarget: self, buttonOK: StringFiles().SEND, buttonCancel: StringFiles().CANCEL, textPlaceholder: StringFiles().EMAIL_ID, alertOK: { (emailId:String) in
            print("email id : \(emailId)")
            
            if !isInternetAvailable() {
                AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
                return;
            }
            
            ProgressHUD.showProgress(targetView: self.view)
            
            let parameters : Dictionary? = ["email" : emailId]
            print("forgot password : \(ServerConstants.URL_FORGOT_PASSWORD)")
            
            NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_FORGOT_PASSWORD, userInfo: parameters as NSDictionary?, type: "POST", completion: { (data, response, error) in
                
                ProgressHUD.hideProgress()
                
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDict:NSDictionary? = jsonObject as? NSDictionary
                    print(responseDict!)
                    AlertView.showCustomAlertWithMessage(message: StringFiles().FORGOTPASSWORDMESSAGE, yPos: 20, duration: NSInteger(2.0))
                }
                else{
                    print("Device registration failed : \(String(describing: error?.localizedDescription))")
                    AlertView.showCustomAlertWithMessage(message: StringFiles().FORGOTPASSWORDFAILMESSAGE, yPos: 20, duration: NSInteger(2.0))
                }
            })
        }) { Void in}
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    //MARK: Validations
    func isValidEmailAndPassword() -> Bool {
        
        var isValidUser = false
        
        if !isInternetAvailable() {
            
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
            
        } else if (emailIdTxt.text?.characters.count == 0 && passwordTxt.text?.characters.count == 0) {
            
            AlertView.showCustomAlertWithMessage(message: StringFiles().EMPTYLOGINCREDENTIALS, yPos: 20, duration: NSInteger(2.0))
            
        } else if (!Utility().isValidEmail(testStr: emailIdTxt.text! as String)) {
            
            AlertView.showCustomAlertWithMessage(message: StringFiles().INVALIDEMAILID, yPos: 20, duration: NSInteger(2.0))
            
        } else {
            
            isValidUser = true
            
        }
        
        return isValidUser
    }
}
