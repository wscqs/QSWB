//
//  PopoverPresentationController.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/29.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {

    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    /**
     初始化
     - parameter presentedViewController:  被展示的控制器
     - parameter presentingViewController: 要弹出的控制器
     - returns:
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    
    
    override func containerViewWillLayoutSubviews() {
        //containerView容器view
        //presentedView()显示view
        // 1.修改弹出视图的大小
        if presentFrame == CGRectZero{
            
            presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else
        {
            presentedView()?.frame = presentFrame
        }
        
        // 2.在容器视图上添加一个蒙版, 插入到展现视图的下面
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    /// 蒙层
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopoverPresentationController.clickClose)))
        
        return view
    }()
    
    func clickClose() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
