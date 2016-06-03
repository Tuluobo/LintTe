//
//  TitileButton.swift
//  LintTe
//
//  Created by WangHao on 16/6/3.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class TitileButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        self.setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle("\(title ?? "") ", forState: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Swift 可以直接修改结构体内部的成员
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel?.frame.width ?? 0
    }
}
