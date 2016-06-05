//
//  Defines.swift
//  LintTe
//
//  Created by WangHao on 15/10/19.
//  Copyright © 2015年 Tuluobo. All rights reserved.
//

import Foundation

// 自定义Log
func TTLog<T>(message: T, fileName: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let filename = (fileName as NSString).pathComponents.last
    print("\(filename!)\(function)[\(lineNumber)]: \(message)")
    #endif
}

struct Defines {
    //微博
    static let wbAppKey = "4163659967"
    static let wbSecretKey = "7e0dcda944e8d673ad50051cefe61fde"
    static let wbRedirectURI = "https://api.weibo.com/oauth2/default.html"
    //友盟
    static let umAppKey = "5621015ee0f55a2264002ef4"
}

struct Accounts {
    static let UserIDKey = "UserID"
    static let ATKey = "access_token"
    static let RTKey = "refresh_token"
    static let ExDate = "expirationDate"
}



