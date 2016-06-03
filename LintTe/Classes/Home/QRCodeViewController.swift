//
//  QRCodeViewController.swift
//  LintTe
//
//  Created by WangHao on 16/6/3.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    var height: CGFloat!
    // 底部工具条
    @IBOutlet weak var customTabbar: UITabBar!
    // 扫描条图片
    @IBOutlet weak var scanLineImageView: UIImageView!
    // 扫描顶部约束
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    // 扫描线高度约束
    @IBOutlet weak var scanLineHeightCons: NSLayoutConstraint!
    // MARK: - 懒加载
    /// 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let capture = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: capture)
    }()
    /// 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    /// 输入对象
    private lazy var output: AVCaptureMetadataOutput =  AVCaptureMetadataOutput()
    ///  预览图层
    private lazy var preview: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置默认选择二维码
        customTabbar.selectedItem = customTabbar.items?.first
        height = scanLineHeightCons.constant
        // 设置 tabbar 代理
        customTabbar.delegate = self
        
        // 对摄像头开始扫描处理
        scanQRCode()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scanLineViewAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func scanQRCode() {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input) { return }
        // 2.判断输出能否添加到会话中
        if !session.canAddOutput(output) { return }
        // 3.添加输入输出到会话
        session.addInput(input)
        session.addOutput(output)
        // 4.设置输出能够解析的数据格式
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 5.设置监听输出解析的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        // 6.开始扫描
        session.startRunning()
    }
    
    @IBAction func openGallery() {
        TTLog("")
    }

    @IBAction func closeQRcodeViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func scanLineViewAnimation() {
        // 设置扫描波约束
        scanLineTopCons.constant = 0 - scanLineHeightCons.constant
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineTopCons.constant = self.scanLineHeightCons.constant
            self.view.layoutIfNeeded()
        }
        
    }
    
}
// MARK: - UITabBarDelegate
extension QRCodeViewController: UITabBarDelegate {
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        scanLineHeightCons.constant = (item.tag == 1) ? height/2 : height
        
        // 停止动画
        self.scanLineImageView.layer.removeAllAnimations()
        // 重新开启动画
        scanLineViewAnimation()
        // 强制更新UI
        view.layoutIfNeeded()
        
    }
}
// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    /**
     只要扫描到信息都会处理
     */
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        metadataObjects.last
    }
}
