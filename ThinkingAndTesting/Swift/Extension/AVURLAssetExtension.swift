//
//  AVURLAssetExtension.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2021/1/14.
//  Copyright © 2020 dadong. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension AVURLAsset {
    
    /// 获取视频封面图
    func cover() -> UIImage? {
        // 视频第0秒处即第一帧
        let requestTime = CMTime(seconds: 0, preferredTimescale: 600)
        let generator = AVAssetImageGenerator(asset: self)
        // 设定缩略图的方向，如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        generator.appliesPreferredTrackTransform = true
        if let cgImage = try? generator.copyCGImage(at: requestTime, actualTime: nil) {
            let image = UIImage(cgImage: cgImage)
            return image
        }
        return nil
    }
}
