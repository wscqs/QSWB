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
        // 1.切换导航标题的图标
        btn.selected = !btn.selected
        
        // 2.实现popView
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        //设置modal转场,为了能显示底部视图
        vc?.transitioningDelegate = self
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
        
    }
    
    func leftItemClick()
    {
        print(#function)
    }
    
    func rightItemClick()
    {
        print(#function)
    }
    // 记录当前是否是展开
    var isPresent: Bool = false


}


extension HomeTableViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
     func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    /**
     告诉系统谁来负责Modal的展现动画
     
     :param: presented  被展现视图
     :param: presenting 发起的视图
     :returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        return self
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        
        if isPresent{
            // 展开
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            toView.transform = CGAffineTransformMakeScale(1.0, 0)
            
            // 注意： 一定要将视图添加到容器
            transitionContext.containerView()?.addSubview(toView)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            
            // 2.执行动画
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                // 2.1清空transform
                toView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                // 2.2动画执行完毕, 一定要告诉系统
                // 如果不写, 可能导致一些未知错误
                transitionContext.completeTransition(true)
            }
        }else
        {
            // 关闭
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                // 注意:由于CGFloat是不准确的, 所以如果写0.0会没有动画
                // 压扁
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    // 如果不写, 可能导致一些未知错误
                    transitionContext.completeTransition(true)
            })
        }
    }
    
}
