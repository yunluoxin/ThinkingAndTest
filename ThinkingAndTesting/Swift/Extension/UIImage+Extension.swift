//
//  UIImage+Extension.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/1/31.
//  Copyright © 2021 dadong. All rights reserved.
//

import Foundation

extension UIImage {
    
    /// 调整图片大小
    /// - Parameter width: 调整到的宽度（高度根据比例设置，这样不变形)
    /// - Returns: 新图片
    func resize(to width: CGFloat) -> UIImage? {
        let newHeight = size.height / size.width * width
        let newBounds = CGRect(x: 0, y: 0, width: width, height: newHeight)
        
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer(size: newBounds.size)
            let image = render.image { (context) in
                self.draw(in: newBounds)
            }
            return image
        } else {
            UIGraphicsBeginImageContext(newBounds.size)
            self.draw(in: newBounds)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    /// 增加圆角
    /// - Parameters:
    ///   - corners: 圆角的方向
    ///   - radius: 圆角直径
    /// - Returns: 新的圆角图片
    func addRoundingCorners(_ corners: UIRectCorner, radius: CGFloat) -> UIImage? {
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let renderProcess = {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            
            // 裁剪之后，当前上下文就裁剪出来的区域添加的东西可以展示，其他会看不到
            path.addClip()
            
            // 所以需要先裁剪，再绘制图片
            self.draw(in: bounds)
        }
        
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer(size: size)
            let image = render.image { (ctx) in
                renderProcess()
            }
            return image
        } else {
            UIGraphicsBeginImageContext(size)
            renderProcess()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    /// Downsampling large images for display at smaller size
    /// 创建缩略图
    /// - Parameters:
    ///   - imageURL: 图片地址URL
    ///   - pointSize: 大小
    ///   - scale: (一般是屏幕scale)
    /// - Returns: 缩略图
    func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
        
        let maxDimensionInPixels: CGFloat = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        if let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) {
            return UIImage(cgImage: downsampledImage)
        }
        return nil
    }
}
