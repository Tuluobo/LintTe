//
//  HomeTableViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    var weibos = [NSDictionary]()
    
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
        btn.setTitle("秃萝卜", forState: .Normal)
        btn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    // MARK: - 系统进程方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜！")
            return
        }
        navigationItem.titleView = titleBtn
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleChange), name: TTPresentationManagerDidPresentedController, object: animationManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleChange), name: TTPresentationManagerDidDismissedController, object: animationManager)
    }
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        TTLog("")
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weibos.count
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
