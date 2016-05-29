//
//  UIBarButtonItem+Category.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/29.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    class func createBarButtonItem(imageName: String, target: AnyObject?, action: Selector)-> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        btn.sizeToFit()
        return UIBarButtonItem(customView: btn)
    }
}
