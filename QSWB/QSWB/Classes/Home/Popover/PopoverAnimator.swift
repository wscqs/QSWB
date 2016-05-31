//
//  PopoverAnimator.swift
//  QSWB
//
//  Created by mba on 16/5/31.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    
    var isPresent: Bool = false
    /// 定义属性保存菜单的大小
    var presentFrame = CGRectZero

    
    // 实现代理方法, 告诉系统谁来负责转场动画
    // UIPresentationController iOS8推出的专门用于负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController?{
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        // 设置菜单的大小
        pc.presentFrame = presentFrame
        return pc
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
