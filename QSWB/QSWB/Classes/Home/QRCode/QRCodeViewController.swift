//
//  QRCodeViewController.swift
//  QSWB
//
//  Created by mba on 16/5/31.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,UITabBarDelegate{

    /// 扫描容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 冲击波视图顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    @IBAction func closeBtnClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var customTabBar: UITabBar!
    
    
    /// 保存扫描到的结果
    @IBOutlet weak var resultLabel: UILabel!
    
    
    /**
     监听名片按钮点击
     */
    @IBAction func myCardBtnClick(sender: AnyObject) {
        
        let vc = QRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: lift
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 1.开始冲击波动画
        startAnimation()
        
        // 2.开始扫描
        startScan()
    }
    
    func startScan() {
        
        // 1.判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput)
        {
            return
        }
        // 2.判断是否能够将输出添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.将输入和输出都添加到会话中
        session.addInput(deviceInput)
        print(output.availableMetadataObjectTypes)
        session.addOutput(output)
        print(output.availableMetadataObjectTypes)
        
        // 4.设置输出能够解析的数据类型
        // 注意: 设置能够解析的数据类型, 一定要在输出对象添加到会员之后设置, 否则会报错
        output.metadataObjectTypes =  output.availableMetadataObjectTypes
        print(output.availableMetadataObjectTypes)
        // 5.设置输出对象的代理, 只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 添加绘制图层到预览图层上
        previewLayer.addSublayer(drawLayer)

        
        // 6.告诉session开始扫描
        session.startRunning()
    }
    
    func startAnimation() {
        self.scanLineCons.constant = -self.containerHeightCons.constant
        self.scanLineView.layoutIfNeeded()
        
        // 执行冲击波动画
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            // 1.修改约束
            self.scanLineCons.constant = self.containerHeightCons.constant
            // 设置动画指定的次数
            UIView.setAnimationRepeatCount(MAXFLOAT)
            // 2.强制更新界面
            self.scanLineView.layoutIfNeeded()
        })
    }

    // MARK: tabbarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1{
            self.containerHeightCons.constant = 300
        }else{
            self.containerHeightCons.constant = 100
        }
        
        self.scanLineView.layer.removeAllAnimations()
        
        startAnimation()
        
    }
    
    
    // MARK: 懒加载
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    // 输出设备
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate{
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        // 0.清空图层
        clearConers()
        
        resultLabel.text = metadataObjects.last?.stringValue
        resultLabel.sizeToFit()
        
        for object in metadataObjects{
            if object is AVMetadataMachineReadableCodeObject{
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                drawCorners(codeObject)
            }
        }
    }
    
    func drawCorners(codeObject: AVMetadataMachineReadableCodeObject) {
        if codeObject.corners.isEmpty{
            return
        }
        
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        while index < codeObject.corners.count {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        
        path.closePath()
        
        layer.path = path.CGPath
        
        drawLayer.addSublayer(layer)
        
        
    }
    
    private func clearConers(){
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0{
            return
        }
        
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }

}


