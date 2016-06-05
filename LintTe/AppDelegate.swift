//
//  AppDelegate.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

let AppVersion = "AppVersion"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 一般设置全局型的属性，最好放在AppDelagate中设置，这样可以保证后续的操作都在设置之后
        // 设置整体外观颜色
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        // 设置 tabbar 全局 tintColor 颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 显示首界面
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        // 判断用户登录
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) { }

    func applicationDidEnterBackground(application: UIApplication) { }

    func applicationWillEnterForeground(application: UIApplication) { }

    func applicationDidBecomeActive(application: UIApplication) { }

    func applicationWillTerminate(application: UIApplication) { }

}

// MARK: - 版本相关
extension AppDelegate {
    
    // 返回默认界面
    private func defaultViewController() -> UIViewController {
        
        var sbName = "Main"
        // 1.判断是否登录
        if UserAccount.isLogin() {
            // 2.判断是否有新版本
            sbName = isNewVersion() ? "NewFeature" : "Welcome"
        }
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        return vc
    }
    
    // 判断是否刚刚更新了版本
    private func isNewVersion() -> Bool {
        // 加载沙盒
        let defaults = NSUserDefaults.standardUserDefaults()
        // 1.加载info.plist
        let infoDict = NSBundle.mainBundle().infoDictionary!
        // 2.获取当前版本号
        let currentVersion = infoDict["CFBundleShortVersionString"] as! String
        // 3.获取以前的版本号
        let sanboxVersion = (defaults.objectForKey(AppVersion) ?? "0.0") as! String
        // 4.版本比较
        if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending {
            TTLog("可以更新")
            // 如果有新版本，就利用新版本号更新本地的版本号
            defaults.setObject(currentVersion, forKey: AppVersion)
            // iOS7 以前需要写，以后不必写
            defaults.synchronize()
            return true
        }
        TTLog("没有更新")
        return false
    }
}

