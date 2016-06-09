//
//  NetworkManager.swift
//  LintTe
//
//  Created by WangHao on 16/6/4.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkManager: AFHTTPSessionManager {
    
    // Swift 建议我们这样书写单例
    static let shareInstance: NetworkManager = {
        // 单例实现
        // 注意：baseUrl 后面一定要添加"/"
        let baseUrl = NSURL(string: WeiBoURL.weiboBaseUrl)
        let instance = NetworkManager(baseURL: baseUrl, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        /// 这里在AFNetworking框架中没有设置，如果返回的数据类型为 'text/plain',将会出现错误
        // 这样就需要设置这个参数
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/plain") as? Set<String>
        return instance
    }()
    
    
    func loadStatuses(finished: (array: [[String: AnyObject]]?, error: NSError?) -> ()) {
        // 断言
        assert(UserAccount.userAccount != nil, "此方法必须授权调用")
        // 1.准备参数
        let parameters:[String: AnyObject] = ["access_token": UserAccount.userAccount!.access_token!]
        TTLog(parameters)
        // 2.发送GET
        GET(WeiBoURL.weiboHomeTimeLine, parameters: parameters, success: { (_, data) in
            
            // 对获取的数据处理
            guard let array = (data as? [String: AnyObject]) where array["statuses"] != nil else {
                finished(array: nil, error: NSError(domain: "com.tuluobo.error", code: 999, userInfo: ["message": "没有微博数据"]))
                return
            }
            finished(array: array["statuses"] as? [[String: AnyObject]], error: nil)
        }) { (_, error) in
            // 错误处理
            finished(array: nil, error: error)
        }
    }
    
    
}
