//
//  OAuthViewController.swift
//  LintTe
//
//  Created by WangHao on 16/6/4.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var oauthWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1、定义登录界面URL
        let urlStr = "\(WeiBoURL.weiboBaseUrl)\(WeiBoURL.weiboAuthorize)?client_id=\(Defines.wbAppKey)&redirect_uri=\(Defines.wbRedirectURI)"
        guard let url = NSURL(string: urlStr) else { return }
        // 2.请求网络
        oauthWebView.loadRequest(NSURLRequest(URL: url))
    }
    
    @IBAction func cancelBtnClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - UIWebViewDelegate
extension OAuthViewController: UIWebViewDelegate {
    // MBProgressHUD
    // SVProgressHUD 两个进度提醒库
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示我们的提醒
        SVProgressHUD.showInfoWithStatus("正在加载中...")
        SVProgressHUD.setDefaultStyle(.Dark)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭我们的提醒
        SVProgressHUD.dismiss()
    }
    
    // 代理方法
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // url 错误
        guard let urlStr = request.URL?.absoluteString else { return false }
        // 非授权页面，正常跳转
        if !urlStr.hasPrefix(Defines.wbRedirectURI) {
            return true
        }
        
        // 授权回调页面
        // 成功
        if urlStr.containsString("?code=") {
            if let code = request.URL!.query?.substringFromIndex("code=".endIndex) {
                TTLog(code)
                loadAccessToken(code)
            }
            return false
        }
        // 取消
        TTLog("授权取消")
        return false
    }
    
    /**
        获取用户Access_token
     
     - parameter code: 未授权code
     */
    private func loadAccessToken(code: String) {
        // 请求参数
        let parameters = [
            "client_id": Defines.wbAppKey,
            "client_secret": Defines.wbSecretKey,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Defines.wbRedirectURI
        ]
        // 发送请求获取Access_token
        NetworkManager.shareInstance.POST(WeiBoURL.weiboAccessToken, parameters: parameters, success: { (_,  data) in
            /**
             *  一般情况下，微博会在一定时间内不对access_token更新，
             *  因为其有过期时间，所以我们在一段时间内获取到的access_token都一样
             */
            // data 数据是 AFNetworking 转换过得字段
            // 1、将获取到的access_token转为模型
            let account = UserAccount(dict: data as! [String: AnyObject])
            TTLog(account)
            // 2. 获取用户信息
            account.loadUserInfo({ (userAccount, error) in
                // 3. 归案授权信息
                if error != nil {
                    TTLog(error)
                    return
                }
                // 3.1保存授权信息
                userAccount!.saveAccount()
                // 3.2跳转到欢迎界面
                NSNotificationCenter.defaultCenter().postNotificationName(TTSwitchRootViewController, object: self)
                // 4.关闭认证界面
                self.cancelBtnClick(UIBarButtonItem())
            })
            
            }) { (_, error) in

                TTLog(error)
        }
        
    }
}