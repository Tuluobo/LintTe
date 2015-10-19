//
//  HomeTableViewController.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var weibos = [NSDictionary]()
    var since_id: Int64 = 0         //则返回ID比since_id大的微博
    var max_id: Int64 = 0           //返回ID小于或等于max_id的微博，默认为0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(60.0, 0.0, 0.0, 0.0);
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "123"
        refresh()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func refresh(){
        refresh(refreshControl!)
    }
    @IBAction func refresh(sender: UIRefreshControl) {
        let parameters  = [
            "access_token": "\(accessToken)",
            "since_id": "\(since_id)",
            "max_id": "\(max_id)",
            "count": 100,
        ]
        
        AFHTTPRequestOperationManager().GET(WeiBoURL.weiboAllUrl, parameters: parameters, success: { (operation, response) -> Void in
                let dict = response as! NSDictionary
                self.weibos = (dict.valueForKey("statuses") as? [NSDictionary])!
                print(self.weibos.count)
                self.max_id = Int64((dict.valueForKey("max_id") as? NSNumber ?? 0).longLongValue)
                self.since_id = Int64((dict.valueForKey("since_id") as? NSNumber ?? 0).longLongValue)
                self.tableView.reloadData()
                sender.endRefreshing()
            }) { (operation, error) -> Void in
                print("Error[refresh:]:\(error)")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("weibo", forIndexPath: indexPath) as! WeiboTableViewCell
        cell.data = Weibo(data: weibos[indexPath.row])
        return cell
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
