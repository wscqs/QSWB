//
//  QRCodeViewController.swift
//  QSWB
//
//  Created by mba on 16/5/31.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController,UITabBarDelegate{

    /// 扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var customTabBar: UITabBar!
    
    // MARK: lift
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        startAnimation()
    }
    
    func startAnimation() {
        self.scanLineCons.constant = -self.containerHeightCons.constant
//        self.scanLineView.layoutIfNeeded()
        
        // 执行冲击波动画
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            // 1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            // 设置动画指定的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 2.强制更新界面
            self.scanLineView.layoutIfNeeded()
        })
    }

    // MARK: tabbarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1{
            self.containerHeightCons.constant = 300
        }else{
            self.containerHeightCons.constant = 100
        }
        
        self.scanLineView.layer.removeAllAnimations()
        
        startAnimation()
        
    }
    
}
