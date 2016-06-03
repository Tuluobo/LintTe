//
//  TTPresentationController.swift
//  LintTe
//
//  Created by WangHao on 16/6/3.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class TTPresentationController: UIPresentationController {
    
    var presentFrame: CGRect = CGRectZero
    // 自定义Modal 出来的控制器不会移除所有的控制器
    // containerView 容器视图
    // presentedView() 通过该方法能够拿到弹出的视图
    // 自定义转场的ViewController的尺寸可以通过func containerViewWillLayoutSubviews()函数设置
    
    // 用于布局转场动画控件
    override func containerViewWillLayoutSubviews() {
        
        presentedView()?.frame = presentFrame
        ///
        coverButton.addTarget(self, action: #selector(coverBtnClick), forControlEvents: .TouchUpInside)
        containerView?.insertSubview(coverButton, atIndex: 0)
    }
    
    
    // MARK: - 懒加载
    private var coverButton: UIButton = { () -> UIButton in
        
        let btn = UIButton()
        btn.frame = UIScreen.mainScreen().bounds
        return btn
    }()
    
    // MARK: - 内部控制方法
    @objc private func coverBtnClick() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
