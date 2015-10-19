//
//  ViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, WeiboSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        loginDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func didReceiveWeiboRequest(request: WBBaseRequest!) { }
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if response.isKindOfClass(WBAuthorizeResponse) {
            let responseData = response as! WBAuthorizeResponse
            userID = responseData.userID
            accessToken = responseData.accessToken
            refreshToken = responseData.refreshToken
            self.getProfile()
        }
    }
    
    private func go(){
        performSegueWithIdentifier("weibo", sender: nil)
    }
    
    private func getProfile(){
        let manager = AFHTTPRequestOperationManager()
        let parameters = ["access_token":accessToken, "uid":userID]
        manager.GET(WeiBoURL.weiboUserUrl, parameters: parameters, success: { (operation, response) -> Void in
            me = WeiboUser(data: (response as! NSDictionary))
            print("\(response)")
            self.go()
            }) { (operation, error) -> Void in
                print("Error[getProfile:]:\(error)")
        }
    }
}

