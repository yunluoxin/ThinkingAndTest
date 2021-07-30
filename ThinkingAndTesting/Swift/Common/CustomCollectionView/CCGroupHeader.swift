//
//  CCGroupHeader.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/28.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCGroupHeader: CCTableViewCell {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override var item: CCItem? {
        didSet {
            textLabel.text = "Group"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if state == .groupfying {
            textLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 30)
        }
    }
}
