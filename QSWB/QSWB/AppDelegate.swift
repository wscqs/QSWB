//
//  AppDelegate.swift
//  QSWB
//
//  Created by mba on 16/5/27.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //新建窗口
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        return true
    }


}

