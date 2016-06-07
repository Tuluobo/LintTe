//
//  QRCodeCreateViewController.swift
//  LintTe
//
//  Created by WangHao on 16/6/4.
//  Copyright © 2016年 Tuluobo. All rights reserved.
//

import UIKit
/// 生成二维码显示
class QRCodeCreateViewController: UIViewController {

    @IBOutlet weak var myQRcodeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的名片"
<<<<<<< 4b99738d24d8f79552df0780ce41942457eead4f
<<<<<<< 79cbabdfe3e6bad09fbbf6452540a620c0408bdd
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
=======
        
>>>>>>> 生成二维码 完成
=======
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
>>>>>>> access_token 获取
        
        createQRCode()
    }
    
    private func createQRCode() {
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 2.还原滤镜默认属性
        filter?.setDefaults()
        // 3.设置需要生成的二维码数据到滤镜
        filter?.setValue("秃萝卜".dataUsingEncoding(NSUTF8StringEncoding), forKey: "InputMessage")
        // 4.从滤镜中取出生成好的二维码
        guard let ciImage = filter?.outputImage else { return }
        myQRcodeImageView.image = createNonInterpolatedUIImageFromCIImage(ciImage, size: 200)
    }
    
    /**
     传入一个 CIImage 和尺寸 返回一个高清的图片UIImage
     
     - parameter image: 原 CIImage
     - parameter size:  尺寸
     
     - returns: 高清的 UIImage
     */
    private func createNonInterpolatedUIImageFromCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent = CGRectIntegral(image.extent)
        let scale = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)
        
        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        // 2.保存bitmap到图片
        let scaledImage = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
}
