//
//  StackView.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/12/26.
//  Copyright © 2020 dadong. All rights reserved.
//

import Foundation
import SnapKit

/// 模型. 记录状态，驱动cell的显示
public class StackViewItem: NSObject {
    public var changed = false
    public var enabled = true
    public var selected = false
    public var itemSize: CGSize = .zero
//    public var maginLeft: Double = 0
//    public var marginRight: Double = 0
}

/// 选中的样式
public enum StackViewSelectionStyle: Int {
    /// 自定义 (自己处理)
    case custom = 0
    /// 单选 + 可以反选. (在选中一个的情况下，无法选择其他项，必须先取消当前选中)
    /// 类似 使用优惠券只能使用一张，你已经选择一张优惠券情况下，想要切换其他优惠券就必须取消上一个优惠券
    case one
    /// 单选 + 无法反选.
    /// 类似单选框，只能选择一项. (点击另外的，会被切换到其他项, 也是和 one 的最大区别)
    case radio
    /// 多选 + 可以反选.
    /// 类似多选框, 可以选择多项，也能被反选
    case checkbox
}


public class StackView<T: StackViewItem>: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// 格子的基类
    public class Cell: UICollectionViewCell {
        /// data
        public var item: T?
        /// 刷新UI(主动刷新某个格子的，不是来自`reloadData`的)
        public func refreshUI() {
            let tmp = item
            item = tmp
        }
    }
    
    /// cell注册标识
    private let identifier: String = "Cell"
    
    /// collectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = contentInset
        
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.register(Cell.self, forCellWithReuseIdentifier: identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = false
        cv.alwaysBounceHorizontal = false
        if #available(iOS 11.0, *) {
            cv.contentInsetAdjustmentBehavior = .never
        }
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    /// 数据源
    public var items: [T] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    /// 注册cell类型
    public var cellType: Cell.Type = Cell.self {
        didSet {
            collectionView.register(cellType, forCellWithReuseIdentifier: identifier)
        }
    }
    
    /// 相当于padding
    public var contentInset: UIEdgeInsets = .zero {
        didSet {
            updateLayout()
        }
    }
    
    /// 间距
    public var spacing: Double = 0 {
        didSet {
            updateLayout()
        }
    }
    
    /// 滚动方向. 默认为横向
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            updateLayout()
        }
    }
    
    /// 背景色
    public override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    /// 选中风格. 默认是`.custom`，即自定义
    /// - Warning 设置非`.custom`后会导致cell的`selected`字段数据和UI自动处理！
    public var selectionStyle: StackViewSelectionStyle = .custom
    
    /// 是否可以点击的回调
    public var shouldSelectAt: ((T) -> Bool)?
    /// 点击回调
    public var didSelectAt: ((Cell, T) -> Void)?
    
    /// 更新布局
    private func updateLayout() {
        layout.scrollDirection = scrollDirection
        layout.sectionInset = contentInset
        if scrollDirection == .horizontal {
            layout.minimumLineSpacing = CGFloat(spacing)
            layout.minimumInteritemSpacing = 0
        } else {
            layout.minimumInteritemSpacing = CGFloat(spacing)
            layout.minimumLineSpacing = 0
        }
    }
    
    /// layout
    private var layout: UICollectionViewFlowLayout {
        collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    

    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.row]
        return item.itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
        cell.item = item
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.changed {
            item.changed = false
            (cell as? Cell)?.refreshUI()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = items[indexPath.row]

        if selectionStyle != .custom {
            let its = findSelectedItems()
            if selectionStyle == .one {
                if its.count > 1 { return false }
                // 已经选中一个情况下，只能被反选
                if its.count == 1, its.first != item { return false }
            } else if selectionStyle == .radio {
                if its.count > 1 { return false }
                // 已经选中自身情况下，不能被反选
                if its.count == 1, its.first == item { return false }
            }
        }
        
        if let cb = shouldSelectAt {
            return cb(item)
        }
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        if selectionStyle != .custom {
            let its = findSelectedItems()
            if selectionStyle == .one {
                if its.count == 1 {
                    // 反选
                    unselectedOthers(except: nil)
                } else {
                    // 直接选中
                    item.selected = true
                    item.changed = true
                }
            } else if selectionStyle == .radio {
                // 直接选中
                item.selected = true
                item.changed = true
                
                if its.count == 1 {
                    // 取消其他的选中
                    unselectedOthers(except: item)
                }
            } else if selectionStyle == .checkbox {
                if item.selected {
                    // 反选
                    item.selected = false
                    item.changed = true
                } else {
                    // 直接选中
                    item.selected = true
                    item.changed = true
                }
            }
            
            refreshUIIfNeeded()
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? Cell {
            didSelectAt?(cell, item)
        }
    }
    
    /// 反选其他的数据，除了某个item
    /// - Parameter it: 排除的item， 不会处理这个item
    private func unselectedOthers(except it: T?) {
        items.forEach { (item) in
            if item != it {
                let before = item.selected
                item.selected = false
                item.changed = (before != item.selected)
            }
        }
    }
    
    /// 批量刷新UI
    private func refreshUIIfNeeded() {
        items.enumerated().forEach { (index, item) in
            let indexPath = IndexPath(item: index, section: 0)
            if item.changed, let cell = collectionView.cellForItem(at: indexPath) as? Cell {
                item.changed = false
                cell.refreshUI()
            }
        }
    }
}


// MARK: - Public

extension StackView {
    
    /// 查找当前选中items
    public func findSelectedItems() -> [T] {
        items.filter { $0.selected }
    }
    
    /// 刷新数据和UI
    public func reloadData() {
        collectionView.reloadData()
    }
}
