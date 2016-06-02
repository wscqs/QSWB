//
//  OAuthViewController.swift
//  QSWB
//
//  Created by mba on 16/6/2.
//  Copyright © 2016年 mbalib. All rights reserved.
//

import UIKit
import Alamofire

class OAuthViewController: UIViewController {

    let WB_App_Key = "2058474898"
    let WB_App_Secret = "a3ec3f8fa797fac21d702671a0cbfbf1"
    let WB_redirect_uri = "https://wscqs.github.io/"
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 0.初始化导航条
        navigationItem.title = "cqs微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(OAuthViewController.close))
        
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
    }()
}


extension OAuthViewController: UIWebViewDelegate{
    
    // 返回ture正常加载 , 返回false不加载
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        print(request.URL?.absoluteString)
        
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_redirect_uri)
        {
            // 继续加载
            return true
        }
        
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr)
        {
            // 授权成功
            // 1.取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        }else
        {
            // 取消授权
            // 关闭界面
            close()
        }
        
        return false
    }

    
    private func loadAccessToken(code: String){
//        let url = NSURL(string: "https://api.weibo.com/")
        let path = "oauth2/access_token"
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri]
        
        Alamofire.request(.POST,"https://api.weibo.com/"+path , parameters: params, encoding: ParameterEncoding.URL, headers: nil).responseJSON { (response) in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let account = UserAccount(dict: JSON as! [String : AnyObject])
                // 2.归档模型
                account.saveAccount()
                print(account)
            }
        }
        
    }
}
