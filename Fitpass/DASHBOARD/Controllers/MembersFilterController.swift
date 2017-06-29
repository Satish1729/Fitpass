//
//  MembersFilterController.swift
//  Fitpass
//
//  Created by SatishMac on 29/05/17.
//  Copyright © 2017 Satish. All rights reserved.
//

import UIKit
import DropDown

class MembersFilterController: BaseViewController {
        
        var delegate : memberDelegate?
        
        @IBOutlet weak var subscriptionPlanButton: UIButton!
        
        @IBAction func searchButtonClicked(_ sender: Any) {
            self.dismissViewController()
            
            let tempDict : NSDictionary = ["plan" : subscriptionPlanButton.titleLabel?.text! ?? ""]
            delegate?.getFilterDictionary(searchDict: tempDict)
        }
        
        let dropDown = DropDown()
        
    override func viewDidLoad() {
            super.viewDidLoad()
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named : "img_back"), style: .plain, target: self, action: #selector(dismissViewController))
//            self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "img_back"), for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backBtn.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = item1

            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(clearFilterValues))
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
            
            
            dropDown.anchorView = self.subscriptionPlanButton
            dropDown.dataSource = ["Pearl Hart", "Gold Plan", "Silver Plan"]
            dropDown.direction = .any
            dropDown.width = 280
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.subscriptionPlanButton.setTitle(item, for: UIControlState.normal)
            }
            
            self.subscriptionPlanButton.addTarget(self, action: #selector(changeStatus), for: .touchUpInside)
        }
        
        func changeStatus() {
            self.dropDown.show()
        }
        
        func clearFilterValues () {
            self.dismissViewController()
            delegate?.clearFilter()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationItem.title = "Member Filter"
        }
        
        func dismissViewController() {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
}
