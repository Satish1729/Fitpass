//
//  FullImageViewController.swift
//  Fitpass
//
//  Created by Quantela on 05/01/18.
//  Copyright © 2018 Satish. All rights reserved.
//

import UIKit

class FullImageViewController: BaseViewController {

    var image: UIImage?
    @IBOutlet weak var fullImageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imagedata = image{
            fullImageView.image = imagedata
        }else{
            fullImageView.image = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
