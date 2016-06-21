//
//  HomeRefreshControl.swift
//  DSWeibo
//
//  Created by mba on 16/6/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        setupUI()
    }
    
    private func setupUI()
    {
        // 1.添加子控件
        addSubview(refreshView)
        
        // 2.布局子控件
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
        
        
        /*
         1.当用户下拉到一定程度的时候需要旋转箭头
         2.当用户上推到一定程度的时候需要旋转箭头
         3.当下拉刷新控件触发刷新方法的时候, 需要显示刷新界面(转轮)
         
         通过观察:
         越往下拉: 值就越小
         越往上推: 值就越大
         */
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    /// 定义变量记录是否需要旋转监听
    private var rotationArrowFlag = false
    /// 定义变量记录当前是否正在执行圈圈动画
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame.origin.y >= 0{
            return
        }
        
        if refreshing && !loadingViewAnimFlag{
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startLoadingViewAnim()
            return
        }
        if frame.origin.y >= -50 && rotationArrowFlag
        {
            print("翻转回来")
            rotationArrowFlag = false
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
            print("翻转")
            rotationArrowFlag = true
            refreshView.rotaionArrowIcon(rotationArrowFlag)
        }

        
    }
    override func endRefreshing() {
        super.endRefreshing()
        
        // 关闭圈圈动画
        refreshView.stopLoadingViewAnim()
        
        // 复位圈圈动画标记
        loadingViewAnimFlag = false
    }
    
    // MARK: - 懒加载
    private lazy var refreshView : HomeRefreshView =  HomeRefreshView.refreshView()
    
    deinit
    {
        removeObserver(self, forKeyPath: "frame")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class HomeRefreshView: UIView {
    
    @IBOutlet weak var arrowIcon: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var loadingView: UIImageView!
    
    class func refreshView() -> HomeRefreshView {
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
    }
    
    /**
     旋转箭头
     */
    func rotaionArrowIcon(flag: Bool)
    {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    /**
     *  开始圈圈动画
     */
    func startLoadingViewAnim() {
        tipView.hidden = true
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        anim.removedOnCompletion = false
        loadingView.layer.addAnimation(anim, forKey: nil)
    }
    
    func stopLoadingViewAnim() {
        tipView.hidden = false
        loadingView.layer.removeAllAnimations()
    }
}
