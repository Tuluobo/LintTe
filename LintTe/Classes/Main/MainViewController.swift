//
//  MainViewController.swift
//  LintTe
//
//  Created by WangHao on 16/6/2.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let size = tabBar.bounds.size
        composeButton.center = CGPoint(x: size.width/2, y: size.height/2)
        // load在中间按钮
        tabBar.addSubview(composeButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 懒加载
    lazy var composeButton: UIButton = { () -> UIButton in
        // 1、创建btn
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        // 2、设置点击事件
        btn.addTarget(self, action: #selector(composeAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn;
    }()
    // 创建微博点击事件
    @objc private func composeAction() {
        TTLog("test")
    }
    
    
}


