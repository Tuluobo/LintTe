//
//  HomeTableViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeTableViewController: BaseTableViewController {

    // 数据源
    let statusList = StatusListModel()
    // 最后一条微博标记
    var lastFlag = false
    // 行高缓存
    private var rowHeightCaches = [String: CGFloat]()
    
    // MARK: - 懒加载
    private lazy var animationManager: TTPresentationManager = {
        let manager = TTPresentationManager()
        let size = UIScreen.mainScreen().bounds.size
        manager.presentFrame = CGRectMake(size.width/4, 54, size.width/2, size.height*3/5)
        return manager
    }()
    // 标题按钮
    private lazy var titleBtn: TitileButton = { () -> TitileButton in
        // 添加 titleView
        let btn = TitileButton()
        let title = UserAccount.userAccount?.screen_name
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    // 刷新提醒视图
    private lazy var tipLabel: UILabel = {
        let tLabel = UILabel(frame: self.navigationController!.navigationBar.bounds)
        tLabel.backgroundColor = UIColor.orangeColor()
        tLabel.text = "没有更多微博"
        tLabel.textAlignment = .Center
        tLabel.textColor = UIColor.whiteColor()
        tLabel.hidden = true
        return tLabel
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showBrowser(_:)), name: TTShowPhotoBrowserController, object: nil)
        
        // 加载微博数据
        loadData()
        // 预估行高
        tableView.estimatedRowHeight = 800
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        // 下拉刷新初始化
        refreshControl = TTRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
        
        navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
    }
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     加载微博数据
     */
    @objc private func loadData() {
        
        statusList.loadData(lastFlag) { (statusVMs, error) in
            if error != nil {
                SVProgressHUD.showErrorWithStatus("获取微博数据失败")
                SVProgressHUD.setDefaultStyle(.Dark)
                TTLog(error)
                return
            }
            // 更新数据源
            if self.lastFlag {
                self.lastFlag = false
            } else {
                // 显示更新微博数目
                self.showRefreshStatus(statusVMs!.count)
            }
            // 停止加载
            self.refreshControl?.endRefreshing()
            // 更新数据源
            self.tableView.reloadData()
        }
    }

    private func showRefreshStatus(numbers: Int) {
        if numbers > 0 {
            tipLabel.text = "\(numbers)条微博"
        }
        self.tipLabel.hidden = false
        UIView.animateWithDuration(1.0, animations: {
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44)
        }) { (_) in
            Helper.delay(1.0, excute: {
                UIView.animateWithDuration(1.0, animations: { 
                    self.tipLabel.transform = CGAffineTransformIdentity
                }, completion: { (_) in
                    self.tipLabel.text = "没有更多微博"
                    self.tipLabel.hidden = true
                })
                
            })
        }
        
    }
    
    // MARK: - 响应函数
    @objc private func titleChange() {
        titleBtn.selected = !titleBtn.selected
    }
    
    @objc private func titleBtnClick(button: TitileButton) {
        // 2、显示菜单
        // 2.1 创建菜单
        guard let menuView = R.storyboard.popover.initialViewController() else {
            return
        }
        // 2.2自定义转场动画
        // 设置转场代理
        menuView.transitioningDelegate = animationManager
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        // 2.3 显示菜单
        presentViewController(menuView, animated: true, completion: nil)
    }
    
    @objc private func showBrowser(notication: NSNotification) {
        // 网络或者通知拿到的数据需要安全校验
        guard let bmiddle_pics = (notication.userInfo?["bmiddle_pics"] as? [NSURL]) else {
            SVProgressHUD.showErrorWithStatus("没有图片")
            SVProgressHUD.setDefaultStyle(.Dark)
            return
        }
        guard let indexPath = (notication.userInfo?["indexPath"] as? NSIndexPath) else {
            SVProgressHUD.showErrorWithStatus("数据传输出错")
            SVProgressHUD.setDefaultStyle(.Dark)
            return
        }
        presentViewController(BrowserViewController(pics: bmiddle_pics, indexPath: indexPath), animated: true, completion: nil)
    }
    
    @IBAction func leftBarBtnClick() {
        TTLog("")
    }
    @IBAction func rightBarBtnClick() {
        let vc = R.storyboard.qRCode.initialViewController()
        self.presentViewController(vc!, animated: true, completion: nil)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        rowHeightCaches.removeAll()
    }
}

// MARK: - Table view data source and delagate
extension HomeTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return statusList.statuses.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let statusVM = statusList.statuses[indexPath.section]
        var ID = R.reuseIdentifier.statusCell
        if statusVM.retweetText != nil {
            ID = R.reuseIdentifier.forwardStatusCell
        }
        let cell  = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath)!
        // 设置数据源
        cell.data = statusVM
        // 判断是否是最后一条微博
        if indexPath.section == self.statusList.statuses.count-1 {
            lastFlag = true
            loadData()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let statusVM = statusList.statuses[indexPath.section]
        var ID = R.reuseIdentifier.statusCell
        if statusVM.retweetText != nil {
            ID = R.reuseIdentifier.forwardStatusCell
        }
        var height = rowHeightCaches[statusVM.status.idstr] ?? 0
        if height == 0 {
            // 1.获取当前行对应的cell
            let currentCell = tableView.dequeueReusableCellWithIdentifier(ID)!
            // 2.获取当前cell底部视图最大的Y值
            height = currentCell.calcRowHeight(statusVM)
            rowHeightCaches[statusVM.status.idstr] = height
            TTLog(height)
        }
        // 4.返回cell的高度
        return height
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }

}
