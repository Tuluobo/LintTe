//
//  BaseTableViewController.swift
//  LintTe
//
//  Created by WangHao on 16/6/2.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    // 标记用户是否登录
    var isLogin = UserAccount.isLogin()

    var visitorView: VisitorView?
    
    override func loadView() {
        // 判断用户是否登陆
        
        // 1. 已经登录，显示tableView
        // 2. 没有登录，显示登录
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    
    private func setupVisitorView() {

        self.visitorView = VisitorView.visitorView()
        // 添加图片，按钮
        self.view = self.visitorView
        
        self.visitorView?.registerBtn.addTarget(self, action: #selector(register), forControlEvents: UIControlEvents.TouchUpInside)
        self.visitorView?.loginBtn.addTarget(self, action: #selector(login), forControlEvents: UIControlEvents.TouchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(register))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(login))
    }

    @objc private func register() {
        TTLog("")
    }
    
    @objc private func login() {
        // 1.创建登录界面
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        // 2.转到登录界面
        presentViewController(vc, animated: true, completion: nil)
    }
    
}
