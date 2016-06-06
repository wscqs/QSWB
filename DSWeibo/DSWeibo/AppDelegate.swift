//
//  AppDelegate.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/7.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit

// 切换控制器通知
let XMGSwitchRootViewControllerKey = "XMGSwitchRootViewControllerKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        print(UserAccount.loadAccount())
        
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchRootViewController:", name: XMGSwitchRootViewControllerKey, object: nil)
        
        // 设置导航条和工具条的外观
        // 因为外观一旦设置全局有效, 所以应该在程序一进来就设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 1.创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        // 2.创建根控制器
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        
        print(isNewupdate())
        return true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func switchRootViewController(notify: NSNotification){
        //        print(notify.object)
        if notify.object as! Bool
        {
            window?.rootViewController = MainViewController()
        }else
        {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    /**
     用于获取默认界面
     
     :returns: 默认界面
     */
    private func defaultController() -> UIViewController{
        if UserAccount.userLogin(){
            return isNewupdate() ? NewfeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    private func isNewupdate() -> Bool{
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        
        //        var temp = nil ?? "123"
        //        print(temp)
        
        print("current = \(currentVersion) sandbox = \(sandboxVersion)")
        
        // 3.比较当前版本号和以前版本号
        //   2.0                    1.0
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending
        {
            // 3.1如果当前>以前 --> 有新版本
            // 3.1.1存储当前最新的版本号
            // iOS7以后就不用调用同步方法了
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        // 3.2如果当前< | ==  --> 没有新版本
        return false
    }
    
    

}

