//
//  UIButton+Extension.swift
//  LintTe
//
//  Created by WangHao on 16/6/2.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName: String?, backgroundImageName: String?) {
        
        self.init()
        // 2、设置图片
        if let iName = imageName {
            self.setImage(UIImage(named: iName), forState: .Normal)
            self.setImage(UIImage(named: "\(iName)_highlighted"), forState: .Highlighted)
        }
        // 3、设置背景
        if let bIName = backgroundImageName {
            self.setBackgroundImage(UIImage(named: bIName), forState: .Normal)
            self.setBackgroundImage(UIImage(named: "\(bIName)_highlighted"), forState: .Highlighted)
        }
        // 4、设置frame
        self.sizeToFit()
    }
}
