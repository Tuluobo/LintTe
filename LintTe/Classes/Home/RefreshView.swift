//
//  RefreshView.swift
//  LintTe
//
//  Created by WangHao on 16/6/12.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

enum TTRefreshState {
    case UP, DOWN, DOING
}

class RefreshView: UIView {

    // 转圈显示
    @IBOutlet weak var arrowImageView: UIImageView!
    // 提示文字
    @IBOutlet weak var lodingTextLabel: UILabel!

    class func refreshView() -> RefreshView {
        return R.nib.refreshView.firstView(owner: nil, options: nil)!
    }
    
    // MARK: - 外部控制方法
    func rotationArrow(state: TTRefreshState) {
        switch state {
        case .UP:
            lodingTextLabel.text = "释放更新..."
            /*
             *  transform 默认是按顺时针旋转，
             *  但是旋转还有一个就近原则，最近方向旋转
             */
            UIView.animateWithDuration(0.5, animations: {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI)+0.0001)
            })
       case .DOWN:
            lodingTextLabel.text = "下拉刷新..."
            UIView.animateWithDuration(0.5, animations: {
                self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, CGFloat(M_PI)-0.0001)
            })
        case .DOING:
            break
        }
    }
    
}

// 刷新控件
class TTRefreshControl: UIRefreshControl {
    
    // 懒加载
    private lazy var refreshView: RefreshView = RefreshView.refreshView()
    
    override init() {
        super.init()
        // 添加子控件
        self.addSubview(refreshView)
        refreshView.center = self.center
        // 监听frame 改变
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
    }
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 记录是否需要旋转
    private var rotationFlag = true
    // 监听方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // 过滤到系统初始化数据
        if frame.origin.y == 0 || frame.origin.y == -64 {
            return
        }
        // 直接在监听对象中可以直接使用此属性
        if frame.origin.y < -60 && rotationFlag {
            rotationFlag = !rotationFlag
            refreshView.rotationArrow(.UP)
        } else if frame.origin.y > -60 && !rotationFlag {
            rotationFlag = !rotationFlag
            refreshView.rotationArrow(.DOWN)
        }
    }
}