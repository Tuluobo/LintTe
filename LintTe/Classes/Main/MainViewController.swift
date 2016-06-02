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
        // 加载 tabbar 子控制器
        self.loadViewControllers()
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
    
    // MARK: - 内部控制方法
    /**
     加载tabbar 所有的子控制器
     */
    private func loadViewControllers() {
        // 渲染图片为橘色
        // 使用的是在Assets.xcassets右侧配置项设置
        // 渲染字体为橘色
        tabBar.tintColor = UIColor.orangeColor()
        // 添加自控制器
        self.addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
        self.addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        self.addChildViewController("NullTableViewController", title: nil, imageName: nil)
        self.addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        self.addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
    }
    
    // OC 不支持方法重载
    // swift 支持方法重载
    private func addChildViewController(childControllerName: String?, title: String?, imageName: String?) {
        
        // 动态获取命名空间
        guard let appName = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else { return }
        
        var cls: AnyClass? = nil
        if let cvc = childControllerName {
            cls = NSClassFromString(appName + "." + cvc)
        }
        TTLog(cls)  // <LintTe.HomeTableViewController: 0x7ffd926ab910>
        
        guard let typeCls = cls as? UITableViewController.Type else { return }
        let childController = typeCls.init()
        
        // 1、设置控制器相关属性
        childController.title = title   // 该方法会由内到外设置title
        
        if let image = imageName {
            childController.tabBarItem.image = UIImage(named: image)
            childController.tabBarItem.selectedImage = UIImage(named: "\(image)_highlighted")
        }
        // 2、包装一个导航控制器
        let navVC = UINavigationController(rootViewController: childController)
        // 3、加载控制器到tabbar
        self.addChildViewController(navVC)
    }

    // MARK: - 懒加载
    lazy var composeButton: UIButton = { () -> UIButton in
        // 1、创建btn
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        // 2、设置点击事件
        btn.addTarget(self, action: #selector(composeAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn;
    }()
    
    @objc private func composeAction() {
        TTLog("test")
    }
    
    
}


