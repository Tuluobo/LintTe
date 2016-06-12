//
//  StatusViewModel.swift
//  LintTe
//
//  Created by WangHao on 16/6/7.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
/*
 * M: 模型(保存数据)
 * V: 视图(展现数据)
 * C: 控制器(管理模型和视图，桥梁)
 * VM 作用：
    1. 可以对M和V瘦身
    2. 处理业务逻辑
 */
class StatusViewModel: NSObject {

    /// 模型对象
    var status: Status
    
    /// 处理之后的对象
    // 微博
    var sendTimeStr: String
    var sourceStr: String?
    var thumbnail_pics = [NSURL]()
    var retweetText: String?
    // 用户
    var verifiedImage: UIImage?
    var mbrankImage: UIImage?
    var avatarURL: NSURL?
    
    
    init(status: Status) {
        
        self.status = status
        
        // 微博发表时间
        let createDate = NSDate.formatDateFromString(self.status.created_at, format: "EE MM dd HH:mm:ss Z yyyy")!
        sendTimeStr = createDate.descriptionStr()
        // 微博来源
        if var source: NSString = self.status.source where source != "" {
            let fromIndex = source.rangeOfString(">").location + 1
            source = source.substringFromIndex(fromIndex)
            let endIndex = source.rangeOfString("<").location
            source = source.substringToIndex(endIndex)
            sourceStr = "来自\(source)"
        }
        
        /// 用户
        if let user = self.status.user {
            // 头像
            avatarURL = NSURL(string: user.profile_image_url ?? "")
            // 认证
            switch user.verified_type {
            case 0:
                verifiedImage = UIImage(resource: R.image.avatar_vip)
            case 2, 3, 5:
                verifiedImage = UIImage(resource: R.image.avatar_enterprise_vip)
            case 220:
                verifiedImage = UIImage(resource: R.image.avatar_grassroot)
            default:
                verifiedImage = nil
            }
            // 会员
            let rank = user.mbrank
            if (rank > 0 && rank < 7) {
                mbrankImage = UIImage(named: "common_icon_membership_level\(rank)")
            }
        }
        
        // 配图选择
        var picUrls = self.status.pic_urls
        // 转发微博
        if let retweetStatus = self.status.retweeted_status {
            retweetText = "@\(retweetStatus.user?.screen_name ?? ""):\(retweetStatus.text ?? "")"
            picUrls = self.status.retweeted_status?.pic_urls
        }
        // 配图处理
        if let pic_urls = picUrls {
            // 1.遍历数组下载图片
            for picDict in pic_urls {
                // 2 取出图片的url字符串
                guard let urlStr = picDict["thumbnail_pic"] as? String else {
                    continue
                }
                // 3 创建URL
                thumbnail_pics.append(NSURL(string: urlStr)!)
            }
        }
    }

}
