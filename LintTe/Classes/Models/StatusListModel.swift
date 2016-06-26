//
//  StatusListModel.swift
//  LintTe
//
//  Created by MaSixin on 6/26/16.
//  Copyright © 2016 Tuluobo. All rights reserved.
//

import UIKit
import SDWebImage

class StatusListModel: NSObject {

    var statuses = [StatusViewModel]()
    
    /**
     加载微博数据
     */
    func loadData(lastFlag: Bool, completed: (statusVMs:[StatusViewModel]?, error: NSError?) -> ()) {
        
        var since_id = statuses.first?.status.idstr
        var last_id = statuses.last?.status.idstr
        if lastFlag {
            since_id = nil
        } else {
            last_id = nil
        }
        NetworkManager.shareInstance.loadStatuses(since_id, max_id: last_id) { (array, error) in
            if error != nil {
                completed(statusVMs: nil, error: error);
                return
            }
            
            var cacheStatusVM = [StatusViewModel]()
            for item in array! {
                let statusVM = StatusViewModel(status: Status(dict: item))
                cacheStatusVM.append(statusVM)
            }
            // 缓存图片数据
            self.cachesImages(cacheStatusVM, completed: completed)
            // 更新数据源
            if lastFlag {
                // 下面加载
                self.statuses = self.statuses + cacheStatusVM
            } else {
                // 上面加载
                self.statuses = cacheStatusVM + self.statuses
            }
        }
    }
    
    /**
     缓存微博配图
     
     - parameter models: 模型数据
     */
    private func cachesImages(viewModels: [StatusViewModel], completed: (statusVMs:[StatusViewModel]?, error: NSError?) -> ()) {
        
        // 创建一个线程组
        let group = dispatch_group_create()
        
        for vm in viewModels {
            // 1.从 viewmodel 取出图片url数组
            // 2.遍历数组下载图片
            for url in vm.thumbnail_pics {
                // 1将当前的下载添加到组中
                dispatch_group_enter(group)
                // 2 下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue:0), progress: nil, completed: { (image, error, _, _, _) in
                    // 将当前下载从组中移除
                    dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            completed(statusVMs: viewModels, error:  nil)
        }
    }

    
    
    
    
}
