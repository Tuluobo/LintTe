//
//  TTStatusTableViewCell.swift
//  LintTe
//
//  Created by WangHao on 16/6/6.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class TTStatusTableViewCell: UITableViewCell {

    // 头像
    @IBOutlet weak var avatarImageView: UIImageView!
    // 认证图像
    @IBOutlet weak var verifiedImageView: UIImageView!
    // 会员图像
    @IBOutlet weak var vipImageView: UIImageView!
    // 昵称
    @IBOutlet weak var nickNameLabel: UILabel!
    // 时间
    @IBOutlet weak var sendTimeLabel: UILabel!
    // 来源
    @IBOutlet weak var sourceLabel: UILabel!
    // 正文
    @IBOutlet weak var statusTextLabel: UILabel!
    
    // 模型数据
<<<<<<< 0724249948953689caa8fd588075a31c9cd0e445
    var data: StatusViewModel? {
        didSet {
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
        verifiedImageView.layer.cornerRadius = verifiedImageView.bounds.width / 2.0
        verifiedImageView.layer.borderWidth = 2.0
        verifiedImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    /**
     更新UI
     */
    private func setupUI() {
        // 初始化
        avatarImageView.image = UIImage(resource: R.image.avatar_default)
        verifiedImageView.image = nil
        vipImageView.image = nil
        nickNameLabel.textColor = UIColor.blackColor()
        sourceLabel.text = nil
        statusTextLabel.text = nil
        
        // 守护数据
        guard let statusVM = data else {
            return
        }
        
        // 正常设置微博
        // 发布时间
        sendTimeLabel.text = statusVM.sendTimeStr
        // 微博来源
        sourceLabel.text = statusVM.sourceStr
        // 微博正文
        statusTextLabel.text = statusVM.status.text
        
        // 用户设置
        // 用户昵称
        nickNameLabel.text = statusVM.status.user.screen_name
        
        // 头像
        if let avatarUrl = statusVM.avatarURL {
            avatarImageView.sd_setImageWithURL(avatarUrl)
        }
        // 认证
        verifiedImageView.image = statusVM.verifiedImage
        // vip
        vipImageView.image = statusVM.mbrankImage
        // 设置昵称颜色
        if let _ = statusVM.mbrankImage {
            nickNameLabel.textColor = UIColor.orangeColor()
        }
    }
    

=======
    var status: Status? {
        didSet {
           setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
    }
    
    /**
     更新UI
     */
    private func setupUI() {
        
        avatarImageView.image = UIImage(named: "avatar_default")
        
        sourceLabel.text = ""
        statusTextLabel.text = ""
        
        guard let sts = status else {
            return
        }
        
        // 微博发表时间
        formatSendDate(sts.created_at)
        // 微博来源
        if var source: NSString = sts.source where source != "" {
            let fromIndex = source.rangeOfString(">").location + 1
            source = source.substringFromIndex(fromIndex)
            let endIndex = source.rangeOfString("<").location
            source = source.substringToIndex(endIndex)
            sourceLabel.text = "来自 \(source)"
        }
        // 微博正文
        statusTextLabel.text = sts.text
        
        // 用户昵称
        nickNameLabel.text = sts.user.screen_name
        // 头像
        if let urlStr = sts.user.profile_image_url {
            avatarImageView.sd_setImageWithURL(NSURL(string: urlStr))
        }
        // 认证
        verified(sts.user.verified_type)
        // 会员
        vip(sts.user.mbrank)
    }
    
    // 发布时间
    private func formatSendDate(timeStr: String) {
        // 1.将服务器获得的时间格式化为NSDate
        TTLog(timeStr)
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        formatter.dateFormat = "EE MM dd HH:mm:ss Z yyyy"
        let createDate = formatter.dateFromString(timeStr)
        TTLog(createDate)
        // 2.拿到当前时间
        // 3.对比设置
        let interval = NSDate().timeIntervalSinceDate(createDate!)
        TTLog(interval)
    }
    
    // 认证
    private func verified(vCode: Int) {
        // 先显示
        verifiedImageView.hidden = false
        switch vCode {
        case 0:
            verifiedImageView.image = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verifiedImageView.image = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImageView.image = UIImage(named: "avatar_grassroot")
        default:
            verifiedImageView.hidden = true
        }
    }
    
    // 会员
    private func vip(rank: Int) {
        vipImageView.hidden = false
        if (rank > 0 && rank < 7) {
            vipImageView.image = UIImage(named: "common_icon_membership_level\(rank)")
            nickNameLabel.textColor = UIColor.orangeColor()
        } else {
            vipImageView.hidden = true
        }
    }
>>>>>>> 首页 请求微博
    
}
