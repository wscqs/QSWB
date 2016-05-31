//
//  QRCodeViewController.swift
//  QSWB
//
//  Created by mba on 16/5/31.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var customTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBar.selectedItem = customTabBar.items![0]

    }

    
    
}
