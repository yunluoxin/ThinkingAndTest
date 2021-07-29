//
//  CCGroupHeader.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/28.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCGroupHeader: CCGridCell {
    
    /// 组化时候，存放的子项cell
    var subCells: [CCGridCell] = []
    
    lazy var container: CCSimpleArrangedView = {
        let v = CCSimpleArrangedView()
        v.spacing = 4
        v.alpha = 0
        return v
    }()
    
    lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return v
    }()
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subCells = []
    }
    
    override var item: CCItem? {
        didSet {
            textLabel.text = "Group"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: 30, width: bounds.width, height: 0.5)
        if state == .groupfying {
            textLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 30)
        }
    }
    
    func transitionToGroup() {
        guard state == .normal, let item = item else { return }
        state = .groupfying
        
        let height: CGFloat = 80
        frame = frame.inset(by: UIEdgeInsets(top: 0, left: -2, bottom: -height, right: 0))
        item.rowHeight = frame.height
        addSubview(container)
        container.frame = CGRect(x: 0, y: lineView.frame.maxY + 8, width: 48, height: height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            for subCell in subCells {
                subCell.transitionToGroup(self)
                if let v = subCell.snapshotView {
                    v.backgroundColor = .green
                    container.addSubview(v)
                }
            }
            
            container.update()
            container.alpha = 1
        } completion: { _ in
            
        }

    }
    
    /// 解除组化状态
    func backToNormal(_ relayout: () -> Void) {
        guard state == .groupfying, let item = item else { return }
        state = .normal
        
        item.rowHeight = 30

        relayout()
        
        // 组可能移动了，这时候恢复的所有cell，也要从最新位置来
        for subCell in subCells {
            subCell.frame = container.convert(container.bounds, to: superview)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            container.alpha = 0
            
            for subCell in subCells {
                if let subItem = subCell.item {
                    subCell.backToNormal(subItem.frame)
                }
            }
            
            frame = item.frame

        } completion: { _ in
            
        }
        
        container.removeFromSuperview()
        container.reset()
    }
}
