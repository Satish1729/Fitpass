//
//  AlertController.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import Foundation

class AlertController {
    static let sharedInstance = AlertController()
}


func showAlertWithTitle(title:String,message:String,forTarget:AnyObject,buttonOK:String,buttonCancel:String,alertOK:@escaping (String)->(),alertCancel:@escaping (Void)->()){
    
    let alertController:UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    
    if buttonCancel.characters.count > 0 {
        let cancelAction:UIAlertAction = UIAlertAction.init(title: buttonCancel, style: .default, handler: { UIAlertAction in
            alertCancel()
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
    }
    
    if buttonOK.characters.count > 0 {
        let OKButtonAction:UIAlertAction  = UIAlertAction.init(title: buttonOK, style: .default, handler: { UIAlertAction in
            alertOK("OK")
        })
        
        alertController .addAction(OKButtonAction)
    }
    
    forTarget.present(alertController, animated: true, completion: nil)
    //    alertController.view.tintColor = themeOrangeColor
    
}

func showAlertWithTextFieldAndTitle(title:String, message: String, forTarget: AnyObject, buttonOK:String, buttonCancel:String, isEmail:Bool, textPlaceholder:String, alertOK: @escaping (String)->(), alertCancel: @escaping (Void)->()) {
    
    let alertController:UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    
    if buttonCancel.characters.count > 0 {
        let cancelAction:UIAlertAction = UIAlertAction.init(title: buttonCancel, style: .default, handler: { UIAlertAction in
            alertCancel()
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(cancelAction)
    }
    
    //    if buttonOK.characters.count > 0 {
    let OKButtonAction:UIAlertAction  = UIAlertAction.init(title: buttonOK, style: .default, handler: { UIAlertAction in
        let textField = alertController.textFields![0] as UITextField
        alertOK(textField.text!)
    })
    OKButtonAction.isEnabled = false
    alertController .addAction(OKButtonAction)
    //    }
    
    alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
        textField.placeholder = textPlaceholder
        if(isEmail){
            textField.keyboardType = .emailAddress
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                OKButtonAction.isEnabled = Utility().isValidEmail(testStr: textField.text!) &&  ((textField.text?.characters.count)! > 0)
            }
        }else{
            textField.keyboardType = .default
            OKButtonAction.isEnabled = true
        }
        
    })
    
    forTarget.present(alertController, animated: true, completion: nil)
}


