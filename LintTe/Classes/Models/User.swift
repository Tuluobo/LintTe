//
//  User.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import Foundation

class User: NSObject {

    // 用户UID
    var idstr: String!
    // 用户昵称
    var screen_name: String?
    // 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    // 是否是微博认证用户，即加V用户，true：是，false：否
    var verified = false
    // 认证类型 -1：未认证，0：认证用户，2，3，5：企业认证，220：达人
    var verified_type = -1
    // 会员类型
    var mbtype = -1
    // 会员等级 1-6 是会员
    var mbrank = 0
    // 粉丝数
    var followers_count = 0
    // 关注数
    var friends_count = 0
    // 微博数
    var statuses_count = 0
    // 收藏数
    var favourites_count = 0
    // 用户头像地址（大图），180×180像素
    var avatar_large: String?
    // 用户头像地址（高清），高清头像原图
    var avatar_hd: String?
    // 认证原因
    var verified_reason: String?

//    var province: Int?               //用户所在省级ID
//    var city: Int?                   //用户所在城市ID
//    var location: String?            //用户所在地
//    var descriptions: String?         //用户个人描述
//    var url: NSURL?                  //用户博客地址
//    var profile_url: NSURL?          //用户的微博统一URL地址
//    var domain: String?              //用户的个性化域名
//    var weihao: String?              //用户的微号
//    var gender: String = "未知"       //性别，m：男、f：女、n：未知
//    var created_at: String?          //用户创建（注册）时间
//    var following: Bool = false      //暂未支持
//    var allow_all_act_msg: Bool = false//是否允许所有人给我发私信，true：是，false：否
//    var geo_enabled: Bool = false    //是否允许标识用户的地理位置，true：是，false：否
//    var remark: String?              //用户备注信息，只有在查询用户关系时才返回此字段
//    //var status: Weibo?               //用户的最近一条微博信息字段 详细
//    var allow_all_comment: Bool = true//是否允许所有人对我的微博进行评论，true：是，false：否
//    var follow_me: Bool = false      //该用户是否关注当前登录用户，true：是，false：否
//    var online_status: Int = 0       //用户的在线状态，0：不在线、1：在线
//    var bi_followers_count: Int = 0  //用户的互粉数
//    var lang: String = "zh-cn"       //用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
    
    // MARK: - 初始化方法
    init(dict: [String: AnyObject]) {

        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // 对找不到的不处理
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    
    override var description: String {
        let keys = ["idstr", "screen_name", "profile_image_url", "verified_type", "verified_reason", "followers_count", "friends_count", "statuses_count"]
        let dict = dictionaryWithValuesForKeys(keys)
        return "\(dict)"
    }

}