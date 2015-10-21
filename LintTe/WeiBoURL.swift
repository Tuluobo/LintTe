//
//  WeiBoURL.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import Foundation

struct WeiBoURL {
    
    //获取当前登录用户及其所关注用户的最新微博
    static let weiboAllUrl = "https://api.weibo.com/2/statuses/home_timeline.json"
    //根据用户ID获取用户信息
    static let weiboUserUrl = "https://api.weibo.com/2/users/show.json"
    //根据微博ID获取单条微博内容
    static let weiboDetailUrl = "https://api.weibo.com/2/statuses/show.json"
    //获取某个用户最新发表的微博列表
    static let myWeibolListUrl = "https://api.weibo.com/2/statuses/user_timeline.json"
    
    //对一条微博进行评论
    static let commentWeiboUrl = "https://api.weibo.com/2/comments/create.json"
    //转发一条微博
    static let forwardWeiboUrl = "https://api.weibo.com/2/statuses/repost.json"

}