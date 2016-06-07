//
//  UserAccount.swift
//  LintTe
//
//  Created by WangHao on 16/6/4.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {

    // 令牌
    var access_token: String?
    // 有效时间段（秒）
    var expires_in: Int = 0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    // 过期时间
    var expires_date: NSDate?
    // 用户ID
    var uid: String?
    // 用户昵称
    var screen_name: String?
    // 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    // MARK: - 初始化方法
    init(dict: [String: AnyObject]) {
        /**
         注意点
         1.如果要在初始化方法中使用KVC，必须先调用super.init()方法初始化对象
         2.如果属性是基本类型，那么建议不要使用可选类型，因为可选类型在初始化方法中不会分配内存
         */
        super.init()
        // key-value KVC
        // 注意点：字典与模型没一个字段一一对应
        // 如果没有一一对应情况，需要重写setValue(value: AnyObject?, forUndefinedKey key: String)方法
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // 对找不到的不处理
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    override var description: String {
        let keys = ["access_token", "expires_in", "expires_date", "uid"]
        let dict = dictionaryWithValuesForKeys(keys)
        return "\(dict)"
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in")
        self.expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    // MARK: - 外部控制方法
    /**
     归档
     - returns: 保存的结果
     */
    func saveAccount() -> Bool {
        // 归档对象
        UserAccount.userAccount = self
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountFilePath)
    }
    
    /**
        登录的同时请求用户的信息
     - parameter finished: 完成请求后保存数据
     */
    func loadUserInfo(finished: (userAccount: UserAccount?, error: NSError?)->()) {
        // 断言
        assert(access_token != nil, "access_token必须授权，才能加载用户信息")
        // 请求参数
        let parameters = [
            "access_token": access_token!,
            "uid": uid!,
        ]
        // 发送请求获取Access_token
        NetworkManager.shareInstance.GET(WeiBoURL.weiboUserUrl, parameters: parameters, success: { (_, data) in
            // 成功请求后处理
            
            let userDict = data as! [String:AnyObject]
            
            self.screen_name = userDict["screen_name"] as? String
            self.avatar_large = userDict["avatar_large"] as? String
            
            finished(userAccount: self, error: nil)
            
            }) { (_, error) in
                finished(userAccount: nil, error: error)
        }
    }
    
    // MARK: - 静态成员和类方法
    /// 返回的 userAccount 模型
    static var userAccount: UserAccount?
    static var accountFilePath: String {
        // 1.获取缓存路径
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        // 2.生成缓存文件路径
        let filePath = (path as NSString).stringByAppendingString("/userAccount.plist")
        
        TTLog(filePath)
        return filePath
    }
    /**
     加载归档模型
     
     - returns: 返回 UserAccount
     */
    class func loadUserAccount() -> UserAccount? {
        
        if UserAccount.userAccount != nil {
            return UserAccount.userAccount
        }
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountFilePath) as? UserAccount else { return UserAccount.userAccount }
        // 判断过期时间存在 和 过期时间对比
        guard let exp_date = account.expires_date where exp_date.compare(NSDate()) != NSComparisonResult.OrderedAscending else { return UserAccount.userAccount }
        UserAccount.userAccount = account
        return UserAccount.userAccount
    }
    
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
}