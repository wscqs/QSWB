//
//  MainViewController.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/27.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit



class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orangeColor()
        
        addChildViewControllers()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //添加加号按钮
        setupComposeBtn()
    }
    
    func composeBtnClick() {
        print(#function)
    }
    
    private func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
    }
    /**
     添加所有子控制器
     */
    private func addChildViewControllers() {
        //1.读取路径
        //2.通过文件路径创建nsdata
        //3.序列号json
        //4.遍历数组,设置数据
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        if let jsonPath = path{
            let jsonData = NSData(contentsOfFile: jsonPath)
            do{
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                for dict in dictArr as! [[String:String]]{
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            }catch{
                print(error)
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
            
        }
    }
    
    
    //MARK: - 增加子视图
    private func addChildViewController(childControllerString: String, title: String, imageName: String) {
        
        //动态获取命名空间
        let nameSpace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        let childVCString = nameSpace + "." + childControllerString
        let childVCName = NSClassFromString(childVCString) as! UIViewController.Type
        let childVC = childVCName.init()
        
        
        
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childVC.title = title
        let nav = UINavigationController()
        nav.addChildViewController(childVC)
        addChildViewController(nav)
    }
    
    //MARK: - 懒加载
    private lazy var composeBtn: UIButton = {
        let btn = UIButton()
        // 2.设置前景图片
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        // 3.设置背景图片
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        

        btn.addTarget(self, action: #selector(MainViewController.composeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()

}
