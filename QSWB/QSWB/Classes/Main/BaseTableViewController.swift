//
//  BaseTableViewController.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/29.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {

    var userLogin = false
    
    //定义属性保存visitorView
    var visitorView: VisitorView?
    
    override func loadView() {
        userLogin ? super.loadView() : setupVisitorView()
    }
    
    ///设置未登录用户的视图
    func setupVisitorView() {
        let customView = VisitorView()
        customView.delegate = self
        view = customView
        visitorView = customView
        
        // 2.设置导航条未登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.registerBtnWillClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.loginBtnWillClick))
        
    }
    
    
    //MARK: visitorViewDelegate
    func registerBtnWillClick() {
        print(#function)
        print(UserAccount.loadAccount())
    }
    func loginBtnWillClick() {
        print(#function)
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        presentViewController(nav, animated: true, completion: nil)
    }
}
