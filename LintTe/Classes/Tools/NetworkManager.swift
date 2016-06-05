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
    
    
}
