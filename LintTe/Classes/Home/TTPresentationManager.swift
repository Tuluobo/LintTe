//
//  TTPresentationManager.swift
//  LintTe
//
//  Created by WangHao on 16/6/3.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit

class TTPresentationManager: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    private var isPresent = false
    var presentFrame = CGRectZero
    
    // MARK: - UIViewControllerTransitioningDelegate delegate
    // 该方法用于返回一个负责转场的动画，修改尺寸等
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let tpc = TTPresentationController(presentedViewController: presented, presentingViewController: presenting)
        tpc.presentFrame = presentFrame
        return tpc
    }
    
    // 负责转场出现的方式
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        // 发送一个通知，告诉调用者状态发生改变
        NSNotificationCenter.defaultCenter().postNotificationName(TTPresentationManagerDidPresentedController, object: self)
        return self
    }
    
    // 负责转场出消失的方式
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        // 发送一个通知，告诉调用者状态发生改变
        NSNotificationCenter.defaultCenter().postNotificationName(TTPresentationManagerDidDismissedController, object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning delegate
    // 负责系统的展现消失时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    /**
     // 专门负责管理Modal如何展现和消失
     // 注意：只要实现了这个代理方法，那么系统就不会再有默认的动画了，
     //      从上至下的移动系统不再帮我们添加,所有的动画有我们实现
     
     - parameter transitionContext: 所有的动画需要的参数都包含在这个参数中
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            // 展现
            self.willPresentedController(transitionContext)
        } else {
            // 消失
            self.willDismissedController(transitionContext)
        }
    }
    
    // MARK: - 内部实现方法
    /**
     实现展示方法
     
     - parameter transitionContext:
     */
    private func willPresentedController(transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取需要弹出的视图
        guard let toView = transitionContext.viewForKey(UITransitionContextToViewKey) else { return }
        // 2、将需要弹出的视图添加到containerView
        transitionContext.containerView()?.addSubview(toView)
        // 3、执行动画
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        toView.layer.anchorPoint = CGPointMake(0.5, 0)
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toView.transform = CGAffineTransformIdentity
        }) { ( _ ) in
            // 自定义转场动画，在执行完毕一定要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     实现消失方法
     
     - parameter transitionContext:
     */
    private func willDismissedController(transitionContext: UIViewControllerContextTransitioning) {
        // 1、获取需要弹出的视图
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) else { return }
        // 2、执行动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            // CGAffineTransformMakeScale(1.0, 0.0) 设置导致动画直接消失，原因在于CGFloat不够准确
            // 只需要将CGFlopat设置为很小的值0.0001
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
        }) { ( _ ) in
            // 自定义转场动画，在执行完毕一定要告诉系统动画执行完毕
            transitionContext.completeTransition(true)
        }

    }
}

