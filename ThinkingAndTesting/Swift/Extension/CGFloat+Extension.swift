//
//  CGFloat+Extension.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/12/28.
//  Copyright © 2020 dadong. All rights reserved.
//

import Foundation

extension CGFloat {
    
    var intValue: Int { Int(self) }
    
    var floatValue: Float { Float(self) }

    var doubleValue: Double { Double(self) }
    
    var stringValue: String { "\(self)" }
}
