//
//  BaseTableViewController.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/29.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var userLogin = false
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    ///设置未登录用户的视图
    func setupVisitorView() {
        let customView = VisitorView()
//        customView.backgroundColor = UIColor.blueColor()
        view = customView
    }
}
