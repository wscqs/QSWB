//
//  VisitorView.swift
//  QSWB
//
//  Created by 陈秋松 on 16/5/29.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit
import SnapKit

protocol VisitorViewDelegate: NSObjectProtocol {
    func registerBtnWillClick()
    func loginBtnWillClick()
}

class VisitorView: UIView {
    
    weak var delegate: VisitorViewDelegate?

    func setupVisitorInfo(isHome: Bool, imageName: String, message: String) {
        
            iconView.hidden = !isHome
            homeIcon.image = UIImage(named: imageName)
            messageLabel.text = message
        
        if isHome{
            startAnimation()
        }
    }
    
    func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        
        //让动画不要移除
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.添加子控件
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        // 2.布局子控件
        iconView.snp_makeConstraints { make in
            make.center.equalTo(self)
        }
        maskBGView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
        }
        homeIcon.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        messageLabel.snp_makeConstraints { (make) in
            make.top.equalTo(iconView.snp_bottom)
            make.centerX.equalTo(iconView.snp_centerX)
            make.width.equalTo(224)
        }
        loginButton.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100,height: 30))
            make.top.equalTo(messageLabel.snp_bottom).offset(CGPoint(x: 0,y: 20))
            make.right.equalTo(messageLabel)
        }
        registerButton.snp_makeConstraints { (make) in
            make.size.equalTo(loginButton)
            make.top.equalTo(messageLabel.snp_bottom).offset(CGPoint(x: 0,y: 20))
            make.left.equalTo(messageLabel)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Action
    func loginBtnClick() {
//        print(#function)
        delegate?.loginBtnWillClick()
    }
    
    func registerBtnClick() {
//        print(#function)
        delegate?.registerBtnWillClick()
    }
    
    // MARK: - 懒加载控件
    /// 转盘
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    /// 图标
    private lazy var homeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    /// 文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.darkGrayColor()
        label.text = "打附加赛可垃圾分类考试的减肥了快速的减肥两款手机的两款手机立刻"
        return label
    }()
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(VisitorView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        btn.addTarget(self, action: #selector(VisitorView.registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var maskBGView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()
}
