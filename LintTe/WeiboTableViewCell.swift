//
//  WeiboTableViewCell.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class WeiboTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var wbTextLabel: UILabel!
    

    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    var data: Weibo? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        profileImageView.image = nil
        screenName.text = nil
        createTimeLabel.text = nil
        wbTextLabel.attributedText = nil
        forwardBtn.setTitle("转发", forState: UIControlState.Normal)
        commentBtn.setTitle("评论", forState: UIControlState.Normal)
        likeBtn.setTitle("赞", forState: UIControlState.Normal)
        if let data = self.data {
            
            screenName.text = "\(data.user)"
            createTimeLabel.text = "\(data.created_at):\(data.source)"
            wbTextLabel.text = data.text
            if data.reposts_count > 0 {
                forwardBtn.setTitle("转发\(data.reposts_count)", forState: UIControlState.Normal)
            }
            if data.comments_count > 0 {
                commentBtn.setTitle("评论\(data.comments_count)", forState: UIControlState.Normal)
            }
            if data.attitudes_count > 0 {
                likeBtn.setTitle("赞\(data.attitudes_count)", forState: UIControlState.Normal)
            }
            
            if let profileImageURL = data.user.profile_image_url {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_sync(dispatch_get_main_queue()){
                        if profileImageURL == self.data?.user.profile_image_url {
                            if imageData != nil {
                                self.profileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                })
            }

        }
    }
    
    @IBAction func forward(sender: UIButton) {
        print("z--f")
    }
    
    @IBAction func comment(sender: UIButton){
        print("p---l")
    }
    
    @IBAction func like(sender: UIButton){
        print("d---z")
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
