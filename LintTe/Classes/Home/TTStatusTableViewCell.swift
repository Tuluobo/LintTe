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
    // 转发微博正文
    @IBOutlet weak var forwardStatusLabel: UILabel?
    // 配图collectionView
    @IBOutlet weak var pictureCollection: TTPictureCollectionView!
    // 底部视图
    @IBOutlet weak var footerToolView: UIView!
    
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    // 模型数据
    var data: StatusViewModel? {
        didSet {
            setupUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let labelWidth = UIScreen.mainScreen().bounds.width - 12.0*2
        statusTextLabel.preferredMaxLayoutWidth = labelWidth
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
        verifiedImageView.layer.cornerRadius = verifiedImageView.bounds.width / 2.0
        verifiedImageView.layer.borderWidth = 2.0
        verifiedImageView.layer.borderColor = UIColor.whiteColor().CGColor
        forwardStatusLabel?.preferredMaxLayoutWidth = labelWidth

    }
    
    // MARK: - 内部控制方法
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
        forwardStatusLabel?.text = nil
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
        // 转发微博
        forwardStatusLabel?.text = statusVM.retweetText
        // 设置微博图片
        pictureCollection.data = statusVM
        // 微博转发数
        if statusVM.status.reposts_count != 0 {
            retweetBtn.setTitle("\(statusVM.status.reposts_count)", forState: .Normal)
        }
        // 微博评论数
        if statusVM.status.comments_count != 0 {
            commitBtn.setTitle("\(statusVM.status.comments_count)", forState: .Normal)
        }
        // 微博转发数
        if statusVM.status.attitudes_count != 0 {
            likeBtn.setTitle("\(statusVM.status.attitudes_count)", forState: .Normal)
        }
        
        
        // 用户设置
        // 用户昵称
        nickNameLabel.text = statusVM.status.user!.screen_name
        
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
    
        
    // MARK: - 外部方法
    func calcRowHeight(viewModel: StatusViewModel) -> CGFloat {
        // 1.设置数据
        self.data = viewModel
        // 2.更新UI
        self.layoutIfNeeded()
        // 3.返回底部视图Y值
        let y = CGRectGetMaxY(footerToolView.frame)
        return y
    }
    
    // MARK: - 点击响应方法
    @IBAction func retweetBtnClick() {
        TTLog("")
    }
    @IBAction func commitBtnClick() {
        TTLog("")
    }
    @IBAction func likeBtnClick() {
        TTLog("")
    }
    
}


