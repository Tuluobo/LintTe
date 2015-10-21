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

class HomeTableViewController: UITableViewController {

    var weibos = [NSDictionary]()
    var since_id: Int64 = 0         //则返回ID比since_id大的微博
    var max_id: Int64 = 0           //返回ID小于或等于max_id的微博，默认为0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: StoryBoard.WeiboCell, bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: StoryBoard.WeiboCell)
        //cell自适应高度
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //获得微博用户信息，并设置导航栏信息
        self.getProfile()

        //刷新cell数据
        refresh(refreshControl!, direction: .START)
    }
    
    //获得微博个人信息
    private func getProfile(){
        let parameters = ["access_token":accessToken, "uid":userID]
        AFHTTPRequestOperationManager().GET(WeiBoURL.weiboUserUrl, parameters: parameters, success: { (operation, response) -> Void in
                let res = response as! NSDictionary
                me = WeiboUser(data: res)
                self.navigationItem.title = "\(me.screen_name)"
            }) { (operation, error) -> Void in
                print("Error[getProfile:]:\(error)")
        }
    }
    
    //下拉刷新
    @IBAction func refresh(sender: UIRefreshControl) {
        refresh(sender, direction: .UP)
    }
    //网络获取数据
    func refresh(sender: UIRefreshControl, direction: Direction){
        var currentRow = 0
        if direction == .DOWN {
            max_id = since_id
            since_id = 0
            currentRow = self.weibos.count
        }else {
            since_id = 0
            max_id = 0
        }
        let parameters  = [
            "access_token": "\(accessToken)",
            "since_id": "\(since_id)",
            "max_id": "\(max_id)",
            "count": 100,
        ]
        if direction == .START{
            let mbHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            mbHUD.mode = MBProgressHUDMode.AnnularDeterminate
            mbHUD.labelText = "正在获取微博"
        }
        AFHTTPRequestOperationManager().GET(WeiBoURL.weiboAllUrl, parameters: parameters, success: { (operation, response) -> Void in
            let dict = response as! NSDictionary
            let datas = (dict.valueForKey("statuses") as? [NSDictionary])!
            self.max_id = Int64((dict.valueForKey("max_id") as? NSNumber ?? 0).longLongValue)
            self.since_id = Int64((dict.valueForKey("since_id") as? NSNumber ?? 0).longLongValue)
            if currentRow > 0{
                self.weibos.appendContentsOf(datas)
            }else{
                self.weibos = datas
                self.tableView.reloadData()
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            sender.endRefreshing()
            }) { (operation, error) -> Void in
                print("Error[refresh:]:\(error)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                sender.endRefreshing()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weibos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.WeiboCell, forIndexPath: indexPath) as! WeiboTableViewCell
        cell.data = Weibo(data: weibos[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    /*
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
