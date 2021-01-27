//
//  Int+Extension.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/12/28.
//  Copyright © 2020 dadong. All rights reserved.
//

import Foundation

extension Int {
    
    var int32Value: Int32 { Int32(self) }
    
    var floatValue: Float { Float(self) }

    var doubleValue: Double { Double(self) }
    
    var cgFloatValue: CGFloat { CGFloat(self) }
    
    var stringValue: String { String(self) }

    var boolValue: Bool {
        return self != 0
    }

}
