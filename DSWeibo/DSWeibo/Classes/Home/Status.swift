//
//  Status.swift
//  DSWeibo
//
//  Created by mba on 16/6/6.
//  Copyright © 2016年 小码哥. All rights reserved.
//

import UIKit

class Status: NSObject {
    /// 微博创建时间
    var created_at: String?{
        didSet{
//                        created_at = "Sun Sep 12 14:50:57 +0800 2014"

            let createdDate = NSDate.dateWithStr(created_at!)
            created_at = createdDate.descDate
        }
    }
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?{
        didSet{
            // <a href=\"http://app.weibo.com/t/feed/4fuyNj\" rel=\"nofollow\">即刻笔记</a>
            
            if let str = source{
                let strNS = str as NSString
                let startLocation = strNS.rangeOfString(">").location + 1
                let length = strNS.rangeOfString("<", options: .BackwardsSearch).location - startLocation
                
                source = "来自:" + strNS.substringWithRange(NSMakeRange(startLocation, length))
            }
        }
    }
    /// 配图数组
    var pic_urls: [[String: AnyObject]]?
    
    /// 用户信息
    var user: User?
    
    class func loadStatus(finished: (models: [Status]?, error: NSError?) -> ()){
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token": UserAccount.loadAccount()!.access_token!]
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, success: { (_, JSON) -> Void in
            //            print(JSON)
            // 1.取出statuses key对应的数组 (存储的都是字典)
            // 2.遍历数组, 将字典转换为模型
            let models = dict2Model(JSON["statuses"] as! [[String: AnyObject]])
//                        print(models)
            // 2.通过闭包将数据传递给调用者
            finished(models: models, error: nil)
            
        }) { (_, error) -> Void in
            print(error)
            finished(models: nil, error: error)
        }
    }
    
    class func dict2Model(list: [[String: AnyObject]]) -> [Status]?{
        var models = [Status]()
        for dict in list{
            models.append(Status(dict: dict))
        }
        return models
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if "user" == key{
            user = User(dict: value as! [String : AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
}
