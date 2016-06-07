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
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
        
        // 注册监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeRootViewController(_:)), name: TTSwitchRootViewController, object: nil)
        // 显示首界面
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
=======
>>>>>>> 完善二维码扫描
        return true
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func applicationWillResignActive(application: UIApplication) { }

    func applicationDidEnterBackground(application: UIApplication) { }

    func applicationWillEnterForeground(application: UIApplication) { }

    func applicationDidBecomeActive(application: UIApplication) { }

    func applicationWillTerminate(application: UIApplication) { }

}

// MARK: - 版本相关
extension AppDelegate {
    
    // 切换根控制器
    @objc private func changeRootViewController(notification: NSNotification) {
        
        var initVC: UIViewController?
        let objc = notification.object
        switch objc {
        case is OAuthViewController:
            initVC = R.storyboard.welcome.initialViewController()
        case is WelcomeViewController, is NewFeatureViewController:
            initVC =  R.storyboard.main.initialViewController()
        default:
            break
        }
        if  let vc = initVC {
            window?.rootViewController = vc
        }
    }
    
    // 返回默认界面
    private func defaultViewController() -> UIViewController {
        
        var initVC: UIViewController = R.storyboard.main.initialViewController()!
        // 1.判断是否登录
        if UserAccount.isLogin() {
            // 2.判断是否有新版本
            initVC = isNewVersion() ? R.storyboard.newFeature.initialViewController()! : R.storyboard.welcome.initialViewController()!
        }
        return initVC
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

