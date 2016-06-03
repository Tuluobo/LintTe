//
//  HomeTableViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

enum Direction {
    case UP, DOWN, START
}

class HomeTableViewController: BaseTableViewController {

    var weibos = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜！")
            return
        }
        
        let titleBtn = TitileButton()
        titleBtn.setTitle("秃萝卜", forState: .Normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        navigationItem.titleView = titleBtn
        
    }
    
    @objc private func titleBtnClick(button: TitileButton) {
        // 1、修改按钮状态
        button.selected = !button.selected
        
        // 2、显示菜单
        // 2.1 创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        // 自定义转场动画
        // 设置转场代理
        menuView.transitioningDelegate = self
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        // 2.2 显示菜单
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

extension HomeTableViewController: UIViewControllerTransitioningDelegate {
    // 该方法用于返回一个负责转场的动画，修改尺寸等
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return TTPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    // 负责转场出现的方式
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    // 负责转场出消失的方式
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension HomeTableViewController: UIViewControllerAnimatedTransitioning {
    // 负责系统的展现消失时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 999
    }
    
    /**
     // 专门负责管理Modal如何展现和消失
     // 注意：只要实现了这个代理方法，那么系统就不会再有默认的动画了，
     //      从上至下的移动系统不再帮我们添加,所有的动画有我们实现
     
     - parameter transitionContext: 所有的动画需要的参数都包含在这个参数中
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取需要弹出的视图
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else { return }
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 2、将需要弹出的视图添加到containerView
        transitionContext.containerView()?.addSubview(toView)
        // 3、执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        toView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(1.0, animations: {
            toView.transform = CGAffineTransformIdentity
            }) { ( _ ) in
            // 自定义转场动画，在执行完毕一定要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
    }
}
