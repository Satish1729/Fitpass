//
//  BaseViewController.swift
//  Fitpass
//
//  Created by SatishMac on 26/04/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import SideMenuController

class BaseViewController: UIViewController, SideMenuControllerDelegate {

    @IBOutlet weak var sideMenuBarButton: UIBarButtonItem!
    
    @IBOutlet weak var borderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        sideMenuController?.delegate = self
        
        self.borderView?.layer.borderWidth = 1.0
        self.borderView?.layer.borderColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1.0).cgColor
        self.borderView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.borderView?.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.borderView?.layer.shadowOpacity = 1.0
        self.borderView?.layer.shadowRadius = 0.0
        self.borderView?.layer.masksToBounds = false
        self.borderView?.layer.cornerRadius = 1.0

    }
    func setRedColorForStar(str:String) -> NSMutableAttributedString{
        let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.red]
        let myAttribute1 = [ NSFontAttributeName: UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.black]
        let valueString = NSMutableAttributedString(string:" *", attributes: myAttribute )
        let myString = NSMutableAttributedString(string: str, attributes: myAttribute1 )
        myString.append(valueString)
        
        return myString
    }

    var randomColor: UIColor {
        let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                      UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                      UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                      UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
        
        let index = Int(arc4random_uniform(UInt32(colors.count)))
        return colors[index]
    }

    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
    }

    func createURLFromParameters(parameters: [String:Any]) -> URL {
        
        var components = URLComponents()
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    func callTheNumber(numberString : String){
        if let url = URL(string: "tel://\(numberString)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func sendMailTo(mailString : String){
        if let url = URL(string: "mailto:\(mailString)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func moveToDashBoard(){
        sideMenuController?.performSegue(withIdentifier: "showDashBoardVC", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
