//
//  Status.swift
//  LintTe
//
//  Created by WangHao on 16/6/6.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import Foundation

class Status: NSObject {
    // 微博创建时间
    var created_at: String!
    // 字符型微博ID
    var idstr: String!
    // 微博MID
    var mid: Int64 = 0
    // 微博信息内容
    var text: String?
    // 微博来源
    var source: String?
//    var favorited: Bool = false              //是否已收藏，true：是，false：否
//    var truncated: Bool = false              //是否被截断，true：是，false：否
//    var in_reply_to_status_id: String = ""   //（暂未支持）回复ID
//    var in_reply_to_user_id: String = ""     //（暂未支持）回复人UID
//    var in_reply_to_screen_name: String = "" //（暂未支持）回复人昵称
//    var thumbnail_pic: NSURL?                //缩略图片地址，没有时不返回此字段
//    var bmiddle_pic: NSURL?                  //中等尺寸图片地址，没有时不返回此字段
//    var original_pic: NSURL?                 //原始图片地址，没有时不返回此字段
//    var geo: AnyObject? = nil                //地理信息字段 详细
    // 微博作者的用户信息字段 详细
    var user: User!
//    var retweeted_status: Status? = nil      //被转发的原微博信息字段，当该微博为转发微博时
    // 转发数
    var reposts_count = 0
    // 评论数
    var comments_count = 0
    // 表态数
    var attitudes_count = 0
//    var mlevel: Int = 0                      //暂未支持
//    var visible: AnyObject?                  //微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
//    var pic_ids: AnyObject?                  //微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
    
    // MARK: - 初始化方法
    init(dict: [String: AnyObject]) {

        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // 对找不到的不处理
    override func setValue(value: AnyObject?, forUndefinedKey key: String) { }
    // KVC的setValuesForKeysWithDictionary()方法内部调用的是setValue()方法
    override func setValue(value: AnyObject?, forKey key: String) {
        // 1.拦截key == "user"的赋值
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        // 2.其他的继续父类方法
        super.setValue(value, forKey: key)
    }
    
    /// Description
    override var description: String {
        let keys = ["created_at", "idstr", "user", "mid", "reposts_count", "comments_count", "attitudes_count"]
        let dict = dictionaryWithValuesForKeys(keys)
        return "\(dict)"
    }

    
}