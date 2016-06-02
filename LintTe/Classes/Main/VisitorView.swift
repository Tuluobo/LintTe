//
//  VisitorView.swift
//  LintTe
//
//  Created by WangHao on 16/6/2.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    // 背景转盘图片
    @IBOutlet weak var rotationImageView: UIImageView!
    // 图标
    @IBOutlet weak var iconImageView: UIImageView!
    // 文本
    @IBOutlet weak var titleLabel: UILabel!
    // 按钮
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    class func visitorView() -> VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).last as! VisitorView
    }
    
    func setupVisitorInfo(imageName: String?, title: String) {
        
        titleLabel.text = title
        guard let name = imageName else {
            // 没有传imageName，说明是首页
            // 旋转转盘
            startAniamtion()
            return
        }
        rotationImageView.hidden = true
        iconImageView.image = UIImage(named: name)
    }
    
    private func startAniamtion() {
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 20.0
        anim.repeatCount = MAXFLOAT
        // 3.添加动画到图层
        // 注意：默认情况下只要视图消失，系统就会自动移除动画
        // 解决
        anim.removedOnCompletion = false
        
        rotationImageView.layer.addAnimation(anim, forKey: nil)
        
    }
    
}
