//
//  ProfileTableViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    var weibos = [NSDictionary]()
    var since_id: Int64 = 0         //则返回ID比since_id大的微博
    var max_id: Int64 = 0           //返回ID小于或等于max_id的微博，默认为0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cell自适应高度
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension

        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //网络获取数据
    func refresh(){
        let parameters = [
            "access_token": accessToken,
            "max_id": "\(max_id)"
        ]
        AFHTTPRequestOperationManager().GET(WeiBoURL.myWeibolListUrl, parameters: parameters, success: { (operation, response) -> Void in
                let dict = response as! NSDictionary
                let datas = (dict.valueForKey("statuses") as? [NSDictionary])!
                self.max_id = Int64((dict.valueForKey("max_id") as? NSNumber ?? 0).longLongValue)
                self.since_id = Int64((dict.valueForKey("since_id") as? NSNumber ?? 0).longLongValue)
                self.weibos.appendContentsOf(datas)
                self.tableView.reloadData()
            }) { (operation, error) -> Void in
                print("Error[refresh:]:\(error)")
        }
    }

    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
          return weibos.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("myprofile", forIndexPath: indexPath) as! MyTableViewCell
            cell.data = me
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("weibo", forIndexPath: indexPath) as! WeiboTableViewCell
            cell.data = Weibo(data: weibos[indexPath.row])
            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 10
        }
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
