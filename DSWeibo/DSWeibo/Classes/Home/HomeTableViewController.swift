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
        
        // 注册两个cell
        tableView.registerClass(StatusNormalTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(StatusForwardTableViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentifier.ForwardCell.rawValue)
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // 4.加载微博数据
        loadData()
    }
    deinit
    {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     获取微博数据
     */
    private func loadData()
    {
        Status.loadStatuses { (models, error) -> () in
            
            if error != nil
            {
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
        // 2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        // 2.1设置转场代理
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
    
    /// 微博行高的缓存, 利用字典作为容器. key就是微博的id, 值就是对应微博的行高
    var rowCache: [Int: CGFloat] = [Int: CGFloat]()
    
    override func didReceiveMemoryWarning() {
        // 清空缓存
        rowCache.removeAll()
    }
}

extension HomeTableViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statuses![indexPath.row]
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status), forIndexPath: indexPath) as! StatusTableViewCell
        // 2.设置数据
        cell.status = status
        
        // 3.返回cell
        return cell
    }
    
    
    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 1.取出对应行的模型
        let status = statuses![indexPath.row]
        
        // 2.判断缓存中有没有
        if let height = rowCache[status.id]
        {
            return height
        }
        
        // 3.拿到cell
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusTableViewCellIdentifier.cellID(status)) as! StatusTableViewCell
        
        // 4.拿到对应行的行高
        let rowHeight = cell.rowHeight(status)
        
        // 5.缓存行高
        rowCache[status.id] = rowHeight
        
        // 6.返回行高
        return rowHeight
    }
}
