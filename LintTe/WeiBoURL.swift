//
//  WeiBoURL.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import Foundation

struct WeiBoURL {
    
    static let weiboBaseUrl = "https://api.weibo.com/"
    // 获取认证
    static let weiboAuthorize = "oauth2/authorize"
    static let weiboAccessToken = "oauth2/access_token"
    // 获取当前登录用户及其所关注用户的最新微博
    static let weiboAllUrl = "2/statuses/home_timeline.json"
    // 根据用户ID获取用户信息
    static let weiboUserUrl = "2/users/show.json"
    // 根据微博ID获取单条微博内容
    static let weiboDetailUrl = "2/statuses/show.json"
    // 获取某个用户最新发表的微博列表
    static let myWeibolListUrl = "2/statuses/user_timeline.json"
    
    // 对一条微博进行评论
    static let commentWeiboUrl = "2/comments/create.json"
    // 转发一条微博
    static let forwardWeiboUrl = "2/statuses/repost.json"

}