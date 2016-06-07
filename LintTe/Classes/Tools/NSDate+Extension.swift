//
//  NSDate+Extension.swift
//  LintTe
//
//  Created by WangHao on 16/6/7.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func formatDateFromString(date: String, format: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        formatter.dateFormat = format
        return formatter.dateFromString(date)
    }

    /**
     一种时间显示格式描述
     - returns: 时间描述字符串
     */
    func descriptionStr() -> String {
        var res = ""
        // 1.创建时间格式化对象
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 2.日历对象
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInToday(self) {
            // 今天的处理
            let interval = Int(NSDate().timeIntervalSinceDate(self))
            if interval < 60 {                  // 刚刚
                res = "刚刚"
            } else if interval < 60*60 {        // xx分钟前
                res = "\(interval/60)分钟前"
            } else {                            // xx小时前
                res = "\(interval/60/60)小时前"
            }
        } else if calendar.isDateInYesterday(self) {
            // 昨天 xx:xx
            formatter.dateFormat = "HH:mm"
            res = "昨天 \(formatter.stringFromDate(self))"
        } else {
            // 早于昨天的时间
            let year = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue:0)).year
            if year > 0 {
                // xxxx-xx-xx xx:xx 不同年份
                formatter.dateFormat = "yyyy-MM-dd"
            } else {
                // xx-xx 同一年
                formatter.dateFormat = "MM-dd"
            }
            res = formatter.stringFromDate(self)
        }
        return res
    }
}
