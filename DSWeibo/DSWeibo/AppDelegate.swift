//
//  AppDelegate.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/7.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        print(UserAccount.loadAccount())
        
        // 设置导航条和工具条的外观
        // 因为外观一旦设置全局有效, 所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        // 2.创建根控制器
        window?.rootViewController = WelcomeViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

