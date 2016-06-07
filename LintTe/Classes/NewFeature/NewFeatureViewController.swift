//
<<<<<<< 4b99738d24d8f79552df0780ce41942457eead4f
//  NewFeatureViewController.swift
=======
//  NewFeatureCollectionViewController.swift
>>>>>>> access_token 获取
//  LintTe
//
//  Created by WangHao on 16/6/5.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

<<<<<<< 4b99738d24d8f79552df0780ce41942457eead4f
let cellID = "NewFeatureImageCell"

class NewFeatureViewController: UIViewController {

    var newFeatureImages = [UIImage]()
    // 页面控制
    @IBOutlet weak var imageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 1...4 {
            let image = UIImage(named: "new_feature_\(i)")!
            newFeatureImages.append(image)
        }
        imageControl.numberOfPages = 4
=======
class NewFeatureCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

>>>>>>> access_token 获取
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

<<<<<<< 4b99738d24d8f79552df0780ce41942457eead4f
}

extension NewFeatureViewController: UICollectionViewDataSource {
    
    // collection 有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // collection 有多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newFeatureImages.count
    }
    
    // 显示单元格内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        imageControl.currentPage = indexPath.row
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = newFeatureImages[indexPath.row]
        cell.addSubview(imageView)
        
        
        return cell
    }
    
    @objc private func startEnterWB() {
        NSNotificationCenter.defaultCenter().postNotificationName(TTSwitchRootViewController, object: self)
    }
}

extension NewFeatureViewController: UICollectionViewDelegate {
    // 完全显示之后添加开启微博按钮
    // 此方法传入的cell和indexPath是上一页面的，所以需要我们获取当前页面
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

        // 获取当前cell
        guard let currentIndexPathofCell = collectionView.indexPathsForVisibleItems().last else { return }
        let currentCell = collectionView.cellForItemAtIndexPath(currentIndexPathofCell)!
        // 在最后一页设置按钮，并开启动画
        if currentIndexPathofCell.row == (newFeatureImages.count-1) {
            let size = currentCell.bounds.size
            let width:CGFloat = 160
            let btn = UIButton(imageName: "new_feature_button", backgroundImageName: nil)
            btn.frame = CGRectMake((size.width-width)/2, size.height-width, width, width/4)
            
            btn.addTarget(self, action: #selector(startEnterWB), forControlEvents: .TouchUpInside)
            currentCell.addSubview(btn)
            /**
             动画效果
             - parameter duration:               动画时间
             - parameter delay:                  延迟时间
             - parameter usingSpringWithDamping: 振幅 0.0~1.0 值越小振幅越大
             - parameter initialSpringVelocity:  加速度，值越大振幅越厉害
             - parameter options:                动画附加属性
             - parameter animations:             执行动画的block
             - parameter completion:             执行完动画block
             */
            btn.userInteractionEnabled = false
            btn.transform = CGAffineTransformMakeScale(0.0, 0.0)
            UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                btn.transform = CGAffineTransformIdentity
                }, completion: { (flag) in
                    btn.userInteractionEnabled = true
            })
            
        }

    }
}

// MARK: - 自定义布局
class TTNewFeatureLayout: UICollectionViewFlowLayout {
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
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.去除滚动条
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        // 7.显示分页原点
    }
    

}


=======


}
>>>>>>> access_token 获取
