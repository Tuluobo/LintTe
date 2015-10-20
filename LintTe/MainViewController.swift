//
//  ViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func register(sender: UIBarButtonItem) {
        WeiboSDK.messageRegister("微博注册")
    }

    @IBAction func login(sender: UIButton) {
        let request = WBAuthorizeRequest()
        request.redirectURI = Defines.wbRedirectURI
        request.scope = "all"
        
        WeiboSDK.sendRequest(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

