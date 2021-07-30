//
//  CCGroupCell.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/23.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCGroupCell: CCTableViewCell {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        var rect = frame
        rect.size.height = 30
        let header = UIView(frame: rect)
        addSubview(header)
        
        contentView.frame.origin.y = header.frame.maxY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayouts(animated: Bool = true) {
        let duration: TimeInterval = animated ? 0.35 : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            var y: CGFloat = 0
            contentView.subviews.forEach { view in
                view.frame.origin.y = y
                y = y + view.bounds.maxY
            }
            
            var bounds = self.bounds
            bounds.size.height = y
            contentView.bounds = bounds
            
            bounds = contentView.bounds
            bounds.size.height = contentView.frame.maxY
            self.bounds = bounds
            
        } completion: { _ in
            
        }
    }
}
