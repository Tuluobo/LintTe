//
//  AppDelegate.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        // 加载主控制器
        // 1、实例化 window 对象
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        // 2、设置主控制器
        self.window?.rootViewController = MainViewController()
        // 3、显示可见
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) { }

    func applicationDidEnterBackground(application: UIApplication) { }

    func applicationWillEnterForeground(application: UIApplication) { }

    func applicationDidBecomeActive(application: UIApplication) { }

    func applicationWillTerminate(application: UIApplication) { }

}

