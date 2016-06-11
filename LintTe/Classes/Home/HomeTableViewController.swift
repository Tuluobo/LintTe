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
    var statuses = [StatusViewModel]()
    // 行高缓存
    private var rowHeightCaches = [String: CGFloat]()
    
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
        // 预估行高
        tableView.estimatedRowHeight = 800
        //tableView.rowHeight = UITableViewAutomaticDimension
        
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
                let statusVM = StatusViewModel(status: Status(dict: item))
                self.statuses.append(statusVM)
            }

            // 缓存图片数据
            self.cachesImages(self.statuses)
            
        }
    }
    
    /**
     缓存微博配图
     
     - parameter models: 模型数据
     */
    private func cachesImages(viewModels: [StatusViewModel]) {
        
        // 创建一个线程组
        let group = dispatch_group_create()
        
        for vm in viewModels {
            // 1.从 viewmodel 取出图片url数组
            // 2.遍历数组下载图片
            for url in vm.thumbnail_pics {
                // 1将当前的下载添加到组中
                dispatch_group_enter(group)
                // 2 下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue:0), progress: nil, completed: { (image, error, _, _, _) in
                    
                    TTLog("图片下载完成")
                    // 将当前下载从组中移除
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            TTLog("全部下载完成")
            // 更新数据源
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
        return statuses.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.statusCell, forIndexPath: indexPath)!
        // 设置数据源
        cell.data = statuses[indexPath.section]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let statusVM = statuses[indexPath.section]
        var height = rowHeightCaches[statusVM.status.idstr] ?? 0
        if height == 0 {
            // 1.获取当前行对应的cell
            let currentCell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.statusCell)!
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
