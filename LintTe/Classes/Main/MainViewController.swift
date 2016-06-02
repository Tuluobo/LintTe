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

        self.loadViewControllers()
        
    }
    /**
     加载tabbar 所有的子控制器
     */
    func loadViewControllers() {
        // 渲染图片为橘色
        // 使用的是在Assets.xcassets右侧配置项设置
        // 渲染字体为橘色
        tabBar.tintColor = UIColor.orangeColor()
        // 添加自控制器
        self.addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        self.addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        self.addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        self.addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    // OC 不支持方法重载
    // swift 支持方法重载
    func addChildViewController(childController: UIViewController, title: String, imageName: String) {
        // 1、设置控制器相关属性
        childController.title = title   // 该方法会由内到外设置title
        
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_highlighted")
        // 2、包装一个导航控制器
        let navVC = UINavigationController(rootViewController: childController)
        // 3、加载控制器到tabbar
        self.addChildViewController(navVC)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
