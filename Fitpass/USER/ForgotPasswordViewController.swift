//
//  ForgotPasswordViewController.swift
//  Fitpass
//
//  Created by Quantela on 17/12/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: DesignableUITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        self.emailTextField.resignFirstResponder()
        if isValidEmail(){
            ProgressHUD.showProgress(targetView: self.view)
            
            let parameters : Dictionary? = ["email" : emailTextField.text!]
            print("forgot password : \(ServerConstants.URL_FORGOT_PASSWORD)")
            
            NetworkManager.sharedInstance.getResponseForURLWithParameters(url: ServerConstants.URL_FORGOT_PASSWORD, userInfo: parameters as NSDictionary?, type: "POST", completion: { (data, response, error) in
                
                ProgressHUD.hideProgress()
                
                if error == nil {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDict:NSDictionary? = jsonObject as? NSDictionary
                    print(responseDict!)
                    self.dismiss(animated: true, completion: nil)
                    AlertView.showCustomAlertWithMessage(message: responseDict!.object(forKey: "message") as! String, yPos: 20, duration: NSInteger(2.0))
                }
                else{
                    let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let responseDict:NSDictionary? = jsonObject as? NSDictionary
                    print(responseDict!)
                    AlertView.showCustomAlertWithMessage(message: StringFiles().FORGOTPASSWORDFAILMESSAGE, yPos: 20, duration: NSInteger(2.0))
                }
            })
        }
    }
    
    @IBAction func backToLoginClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isValidEmail() -> Bool {
        var isValidUser = false
        if !isInternetAvailable() {
            AlertView.showCustomAlertWithMessage(message: StringFiles().CONNECTIONFAILUREALERT, yPos: 20, duration: NSInteger(2.0))
        } else if (!Utility().isValidEmail(testStr: self.emailTextField.text! as String)) {
            
            AlertView.showCustomAlertWithMessage(message: StringFiles().INVALIDEMAILID, yPos: 20, duration: NSInteger(2.0))
        } else {
            isValidUser = true
        }
        return isValidUser
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
