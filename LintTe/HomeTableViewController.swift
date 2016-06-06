//
//  HomeTableViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit
import SVProgressHUD

let StatusCell = "StatusCell"

class HomeTableViewController: BaseTableViewController {

    var statuses = [Status]()
    
    // MARK: - 懒加载
    private lazy var animationManager: TTPresentationManager = {
        let manager = TTPresentationManager()
        let size = UIScreen.mainScreen().bounds.size
        manager.presentFrame = CGRectMake(size.width/4, 54, size.width/2, size.height*3/5)
        return manager
    }()
    
    private lazy var titleBtn: TitileButton = { () -> TitileButton in
        // 添加 titleView
        let btn = TitileButton()
        let title = UserAccount.userAccount?.screen_name
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    // MARK: - 系统进程方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 登陆判断
        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜！")
            return
        }
        
        // 设置titleBtn
        navigationItem.titleView = titleBtn
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleChange), name: TTPresentationManagerDidPresentedController, object: animationManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleChange), name: TTPresentationManagerDidDismissedController, object: animationManager)
        
        // 加载微博数据
        loadData()
        
    }
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     加载微博数据
     */
    private func loadData() {
        NetworkManager.shareInstance.loadStatuses { (array, error) in
            if error != nil {
                SVProgressHUD.showWithStatus("获取微博数据失败")
                SVProgressHUD.setDefaultMaskType(.Black)
                return
            }
            
            for item in array! {
                self.statuses.append(Status(dict: item))
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - 响应函数
    @objc private func titleChange() {
        titleBtn.selected = !titleBtn.selected
    }
    
    @objc private func titleBtnClick(button: TitileButton) {
        // 2、显示菜单
        // 2.1 创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        // 2.2自定义转场动画
        // 设置转场代理
        menuView.transitioningDelegate = animationManager
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        // 2.3 显示菜单
        presentViewController(menuView, animated: true, completion: nil)
        
    }
    
    @IBAction func leftBarBtnClick() {
        TTLog("")
    }
    @IBAction func rightBarBtnClick() {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        self.presentViewController(vc!, animated: true, completion: nil)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - Table view data source and delagate
extension HomeTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCellWithIdentifier(StatusCell, forIndexPath: indexPath) as! TTStatusTableViewCell
        cell.status = statuses[indexPath.row]
        return cell
    }

}
