//
//  CGAffineTransform+Extension.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/12/29.
//  Copyright © 2020 dadong. All rights reserved.
//

import Foundation

extension CGAffineTransform {
    
    /// 从transform里获取对应的弧度
    /// - Returns: 弧度
    var radian: CGFloat { atan2(b, a) }
    
    /// 从transform里获取对应的角度
    /// - Returns: 角度
    var angle: CGFloat { radian * (180.0 / CGFloat.pi) }
    
    /// 通过弧度初始化一个transform
    /// - Parameter radian: 弧度
    init(radian: CGFloat) {
        self.init()
        rotated(by: radian)
    }
    
    /// 通过角度初始化一个transform
    /// - Parameter angle: 角度
    init(angle: CGFloat) {
        let radian: CGFloat = angle / 180.0 * CGFloat.pi
        self.init(radian: radian)
    }
}
