//
//  MyTableViewCell.swift
//  LintTe
//
//  Created by WangHao on 15/10/20.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var weiboNumLabel: UILabel!
    @IBOutlet weak var followNumLabel: UILabel!
    @IBOutlet weak var fansNumLabel: UILabel!
    @IBOutlet weak var verifiedLabel: UILabel!
    
    var data: WeiboUser? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        profileImageView.image = nil
        screenNameLabel.text = nil
        weiboNumLabel.text = "0"
        followNumLabel.text = "0"
        fansNumLabel.text = "0"
        verifiedLabel.text = nil
        
        if let user = self.data {
            screenNameLabel?.text = "\(user)"
            if screenNameLabel.text == nil {
                screenNameLabel.text = "\(user.name)"
            }
            if !user.verified {
                verifiedLabel.text = "微博认证：\(user.verified_reason)"
            }else{
                verifiedLabel.frame.size.height = 0
            }
            weiboNumLabel.text = "\(user.statuses_count)"
            followNumLabel.text = "\(user.friends_count)"
            fansNumLabel.text = "\(user.followers_count)"
        
            if let profileImageURL = user.avatar_hd {
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0), { () -> Void in
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_sync(dispatch_get_main_queue()){
                        if profileImageURL == self.data?.avatar_hd {
                            if imageData != nil {
                                self.profileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.borderWidth = 2;  //设置的UIImageView的边框宽度
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor   //设置边框颜色
        self.profileImageView.layer.cornerRadius = CGRectGetHeight(self.profileImageView.bounds) / 2;   //这里才是实现圆形的地方
        self.profileImageView.clipsToBounds = true;    //这里设置超出部分自动剪裁掉
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
