//
//  WelcomeViewController.swift
//  LintTe
//
//  Created by WangHao on 16/6/5.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // 头像底部约束
    @IBOutlet weak var avatarBottomCons: NSLayoutConstraint!
    // 头像
    @IBOutlet weak var avatarImageView: UIImageView!
    // 欢迎语
    @IBOutlet weak var welcomeLabelView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let account = UserAccount.userAccount
        assert(account != nil, "welcome 需要授权后才能使用")
        welcomeLabelView.text = "\(account!.screen_name!)，\(welcomeLabelView.text!)"
        
        let url = NSURL(string: account!.avatar_large!)
        avatarImageView.sd_setImageWithURL(url)
        
        // 设置圆角
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2.0
        avatarImageView.layer.masksToBounds = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1. 计算约束高度
        avatarBottomCons.constant = UIScreen.mainScreen().bounds.height - avatarBottomCons.constant
        // 2. 设置动画
        UIView.animateWithDuration(2.0, animations: {
            self.view.layoutIfNeeded()
        }) { (flag) in
            UIView.animateWithDuration(2.0, animations: { 
                self.welcomeLabelView.alpha = 1.0
            }, completion: { (flag) in
                sleep(2)
                // 跳转到欢迎界面
//                let window = UIApplication.sharedApplication().keyWindow
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//                window?.rootViewController = vc
                NSNotificationCenter.defaultCenter().postNotificationName(TTSwitchRootViewController, object: self)
            })
        }
    }
}
