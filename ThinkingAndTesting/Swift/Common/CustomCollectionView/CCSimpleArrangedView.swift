//
//  CCSimpleArrangedView.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/29.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCSimpleArrangedView: UIView {
    
    /// 间隔
    var spacing: CGFloat = 0
    
    func update() {
        let maxCols: Int = 2
        let vs = subviews.prefix(4)
        let w: CGFloat = 22
        for (i, v) in vs.enumerated() {
            let col: Int = i % maxCols
            let row: Int = i / maxCols
            let x: CGFloat = (w + spacing) * CGFloat(col)
            let y: CGFloat = (w + spacing) * CGFloat(row)
            v.frame = CGRect(x: x, y: y, width: w, height: w)
            if v.superview == nil {
                addSubview(v)
            }
        }
    }
    
    func reset() {
        subviews.forEach { v in
            v.removeFromSuperview()
        }
    }
}
