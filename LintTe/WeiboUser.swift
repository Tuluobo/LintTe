//
//  WeiboUser.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import Foundation

public struct WeiboUser: CustomStringConvertible {

    public var id: Int64!                   //用户UID
    public var screen_name: String          //用户昵称
    public var name: String                 //友好显示名称
    public var province: Int?               //用户所在省级ID
    public var city: Int?                   //用户所在城市ID
    public var location: String?            //用户所在地
    public var descriptions: String?         //用户个人描述
    public var url: NSURL?                  //用户博客地址
    public var profile_image_url: NSURL?	//用户头像地址（中图），50×50像素
    public var profile_url: NSURL?          //用户的微博统一URL地址
    public var domain: String?              //用户的个性化域名
    public var weihao: String?              //用户的微号
    public var gender: String = "未知"       //性别，m：男、f：女、n：未知
    public var followers_count: Int = 0     //粉丝数
    public var friends_count: Int = 0       //关注数
    public var statuses_count: Int = 0      //微博数
    public var favourites_count: Int = 0    //收藏数
    public var created_at: String?          //用户创建（注册）时间
    public var following: Bool = false      //暂未支持
    public var allow_all_act_msg: Bool = false//是否允许所有人给我发私信，true：是，false：否
    public var geo_enabled: Bool = false    //是否允许标识用户的地理位置，true：是，false：否
    public var verified: Bool = false       //是否是微博认证用户，即加V用户，true：是，false：否
    public var verified_type: Int = 0       //暂未支持
    public var remark: String?              //用户备注信息，只有在查询用户关系时才返回此字段
    public var status: AnyObject?           //用户的最近一条微博信息字段 详细
    public var allow_all_comment: Bool = true//是否允许所有人对我的微博进行评论，true：是，false：否
    public var avatar_large: NSURL?         //用户头像地址（大图），180×180像素
    public var avatar_hd: NSURL?            //用户头像地址（高清），高清头像原图
    public var verified_reason: String      //认证原因
    public var follow_me: Bool = false      //该用户是否关注当前登录用户，true：是，false：否
    public var online_status: Int = 0       //用户的在线状态，0：不在线、1：在线
    public var bi_followers_count: Int = 0  //用户的互粉数
    public var lang: String = "zh-cn"       //用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
    
    public var description: String {
        let v = verified ? " ✅" : ""
        return "@\(screen_name) (\(name))\(v)"
    }
    
    init?(data: NSDictionary?){
        self.following = false        //暂未支持
        self.verified_type = 0              //暂未支持
        
        let name = data?.valueForKey("name") as? String
        let screenName = data?.valueForKey("screen_name") as? String
        
        if name != nil && screenName != nil {
            self.name = name!
            self.screen_name = screenName!
            self.id = Int64((data?.valueForKey("id") as! NSNumber).intValue)
            self.province = Int((data?.valueForKey("province") as? NSNumber ?? 0).integerValue)
            self.city = Int((data?.valueForKey("city") as? NSNumber ?? 0).integerValue)
            self.location = data?.valueForKey("location") as? String
            self.descriptions = data?.valueForKey("description") as? String
            
            self.url = NSURL(string: (data?.valueForKey("url") as? String)!)
            self.profile_image_url = NSURL(string: (data?.valueForKey("profile_image_url") as? String)!)
            self.profile_url = NSURL(string: (data?.valueForKey("profile_url") as? String)!)
            self.domain = data?.valueForKey("domain") as? String
            self.weihao = data?.valueForKey("weihao") as? String
            self.gender = data?.valueForKey("gender") as? String ?? "未知"
            self.followers_count = Int((data?.valueForKey("followers_count") as! NSNumber).integerValue)
            self.friends_count = Int((data?.valueForKey("friends_count") as! NSNumber).integerValue)
            self.statuses_count = Int((data?.valueForKey("statuses_count") as! NSNumber).integerValue)
            self.favourites_count = Int((data?.valueForKey("favourites_count") as! NSNumber).integerValue)
            self.created_at = data?.valueForKey("created_at") as? String
            
            self.allow_all_act_msg = data?.valueForKey("allow_all_act_msg") as? Bool ?? true
            self.geo_enabled = data?.valueForKey("geo_enabled") as? Bool ?? false
            self.verified = data?.valueForKey("verified") as? Bool ?? false
            
            self.remark = data?.valueForKey("remark") as? String
            self.status = Weibo(data: data?.valueForKey("status") as? NSDictionary)
            self.allow_all_comment = data?.valueForKey("allow_all_comment") as? Bool ?? true
            self.avatar_large = NSURL(string: (data?.valueForKey("avatar_large") as? String)!)
            self.avatar_hd = NSURL(string: (data?.valueForKey("avatar_hd") as? String)!)
            self.verified_reason = (data?.valueForKey("verified_reason") as? String)!
            self.follow_me = data?.valueForKey("follow_me") as? Bool ?? false
            self.online_status = Int((data?.valueForKey("online_status") as! NSNumber).integerValue)
            self.bi_followers_count = Int((data?.valueForKey("bi_followers_count") as! NSNumber).integerValue)
            self.lang = data?.valueForKey("lang") as? String ?? "zh-cn"
        }else{
            return nil
        }
    }
}