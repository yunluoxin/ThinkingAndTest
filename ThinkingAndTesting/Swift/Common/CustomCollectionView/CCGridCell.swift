//
//  CCGridCell.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/9.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCGridCell: UIView {
    
    enum State {
        /// 正常形态. 默认态
        case normal
        /// 收缩成组的状态(组化)
        case groupfying
    }
    
    /// 当前状态
    var state: State = .normal
    
    /// 子视图的容器。类似TableViewCell的contentView
    lazy var contentView: UIView = .init(frame: bounds)
    
    lazy var textLabel: UILabel = {
        let v = UILabel(frame: bounds)
        v.font = .systemFont(ofSize: 30, weight: .bold)
        v.textAlignment = .center
        return v
    }()
    
    /// 当前cell的关键缩略图的 截图
    var snapshotView: UIView?
    
    /// 组化时候，存放的子项cell
    var subCells: [CCGridCell] = []
    
    /// 组化时候的特别视图
    lazy var groupfyingView: CCGroupfyingView = {
        let v = CCGroupfyingView(frame: bounds)
        v.alpha = 0
        return v
    }()
        
    var item: CCItem? {
        didSet {
            guard let item = item else { return }
            contentView.backgroundColor = item.color
            textLabel.text = "\(item.index)"
        }
    }
    
    override var debugDescription: String {
        let index: Int = item?.index ?? 0
        return "frame = \(frame), index: \(index)"
    }
        
    required override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
        textLabel.frame = bounds
    }
    
    /// 准备复用
    func prepareForReuse()  {
        item = nil
        state = .normal
        alpha = 1
        transform = .identity
        snapshotView = nil
        groupfyingView.alpha = 0
    }
    
    /// 更新数据（子类记得调用父类的）
    func update(with item: CCItem) {
        self.item = item
    }
    
    func makeSelected(_ selected: Bool = true) {
        
    }
    
    
    // MARK: -
    
    /// 过渡到组状态
    /// - Parameter groupView: 手指按住的视图，也是收拢组的视图
    func transitionToGroup(_ groupView: CCGridCell) {
        snapshotView = textLabel.snapshotView(afterScreenUpdates: false)
        self.frame = groupView.groupfyingView.convert(bounds, to: superview)
        self.alpha = 0
    }
    
    func backToNormal(_ targetFrame: CGRect) {
        self.alpha = 1
        self.frame = targetFrame
        self.snapshotView = nil
    }
    
    // MARK: - 组操作
    
    func transitionToGroup() {
        guard state == .normal, let item = item else { return }
        state = .groupfying
        
        // 多选下，当前格子变成拖拽中心
        if !item.isGroup {
            transitionToDraggingCenter()
        }
        
        let height: CGFloat = 64
        let bottom: CGFloat = item.isGroup ? height : 0
        frame = frame.inset(by: UIEdgeInsets(top: 0, left: -8, bottom: -bottom, right: 0))
        item.rowHeight = frame.height
        contentView.addSubview(groupfyingView)
        let y: CGFloat = frame.height - height
        groupfyingView.frame = CGRect(x: 0, y: y, width: bounds.width, height: height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            
            // 先处理当前不是组头的特殊情况
            if !item.isGroup, let v = snapshotView {
                groupfyingView.container.addSubview(v)
            }
            
            for subCell in subCells {
                subCell.transitionToGroup(self)
                if let v = subCell.snapshotView {
                    v.backgroundColor = .green
                    groupfyingView.container.addSubview(v)
                }
            }
            
            groupfyingView.container.update()
            groupfyingView.alpha = 1
        } completion: { _ in
            
        }

    }
    
    /// 多选状态下，当前格子变成拖拽的中心（其他格子会收拢它身上)
    func transitionToDraggingCenter() {
        snapshotView = textLabel.snapshotView(afterScreenUpdates: false)
    }
    
    /// 解除组化状态
    func backToNormal(_ relayout: () -> Void) {
        guard state == .groupfying, let item = item else { return }
        state = .normal
        
        item.rowHeight = item.isGroup ? 30 : 64

        relayout()
        
        // 组可能移动了，这时候恢复的所有cell，也要从最新位置来
        for subCell in subCells {
            subCell.frame = groupfyingView.convert(groupfyingView.bounds, to: superview)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [self] in
            groupfyingView.alpha = 0
            
            for subCell in subCells {
                if let subItem = subCell.item {
                    subCell.backToNormal(subItem.frame)
                }
            }
            
            frame = item.frame

        } completion: { [self] _ in
            
            groupfyingView.removeFromSuperview()
            groupfyingView.container.reset()
            subCells = []
            
        }
    }
}


// MARK: -

class CCGroupfyingView: UIView {
    
    lazy var lineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return v
    }()
    
    lazy var container: CCSimpleArrangedView = {
        let v = CCSimpleArrangedView()
        v.spacing = 4
        return v
    }()
    
    lazy var sortView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .gray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(lineView)
        addSubview(container)
        addSubview(sortView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 0.5)
        let margin: CGFloat = 8
        container.frame = CGRect(x: margin, y: margin, width: 48, height: 48)
        let w: CGFloat = 16.0
        let x: CGFloat = bounds.width - w - margin
        sortView.frame = CGRect(x: x, y: 0, width: w, height: bounds.height)
    }
}
