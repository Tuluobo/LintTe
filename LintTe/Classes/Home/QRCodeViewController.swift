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
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
    @IBOutlet weak var customLabel: UILabel!
=======
>>>>>>> 完善二维码扫描
    // 扫描条图片
    @IBOutlet weak var scanLineImageView: UIImageView!
    // 扫描顶部约束
    @IBOutlet weak var scanLineTopCons: NSLayoutConstraint!
    // 扫描线高度约束
    @IBOutlet weak var scanLineHeightCons: NSLayoutConstraint!
    // MARK: - 懒加载
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
    /// 输入对象， 竖向为
=======
    /// 输入对象
>>>>>>> 完善二维码扫描
    private lazy var input: AVCaptureDeviceInput? = {
        let capture = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: capture)
    }()
    /// 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
    /// 输出对象
    private lazy var output: AVCaptureMetadataOutput =  {
        let op = AVCaptureMetadataOutput()
        // 在这里，参照坐标系和其他地方不一样
        // 在Apple iOS 中 一般以左上角为原点
        // 在这里，右上角为原点，主要是将iPhone 左转90度，转为横屏
        let viewFrame = self.view.frame
        let y = ((viewFrame.width - self.height)/2) / viewFrame.width
        let x = ((viewFrame.height - self.height)/2 - 60) / viewFrame.height
        let width = self.height / viewFrame.size.height
        let height = self.height / viewFrame.size.width
        
        op.rectOfInterest = CGRectMake(x, y, width, height)
        return op
    }()
    /// 预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        AVCaptureVideoPreviewLayer(session: self.session)
    }()
    // 绘制框图层
    private lazy var cornerLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        // 1. 创建图层
        layer.lineWidth = 2.0
        layer.strokeColor = UIColor.greenColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        return layer
    }()
=======
    /// 输入对象
    private lazy var output: AVCaptureMetadataOutput =  AVCaptureMetadataOutput()
    ///  预览图层
    private lazy var preview: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
>>>>>>> 完善二维码扫描
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
        
=======

>>>>>>> 完善二维码扫描
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
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
    // MARK: - 内部控制方法
=======
    
>>>>>>> 完善二维码扫描
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
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
        // 6.添加预览图层
        previewLayer.frame = view.frame
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        // 7. 将用于保存举行的图层添加到界面上
        view.layer.addSublayer(cornerLayer)
        // 8.开始扫描
        session.startRunning()
    }
    
=======
        // 6.开始扫描
        session.startRunning()
    }
    
    @IBAction func openGallery() {
        TTLog("")
    }

    @IBAction func closeQRcodeViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
>>>>>>> 完善二维码扫描
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
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
    // MARK: - 按钮操作
    /**
     打开相册
     */
    @IBAction func openGallery() {
        // 1.判断是否能够打开相册
        /*
         case PhotoLibrary  - 相册
         case Camera        - 相机
         case SavedPhotosAlbum - 图片库
         */
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        // 2.创建相册控制器
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        // 3.弹出相册控制器
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }

    @IBAction func closeQRcodeViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}
// MARK: - UIImagePickerControllerDelegate
extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        // 识别二维码
        // 1.创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        // 2.利用这个探测器探测数据
        let features = detector.featuresInImage(CIImage(image: image)!)
        // 3.去除探测数据
        TTLog(features)
        guard let urlStr = (features.last as? CIQRCodeFeature)?.messageString else { return }
        self.customLabel.text = urlStr
        // 注意：如果实现了这个方法，系统将不会自动关闭相册，需要我们执行下面的程序关闭相册
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

=======
    
}
>>>>>>> 完善二维码扫描
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
<<<<<<< 660485a20af690395469bf0bc213aee201b2bce2
        // 清空 cornerLayer 上的信息
        cornerLayer.path = UIBezierPath().CGPath
        // 处理扫描信息
        for object in metadataObjects {
            guard let dataObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as? AVMetadataMachineReadableCodeObject else { return }
            switch dataObject.type {
            case AVMetadataObjectTypeQRCode:
                // 1. 显示结果
                if customTabbar.selectedItem!.tag != 0 {
                    self.customLabel.text = "请选择二维码选项卡"
                    break
                }
                self.customLabel.text = dataObject.stringValue
                // 2. 对扫描的二维码描边
                drawLines(dataObject)
                break
            case AVMetadataObjectTypeEAN13Code:
                // 1. 显示结果
                if customTabbar.selectedItem!.tag != 1 {
                    self.customLabel.text = "请选择条形码选项卡"
                    break
                }
                self.customLabel.text = dataObject.stringValue
                // 2. 对扫描的二维码描边
                drawLines(dataObject)
                break
            default:
                break
            }
        }
    }
    /**
     二维码描边
     */
    private func drawLines(object: AVMetadataMachineReadableCodeObject) {
        
        guard let corners = object.corners as? [[String: AnyObject]] else {
            TTLog("字典数组转换失败")
            return
        }
        // 1. 创建UIBezierPath，绘制矩形
        let path = UIBezierPath()
        // 2. 将起点移动到某一个点
        var point = CGPointZero
        CGPointMakeWithDictionaryRepresentation(corners[0], &point)
        path.moveToPoint(point)
        // 3. 连接其他线
        CGPointMakeWithDictionaryRepresentation(corners[1], &point)
        path.addLineToPoint(point)
        CGPointMakeWithDictionaryRepresentation(corners[2], &point)
        path.addLineToPoint(point)
        CGPointMakeWithDictionaryRepresentation(corners[3], &point)
        path.addLineToPoint(point)
        // 4. 关闭路径
        path.closePath()
        cornerLayer.path = path.CGPath
=======
        metadataObjects.last
>>>>>>> 完善二维码扫描
    }
}
