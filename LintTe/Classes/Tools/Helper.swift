//
//  Helper.swift
//  LintTe
//
//  Created by WangHao on 16/6/18.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class Helper: NSObject {

    class func delay(seconds: NSTimeInterval, excute: () -> () ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            excute()
        }
    }
}
