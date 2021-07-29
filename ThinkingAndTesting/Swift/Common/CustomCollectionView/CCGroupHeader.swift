//
//  CCGroupHeader.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/28.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCGroupHeader: CCGridCell {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var item: CCItem? {
        didSet {
            textLabel.text = "Group"
        }
    }
}
