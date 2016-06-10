//
//  TTStatusTableViewCell.swift
//  LintTe
//
//  Created by WangHao on 16/6/6.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
import SDWebImage

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
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
        verifiedImageView.layer.cornerRadius = verifiedImageView.bounds.width / 2.0
        verifiedImageView.layer.borderWidth = 2.0
        verifiedImageView.layer.borderColor = UIColor.whiteColor().CGColor
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
    
    /**
     计算 cell 和 collectionView 的尺寸
     
     - returns:
     */
    private let imageMargin: CGFloat = 10
    private var imageWH: CGFloat = 90
    private func calculateSize() -> (CGSize, CGSize) {
        /*
         * 没有配图 cell = zero, collectionView = zero
         * 有1张配图 cell = image.size, collecttionView = image.size
         * 有2,4张以下配图 cell = {90, 90}, collectionView = {2*w+m, 2*h+m}
         * 其他张以下配图 cell = , collectionView =
         */
        let count = data!.thumbnail_pics.count
        // 没有配图
        if count == 0 {
            return (CGSizeZero, CGSizeZero)
        }
        // 1张配图
        if count == 1 {
            let key = SDWebImageManager.sharedManager().cacheKeyForURL(data!.thumbnail_pics.first)
            // 从缓存中取出下载好的配图
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            return (image.size, image.size)
        }
        
        // 2, 4张配图
        if count == 2 {
            let collectionW = calculateCollectionWH(2)
            let collectionH = calculateCollectionWH(1)
            return (CGSizeMake(imageWH, imageWH), CGSizeMake(collectionW, collectionH))
        }
        if count == 4 {
            let collectionW = calculateCollectionWH(2)
            let collectionH = calculateCollectionWH(2)
            return (CGSizeMake(imageWH, imageWH), CGSizeMake(collectionW, collectionH))
        }
        // 5-9张配图
        let col = 3
        let row = floor(CGFloat(count/4))
        imageWH = (self.bounds.width - 12*2 + imageMargin)/CGFloat(col) - imageMargin
        let collectionW = calculateCollectionWH(col)
        let collectionH = calculateCollectionWH(Int(row))
        return (CGSizeMake(imageWH, imageWH), CGSizeMake(collectionW, collectionH))
    }
    
    private func calculateCollectionWH(num: Int) -> CGFloat {
        return imageWH*CGFloat(num) + imageMargin*CGFloat(num-1)
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

extension TTStatusTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.thumbnail_pics.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.grayColor()
        return cell
    }
}
