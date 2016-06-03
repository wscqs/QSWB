

import UIKit
import Alamofire

// Swift2.0 打印对象需要重写CustomStringConvertible协议中的description
class UserAccount: NSObject , NSCoding{
    /// 用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    /// access_token的生命周期，单位是秒数。
    
    var expires_in: NSNumber?{
        didSet{
            expires_Date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    /// 当前授权用户的UID。
    var uid:String?

    /// 保存用户过期时间
    var expires_Date: NSDate?
    
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?
    
    
    override init() {
        
    }
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    override var description: String{
        // 1.定义属性数组
        let properties = ["access_token", "expires_in", "uid", "expires_Date", "avatar_large", "screen_name"]
        // 2.根据属性数组, 将属性转换为字典
        let dict =  self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转换为字符串
        return "\(dict)"
    }
    
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?)-> ()) {
        assert(access_token != nil, "没有授权")
        
        let path = "https://api.weibo.com/2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]

        Alamofire.request(.GET, path, parameters: params).responseJSON { (response) in
            if let JSON = response.result.value as? [String: AnyObject]{
                print(JSON)
                self.screen_name = JSON["screen_name"] as? String
                self.avatar_large = JSON["avatar_large"] as? String
                
                finished(account: self, error: nil)
                return
            }
            
            finished(account: nil, error: response.result.error)
        }
    }
    
    class func userLogin() -> Bool{
        return UserAccount.loadAccount() != nil
    }
    
    // MARK: - 保存和读取  Keyed
    
    static let filePath = "account.plist".cacheDir()
    /**
     保存授权模型
     */
    func saveAccount()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /// 加载授权模型
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {
        
        // 1.判断是否已经加载过
        if account != nil
        {
            return account
        }
        // 2.加载授权模型
        account =  NSKeyedUnarchiver.unarchiveObjectWithFile("account.plist".cacheDir()) as? UserAccount
        
        // 3.判断授权信息是否过期
        // 2020-09-08 03:49:39                       2020-09-09 03:49:39
        if account?.expires_Date?.compare(NSDate()) == NSComparisonResult.OrderedAscending
        {
            // 已经过期
            return nil
        }
        
        return account
    }

    
    
    // MARK: - NSCoding
    // 将对象写入到文件中
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    // 从文件中读取对象
    required init?(coder aDecoder: NSCoder)
    {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name")  as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large")  as? String
    }
}
