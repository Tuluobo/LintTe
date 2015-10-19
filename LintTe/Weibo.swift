//
//  Weibo.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import Foundation

public class Weibo: CustomStringConvertible {
    
    public var created_at: String                   //微博创建时间
    public var id: Int64?                           //微博ID
    public var mid: String                           //微博MID
    public var text: String                         //微博信息内容
    public var source: String?                       //微博来源
    public var favorited: Bool = false              //是否已收藏，true：是，false：否
    public var truncated: Bool = false              //是否被截断，true：是，false：否
    public var in_reply_to_status_id: String = ""   //（暂未支持）回复ID
    public var in_reply_to_user_id: String = ""     //（暂未支持）回复人UID
    public var in_reply_to_screen_name: String = "" //（暂未支持）回复人昵称
    public var thumbnail_pic: NSURL?                //缩略图片地址，没有时不返回此字段
    public var bmiddle_pic: NSURL?                  //中等尺寸图片地址，没有时不返回此字段
    public var original_pic: NSURL?                 //原始图片地址，没有时不返回此字段
    public var geo: AnyObject? = nil                //地理信息字段 详细
    public var user: WeiboUser                      //微博作者的用户信息字段 详细
    public var retweeted_status: AnyObject? = nil   //被转发的原微博信息字段，当该微博为转发微博时返回 详细
    public var reposts_count: Int = 0               //转发数
    public var comments_count: Int = 0              //评论数
    public var attitudes_count: Int = 0             //表态数
    public var mlevel: Int = 0                      //暂未支持
    public var visible: AnyObject?                  //微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
    public var pic_ids: AnyObject?                  //微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
    
    public var description: String {
        return "\(self.text)"
    }
    
    init?(data: NSDictionary?){
        self.visible = nil
        self.pic_ids = nil
        if let user = WeiboUser(data: data?.valueForKey("user") as? NSDictionary){
            self.user = user
            if let text = data?.valueForKey("text") as? String {
                self.text = text
                if let created_at = data?.valueForKey("created_at") as? String {
                    self.created_at = created_at
                    self.id = Int64((data?.valueForKey("id") as! NSNumber).longLongValue)
                    self.mid = (data?.valueForKey("mid") as? String)!
                    self.thumbnail_pic = NSURL(string: data?.valueForKey("thumbnail_pic") as? String ?? "")
                    self.bmiddle_pic = NSURL(string: data?.valueForKey("thumbnail_pic") as? String ?? "")
                    self.original_pic = NSURL(string: data?.valueForKey("thumbnail_pic") as? String ?? "")
                    self.reposts_count = Int((data?.valueForKey("reposts_count") as? NSNumber ?? 0).integerValue)
                    self.comments_count = Int((data?.valueForKey("comments_count") as? NSNumber ?? 0).integerValue)
                    self.attitudes_count = Int((data?.valueForKey("attitudes_count") as? NSNumber ?? 0).integerValue)
                    return
                }
            }
        }
        created_at = ""
        id = 0
        mid = ""
        text = ""
        source = ""
        thumbnail_pic = NSURL()
        bmiddle_pic = NSURL()
        original_pic = NSURL()
        user = WeiboUser(data: nil)!
        return nil
    }
}