//
//  ViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

struct Accounts {
    static let UserIDKey = "UserID"
    static let ATKey = "access_token"
    static let RTKey = "refresh_token"
    static let ExDate = "expirationDate"
}

class MainViewController: UIViewController, WeiboSDKDelegate {

    private let defaults = NSUserDefaults.standardUserDefaults()
    
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
        
        loginDelegate = self
        
        if let date = defaults.objectForKey(Accounts.ExDate) as? NSDate {
            if date.isEqual(date.earlierDate(NSDate())){
                print("guoqi")
            }else{
                userID = defaults.objectForKey(Accounts.UserIDKey) as? String
                accessToken = defaults.objectForKey(Accounts.ATKey) as? String
                self.getProfile()
            }
        }
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
            self.defaults.setObject(responseData.userID, forKey: Accounts.UserIDKey)
            self.defaults.setObject(responseData.accessToken, forKey: Accounts.ATKey)
            self.defaults.setObject(responseData.refreshToken, forKey: Accounts.RTKey)
            self.defaults.setObject(responseData.expirationDate, forKey: Accounts.ExDate)
            self.getProfile()
        }
    }
    
    private func go(){
        performSegueWithIdentifier("weibo", sender: nil)
    }
    
    private func getProfile(){
        let parameters = ["access_token":accessToken, "uid":userID]
        AFHTTPRequestOperationManager().GET(WeiBoURL.weiboUserUrl, parameters: parameters, success: { (operation, response) -> Void in
            me = WeiboUser(data: (response as! NSDictionary))
            self.go()
            }) { (operation, error) -> Void in
                print("Error[getProfile:]:\(error)")
        }
        
        
        
        
    }
}

