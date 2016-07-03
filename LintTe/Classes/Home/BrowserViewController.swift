//
//  BrowserViewController.swift
//  LintTe
//
//  Created by MaSixin on 6/26/16.
//  Copyright © 2016 Tuluobo. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

let browserCellIdentifier = "BrowserViewControllerCellIdentifier"

class BrowserViewController: UIViewController {
    
    // 所有的配图
    private var bmiddle_pics: [NSURL]
    // 当前点击的索引
    private var indexPath: NSIndexPath
    // MARK: 懒加载
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: self.view.bounds, collectionViewLayout: TTBrowserLayout())
        clv.dataSource = self
        clv.registerClass(TTBrowserCell.self, forCellWithReuseIdentifier: browserCellIdentifier)
        return clv
    }()
    
    init(pics: [NSURL], indexPath: NSIndexPath) {
        self.bmiddle_pics = pics
        self.indexPath = indexPath
        // 注意：自定义构造方法的时候不一定调用super.init()，需要调用当前设计类构造方法（designated）
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // UI
        self.view.addSubview(collectionView)
        let size = self.view.frame.size
        // 关闭按钮
        let closeBtnFrame = CGRectMake(44, size.height-44, 44, 20)
        let closeBtn = UIButton(frame: closeBtnFrame)
        closeBtn.setTitle("关闭", forState: .Normal)
        self.view.addSubview(closeBtn)
        // 保存按钮
        let saveBtnFrame = CGRectMake(size.width-44*2, size.height-44, 44, 20)
        let saveBtn = UIButton(frame: saveBtnFrame)
        saveBtn.setTitle("保存", forState: .Normal)
        self.view.addSubview(saveBtn)
        // 设置点击事件
        closeBtn.addTarget(self, action: #selector(closeController), forControlEvents: .TouchUpInside)
        saveBtn.addTarget(self, action: #selector(savePicture), forControlEvents: .TouchUpInside)
    }
    
    @objc private func closeController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func savePicture() {
        
    }
    
}

// MARK: UICollectionViewDataSource
extension BrowserViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_pics.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(browserCellIdentifier, forIndexPath: indexPath) as! TTBrowserCell
        cell.data = bmiddle_pics[indexPath.item]
        return cell
    }
    
}

// MARK: - 自定义图片浏览Cell
class TTBrowserCell: UICollectionViewCell {
 
    var data: NSURL? {
        didSet {
            SVProgressHUD.show()
            SVProgressHUD.setDefaultStyle(.Dark)
            imageView.sd_setImageWithURL(data) { (image, error, _, _) in
                if error != nil {
                    TTLog("图片获取失败")
                    return
                }
                // 调整
                let scale = image.size.width/image.size.height
                let newWidth = UIScreen.mainScreen().bounds.size.width
                let newHeight = newWidth/scale
                let x: CGFloat = 0.0
                let y = (UIScreen.mainScreen().bounds.size.height - newHeight)/2
                self.imageView.frame = CGRectMake(x, y, newWidth, newHeight)
                SVProgressHUD.dismiss()
            }
        }
    }
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        scrollView.frame = self.frame
        scrollView.addSubview(imageView)
        contentView.addSubview(scrollView)
    }
    
    
}

// MARK: - 自定义布局
class TTBrowserLayout: UICollectionViewFlowLayout {
    // 准备布局
    override func prepareLayout() {
        // 1.设置每一个 cell 的尺寸
        itemSize = UIScreen.mainScreen().bounds.size
        // 2.设置cell之间的间隙
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // 3.设置滚动方向
        scrollDirection = .Horizontal
        // 4.设置分页
        collectionView?.pagingEnabled = true
        // 5.回弹
        collectionView?.bounces = true
        // 6.去除滚动条
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}