//
//  UIButton+Extension.swift
//  LintTe
//
//  Created by WangHao on 16/6/2.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName: String, backgroundImageName: String) {
        
        self.init()
        // 2、设置图片
        self.setImage(UIImage(named: imageName), forState: .Normal)
        self.setImage(UIImage(named: "\(imageName)_highlighted"), forState: .Highlighted)
        // 3、设置背景
        self.setBackgroundImage(UIImage(named: backgroundImageName), forState: .Normal)
        self.setBackgroundImage(UIImage(named: "\(backgroundImageName)_highlighted"), forState: .Highlighted)
        // 4、设置frame
        self.sizeToFit()
    }
}
