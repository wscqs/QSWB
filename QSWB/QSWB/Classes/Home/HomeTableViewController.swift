//
//  HomeTableViewController.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/27.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.如果没有登录, 就设置未登录界面的信息
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        
        // 2.初始化导航条
        setupNav()
    }
    
    func setupNav() {
        // 1.初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(HomeTableViewController.leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(HomeTableViewController.rightItemClick))
        
        // 2.初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("极客江南 ", forState: UIControlState.Normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.titleView = titleBtn;
    }
    
    func titleBtnClick(btn: TitleButton) {
        btn.selected = !btn.selected
    }
    
    func leftItemClick()
    {
        print(#function)
    }
    
    func rightItemClick()
    {
        print(#function)
    }


}
