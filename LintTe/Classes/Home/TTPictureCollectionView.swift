//
//  TTPictureCollectionView.swift
//  LintTe
//
//  Created by MaSixin on 6/26/16.
//  Copyright © 2016 Tuluobo. All rights reserved.
//

import UIKit
import SDWebImage

class TTPictureCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // collection 流式布局
    @IBOutlet weak var pictureCollectionFlowLayout: UICollectionViewFlowLayout!
    // 自动布局高约束
    @IBOutlet weak var pictureCellHeightCons: NSLayoutConstraint!
    // 自动布局宽约束
    @IBOutlet weak var pictureCellWidthCons: NSLayoutConstraint!
    
    var data: StatusViewModel? {
        didSet {
            // 更新collection 尺寸
            let (cellSize, collectionSize) = calculateSize()
            if cellSize != CGSizeZero {
                pictureCollectionFlowLayout.itemSize = cellSize
            }
            pictureCellWidthCons.constant = collectionSize.width
            pictureCellHeightCons.constant = collectionSize.height
            // 更新 collection 数据源
            self.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
        // 1.设置不可选择
        self.allowsSelection = false
        // 2.设置隐藏滚动条
        self.scrollEnabled = false
        // 3.禁用回弹
        self.bounces = false
        // 4.设置cell之间的间隙
        pictureCollectionFlowLayout.minimumLineSpacing = imageMargin
        pictureCollectionFlowLayout.minimumInteritemSpacing = imageMargin
    }
    
    
    /**
     计算 cell 和 collectionView 的尺寸
     
     - returns:
     */
    private let imageMargin: CGFloat = 4
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
        // 3, 5-9张配图
        let col = 3
        let row = (count - 1)/3 + 1
        let w = UIScreen.mainScreen().bounds.width
        imageWH = (w - 12*2 + imageMargin)/CGFloat(col) - imageMargin
        let collectionW = calculateCollectionWH(col)
        let collectionH = calculateCollectionWH(row)
        return (CGSizeMake(imageWH, imageWH), CGSizeMake(collectionW, collectionH))
    }
    
    private func calculateCollectionWH(num: Int) -> CGFloat {
        return imageWH*CGFloat(num) + imageMargin*CGFloat(num-1)
    }
    
    // MARK: dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = data?.thumbnail_pics.count ?? 0
        return number
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! TTStatusPictureCell
        cell.url = data!.thumbnail_pics[indexPath.item]
        return cell
    }
    
    // MARK: delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        TTLog(indexPath)
    }
    

}

class TTStatusPictureCell: UICollectionViewCell {
    
    var url: NSURL? {
        didSet {
            pictureView.sd_setImageWithURL(url)
        }
    }
    
    @IBOutlet weak var pictureView: UIImageView!
    
}