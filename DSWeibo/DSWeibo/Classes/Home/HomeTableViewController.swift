//
//  HomeTableViewController.swift
//  DSWeibo
//
//  Created by xiaomage on 15/9/7.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import SVProgressHUD

let XMGHomeReuseIdentifier = "XMGHomeReuseIdentifier"
class HomeTableViewController: BaseTableViewController {

    /// 保存微博数组
    var statuses: [Status]?
        {
        didSet{
            // 当别人设置完毕数据, 就刷新表格
            tableView.reloadData()
        }
    }
    
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
        
        // 3.注册通知, 监听菜单
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: XMGPopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: XMGPopoverAnimatorWilldismiss, object: nil)
        
        // 注册一个cell
        tableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: XMGHomeReuseIdentifier)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        
        // 4.加载微博数据
        loadData()
    }
    deinit
    {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    private func loadData(){
        Status.loadStatus { (models, error) in
            if error != nil{
                return
            }
            
            self.statuses = models
        }
    }
    /**
    修改标题按钮的状态
    */
    func change(){
        // 修改标题按钮的状态
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    /**
    初始化导航条
    */
    private func setupNav()
    {
        // 1.初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        // 2.初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("极客江南 ", forState: UIControlState.Normal)        
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    func titleBtnClick(btn: TitleButton)
    {
        // 1.修改箭头方向
//        btn.selected = !btn.selected
        
        // 2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        // 2.1设置转场代理
        // 默认情况下modal会移除以前控制器的view, 替换为当前弹出的view
        // 如果自定义转场, 那么就不会移除以前控制器的view
//        vc?.transitioningDelegate = self
        vc?.transitioningDelegate = popverAnimator
        
        // 2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc!, animated: true, completion: nil)
        
    }
    
    func leftItemClick()
    {
        print(__FUNCTION__)
    }
    
    func rightItemClick()
    {
//        print(__FUNCTION__)
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }

    // MARK: - 懒加载
    // 一定要定义一个属性来报错自定义转场对象, 否则会报错
    private lazy var popverAnimator:PopoverAnimator = {
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
}

extension HomeTableViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(XMGHomeReuseIdentifier, forIndexPath: indexPath) as! StatusTableViewCell
        // 2.设置数据
//        let status = statuses![indexPath.row]
//        cell.textLabel?.text = status.text
        cell.status = statuses![indexPath.row]
        // 3.返回cell
        return cell
    }
}