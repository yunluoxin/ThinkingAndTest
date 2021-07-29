//
//  CGRect+Extension.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/6.
//  Copyright © 2021 dadong. All rights reserved.
//

import Foundation

extension CGRect {
    
    /// 中心点
    var center: CGPoint {
        CGPoint(x: origin.x + width / 2.0,
                y: origin.y + height / 2.0)
    }
}
