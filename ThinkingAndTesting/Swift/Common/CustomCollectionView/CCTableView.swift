//
//  CCTableView.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/9.
//  Copyright © 2021 dadong. All rights reserved.
//

import Foundation

class CCTableView: UIScrollView {
    
    let pool: CCReusePool = .init()
    
    let contentView: UIView = .init(frame: .zero)
        
    var items: [CCItem] = []
    
    /// 长按中的cell
    var longPressedCell: CCTableViewCell?
    /// 最后一次拖拽离开时候的indexPath
    private var lastTimeRemovedIndexPath: IndexPath?
    /// 长按的中心点和开始拖动时候cell中心点的偏移
    private var draggingOffset: CGPoint = .zero
    /// 拖拽组时候，contentOffset/contentInset改变的偏移量
    private var dragGroupOffset: (top: CGFloat, bottom: CGFloat) = (0,0)
    
    /// 边缘计时器
    private var edgeTimer: CADisplayLink?
    /// 进入边缘滚动时候的滚动方向
    private var direction: MoveDirection = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
        addSubview(contentView)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(actionLongPress))
        longPress.minimumPressDuration = 0.4
        addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func reloadData() {
        contentView.subviews.forEach { view in
            view.removeFromSuperview()
            if let v = view as? CCTableViewCell {
                pool.returnCell(v)
            } else if let v = view as? CCGroupHeader {
                pool.returnCell(v)
            }
        }
        
        let mapping: [Int: CCTableViewCell.Type] = [
            1 : CCTableViewCell.self,
            2 : CCGroupHeader.self
        ]
        
        items.forEach { item in
            if let t = mapping[item.kind] {
                let cell = pool.dequeueCell(for: t)
                cell.update(with: item)
                contentView.addSubview(cell)
                item.cell = cell
            } else {
                assert(false, "找不到kind:\(item.kind)对应的类型的cell！")
            }
        }
        
        updateLayouts(animated: false)
    }
    
    func updateLayouts(animated: Bool = true) {
        let duration: TimeInterval = animated ? 0.35 : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            var y: CGFloat = 0
            items.forEach { item in
                if let view = item.cell {
                    var frame: CGRect = self.bounds
                    frame.origin.y = y
                    frame.size.height = item.rowHeight
                    item.frame = frame
                    if view !== longPressedCell {
                        view.frame = frame
                    }
                    y = frame.maxY
                }
            }
            
            let frame: CGRect = .init(x: 0, y: 0, width: bounds.width, height: y)
            contentView.frame = frame
            contentSize.height = frame.height
        } completion: { _ in
            
        }
    }
}


// MARK: - Actions

extension CCTableView {
    
    /// 点击手势的回调
    @objc
    private func actionTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: contentView)
        if let cell = cell(at: point),
           let indexPath = indexPath(for: cell),
           shouldSelect(cell: cell, at: indexPath) {
            self.didSelect(cell: cell)
        }
    }
    
    /// 长按手势的回调
    @objc
    private func actionLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            longPressGestureBegan(gesture)
        case .changed:
            longPressGestureChanged(gesture)
        case .ended, .cancelled, .failed:
            longPressGestureEnded(gesture)
        default:
            break
        }
    }
    
    /// 长按手势开始
    private func longPressGestureBegan(_ gesture: UIGestureRecognizer) {
        let oldContentOffset = contentOffset
        let point = gesture.location(in: contentView)
        guard let cell = self.cell(at: point), let item = cell.item, item.isAllowDragged else { return }
        draggingOffset = CGPoint(x: cell.center.x - point.x,
                                 y: cell.center.y - point.y)
        longPressedCell = cell
        makeViewFloat(cell)

        let oldHeight = heightOfCellsBeforeDraggingCell()
        print("oldConH\(contentSize), contentOffset: \(contentOffset)")

        // 组操作
        if let groupView = cell as? CCGroupHeader { // 长按在组头上
            let subCells = cells(in: groupView)
            groupView.subCells = subCells
            groupView.transitionToGroup()
            for subCell in subCells {
                if let subItem = subCell.item {
                    items.remove(subItem)
                }
            }
            updateLayouts()
            
            /** 拖动在组头时候，组头会变大，导致cell中心点改变，需要重新计算一次 */
            draggingOffset = CGPoint(x: cell.center.x - point.x,
                                     y: cell.center.y - point.y)
            
            let newHeight = heightOfCellsBeforeDraggingCell()
            didBeginDraggingGroup(from: oldHeight, and: oldContentOffset, to: newHeight)
            
        } else if let f = item.layerInfo as? FocusableLayerInfo, let group = f.group, group.state == .editing {   // 长按在组内元素上
            let subCells = cellsInSameGroup(with: cell)
            cell.subCells = subCells
            cell.transitionToGroup()
            for subCell in subCells {
                if subCell !== cell, let subItem = subCell.item {
                    items.remove(subItem)
                }
            }
            updateLayouts()
            
            let newHeight = heightOfCellsBeforeDraggingCell()
            didBeginDraggingGroup(from: oldHeight, and: oldContentOffset, to: newHeight)
        }
    }
    
    /// 长按手势处于`changed`状态中
    private func longPressGestureChanged(_ gesture: UIGestureRecognizer) {
        // 计算并设置新位置
        let point = gesture.location(in: contentView)
        let newCenter = CGPoint(x: draggingOffset.x + point.x,
                                y: draggingOffset.y + point.y)
        longPressedCell?.center = newCenter
        
        longPressedCellMoved()
    }
    
    /// 长按的cell移动后的具体操作: 腾出空格、删除空格等
    private func longPressedCellMoved() {
        guard let cell = longPressedCell, let item = cell.item else { return }
        
        if cell.frame.maxX < 0 {    // 移动到外面，则进行删除
            if let index = items.firstIndex(where: { $0 === item }) {
                items.remove(at: index)
                lastTimeRemovedIndexPath = IndexPath(row: index, section: 0)
                updateLayouts()
            }
        } else {
            if let index = items.firstIndex(where: { $0 === item }) {
                let sourceIndexPath = IndexPath(row: index, section: 0)
                let targetIndexPath = insertPosition(for: cell)
                if shouldInsert(at: targetIndexPath) {
                    moveCell(from: sourceIndexPath, to: targetIndexPath)
                } else {
//                    print("dd: 不能交互，被忽略！")
                }
            } else {
                if let targetIndexPath = insertPostionWhenGestureChanged(),
                    shouldInsert(at: targetIndexPath) {
                    insert(item: item, at: targetIndexPath)
                    lastTimeRemovedIndexPath = nil
                }
            }
        }
        
        // 边缘检测
        edgeCheck()
    }
    
    /// 长按手势结束
    private func longPressGestureEnded(_ gesture: UIGestureRecognizer) {
        guard let cell = longPressedCell, let item = cell.item else { return }
        
        var removed = false
        if cell.frame.maxX < -bounds.width / 2 {
            removed = true
            // 超过一定比例，真删
            UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut) {
                cell.transform = .init(scaleX: 0.3, y: 0.3)
                cell.alpha = 0
            } completion: { _ in
                cell.removeFromSuperview()
            }

        } else if let ip = lastTimeRemovedIndexPath  {
            // 回到原位
            insert(item: item, at: ip)
        }
        
        // 手放开的是组
        if !removed, let index = items.firstIndex(of: item) {
            let targetIndex: Int = index + 1
            if let groupView = item.cell as? CCGroupHeader {
                groupView.backToNormal {
                    for subCell in groupView.subCells.reversed() {
                        if let subItem = subCell.item {
                            items.insert(subItem, at: targetIndex)
                        }
                    }
                    updateLayouts(animated: false)
                }
                
                didEndDraggingGroup()
                
            } else if let f = item.layerInfo as? FocusableLayerInfo, f.group != nil {
                cell.backToNormal {
                    var after = true
                    for subCell in cell.subCells.reversed() {
                        if subCell === cell {
                            after = false
                            continue
                        }
                        if let subItem = subCell.item {
                            let i: Int = after ? targetIndex : index
                            items.insert(subItem, at: i)
                        }
                    }
                    updateLayouts(animated: false)
                }
                
                didEndDraggingGroup()
            }
        }
        
        longPressedCell = nil
        updateLayouts()
        makeViewFloat(cell, isFloat: false)

        lastTimeRemovedIndexPath = nil
        
        endEdgeTimer()
    }
    
    /// 开始拖动组
    private func didBeginDraggingGroup(from oldHeight: CGFloat, and oldContentOffset: CGPoint, to newHeight: CGFloat) {
        guard let cell = longPressedCell else { return }
        let offset = newHeight - oldHeight
        var newContentOffset = oldContentOffset
        if offset < 0 {
            cell.center.y += offset
            contentInset.top -= offset

            newContentOffset.y += offset
            setContentOffset(newContentOffset, animated: true)
        } else {
            setContentOffset(newContentOffset, animated: true)
        }
        
        print(newContentOffset)
        print("newConH\(contentSize)")
        var delta = newContentOffset.y - (contentSize.height - bounds.height)
        print(delta)
        if delta >= 0 {
            contentInset.bottom += delta
        } else {
            delta = 0
        }
        
        dragGroupOffset = (offset, delta)
    }
    
    /// 拖动组结束
    private func didEndDraggingGroup() {
        if dragGroupOffset.bottom != 0 {
            contentInset.bottom -= dragGroupOffset.bottom
        }
        
        if dragGroupOffset.top != 0 {
            longPressedCell?.center.y -= dragGroupOffset.top
            contentInset.top += dragGroupOffset.top
            
            var newContentOffset = contentOffset
            newContentOffset.y -= dragGroupOffset.top
            setContentOffset(newContentOffset, animated: true)
        }
        
        dragGroupOffset = (0, 0)
    }
    
    /// 当前拖动cell上面的格子的高度
    private func heightOfCellsBeforeDraggingCell() -> CGFloat {
        guard let item = longPressedCell?.item else { return 0 }
        return item.frame.minY
    }
}


// MARK: - Private

extension CCTableView {
    
    /// 计算：手势拖动中时候， 从外部（离开列表）到想要重新插入到列表时候，插入的位置
    /// - Returns: 插入的位置
    /// - Warning: 手在外面直接放开的，不是走这里！！！那是回到离开时候的位置！
    private func insertPostionWhenGestureChanged() -> IndexPath? {
        guard let draggingCell = longPressedCell else { return nil }
        /**
         拖走后再放入，放在哪个的原则：计算要插入的格子中心点和它覆盖的格子中心点的远近
         */
        let intersectionCells = findIntersectCells(of: draggingCell)
//        print("dd: 交叉的格子是 \(intersectionCells)")
        var minSpacing: CGFloat?    // 最小间距
        var tmpCell: CCTableViewCell?    // 最小间距的cell
        for cell in intersectionCells {
            let space: CGFloat = abs(draggingCell.center.y - cell.center.y)
            if let tmp = minSpacing {
                if space < tmp {
                    minSpacing = space
                    tmpCell = cell
                }
            } else {
                minSpacing = space
                tmpCell = cell
            }
        }
        
        if let cell = tmpCell, let indexPath = self.indexPath(for: cell) {
//            print("dd: 最小的格子是 \(cell), indexPath: \(indexPath)")
            let up: Bool = (draggingCell.center.y < cell.center.y)
//            print("dd: 插入到 \(up ? "向上" : "向下")")
            return getIndexPath(from: indexPath, for: up)
        }
        return nil
    }
    
    func insertPosition(for draggingCell: CCTableViewCell) -> IndexPath {
        var before: CCItem?
        var cell: CCItem?
        var row: Int = 0
        let centerY = draggingCell.center.y
        for (index, item) in items.enumerated() {
            if item.frame.midY > centerY {
                cell = item
                row = index
                break
            }
            before = item
        }
        
        guard let before = before else {
            return IndexPath(row: 0, section: 0)
        }
        
        guard let cell = cell else {
            return IndexPath(row: items.count, section: 0)
        }
        
        let distance: CGFloat = abs(cell.frame.midY - before.frame.midY)
        let threshold = CGPoint(x: (before.frame.midX + cell.frame.midX) / 2,
                                y: (before.frame.midY + cell.frame.midY) / 2)
        // 拖动的格子太小，直接就是当前两者之间
        if distance > draggingCell.bounds.height {
            return IndexPath(row: row, section: 0)
        }
        
        if centerY < threshold.y {
            row -= 1
            row = max(0, row)
            return IndexPath(row: row, section: 0)
        } else {
            return IndexPath(row: row + 1, section: 0)
        }
    }
    
    /// 获取基于某个indexPath向上或者向下后的新indexPath
    /// - Parameters:
    ///   - from: 基于的indexPath(拖动的cell交叉到的cell的)
    ///   - up: 是否向上插入
    private func getIndexPath(from: IndexPath, for up: Bool) -> IndexPath {
        if up { return from }
        return IndexPath(row: from.row + 1, section: 0)
    }
    
    /// 在某个位置处插入一个元素
    private func insert(item: CCItem, at indexPath: IndexPath) {
        items.insert(item, at: indexPath.row)
        updateLayouts()
    }
    
    /// 交换两个cell
    private func swap(cell: CCTableViewCell, with another: CCTableViewCell) {
        guard let item = cell.item, let anotherItem = another.item else { return }
        items.swap(item, with: anotherItem)
        updateLayouts()
    }
    
    /// 把 sourceIndexPath 处的 cell，移动到 targetIndexPath 处
    /// - Parameters:
    ///   - sourceIndexPath: 原位置
    ///   - targetIndexPath: 目标位置 （没有删除source时候计算的）
    func moveCell(from sourceIndexPath: IndexPath, to targetIndexPath: IndexPath) {
        if sourceIndexPath == targetIndexPath {
//            print("同样offset, return")
            return
        }
//        print("source:\(sourceIndexPath), target: \(targetIndexPath)")
        if targetIndexPath.row > sourceIndexPath.row {
            let removed = items[sourceIndexPath.row]
            items.insert(removed, at: targetIndexPath.row)
            items.remove(at: sourceIndexPath.row)
        } else {
            let removed = items.remove(at: sourceIndexPath.row)
            items.insert(removed, at: targetIndexPath.row)
        }
        updateLayouts()
    }
    
    /// 让view浮动在其他视图之上
    /// - Parameters:
    ///   - view: 视图
    ///   - isFloat: 是否浮动。 false会恢复原来的zIndex
    private func makeViewFloat(_ view: UIView?, isFloat: Bool = true) {
        guard let view = view else {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.layer.zPosition = isFloat ? 1 : 0
        CATransaction.commit()
    }
}


// MARK: - 边缘检测、处理

extension CCTableView {
    
    /// 滚动的方向
    enum MoveDirection {
        /// 不滚动. （边缘定时器不启动时候的)
        case none
        /// 向上滚动
        case up
        /// 向下滚动
        case down
    }
    
    /// 进入边缘滚动的范围
    static let edgeRange: CGFloat = 50
    
    ///  边缘检测
    private func edgeCheck() {
        guard let dragged = longPressedCell else { return }
        
        print("direction: \(direction) \(contentOffset)")
        
        let delta = contentSize.height - bounds.height
        if delta < 0 {
            endEdgeTimer()
            return
        }
        
        if contentOffset.y + contentInset.top < 0 || contentOffset.y + contentInset.top > delta {
            // 超过界限，不能移动了
            direction = .none
        } else if dragged.center.y < contentOffset.y + Self.edgeRange {
            // 向下移动
            direction = .down
        } else if dragged.center.y > contentOffset.y + bounds.height - Self.edgeRange {
            // 向上移动
            direction = .up
        } else {
            direction = .none
        }
        
        if direction == .none {
            endEdgeTimer()
        } else {
            startEdgeTimer()
        }
    }
    
    @objc
    private func edgeTimerCallBack() {
        guard let dragged = longPressedCell else { return }
        
        let velocity: CGFloat = 4
        let old = contentOffset.y
        let delta: CGFloat = contentSize.height - bounds.height
        switch direction {
        case .down:
            contentOffset.y -= velocity
            if contentOffset.y + contentInset.top < 0 {
                contentOffset.y = -contentInset.top
            }
            dragged.center.y -= abs(contentOffset.y - old)
            longPressedCellMoved()
        case .up:
            contentOffset.y += velocity
            if contentOffset.y + contentInset.top > delta {
                contentOffset.y = delta - contentInset.top
            }
            dragged.center.y += abs(contentOffset.y - old)
            longPressedCellMoved()
        default:
            break
        }
    }
    
    func startEdgeTimer() {
        if edgeTimer == nil {
            print("开始边缘计时器")
            let timer = CADisplayLink(target: self, selector: #selector(edgeTimerCallBack))
            timer.add(to: RunLoop.main, forMode: .common)
            edgeTimer = timer
        }
    }
    
    func endEdgeTimer() {
        if edgeTimer != nil {
            print("关闭边缘计时器")
            edgeTimer?.isPaused = true
            edgeTimer?.invalidate()
            edgeTimer = nil
        }
    }
}


// MARK: -

extension CCTableView {
    
    /// 是否应该选中某个格子
    func shouldSelect(cell: CCTableViewCell, at indexPath: IndexPath) -> Bool {
        let item = items[indexPath.row]
        return item.isAllowFocus
    }
    
    /// 是否可以插入到 indexPath 处
    func shouldInsert(at indexPath: IndexPath) -> Bool {
        // 插入到第一个
        if indexPath.row == 0 { return true }
        
        // 当前处在indexPath处的格子
        let now: CCItem? = indexPath.row == items.count ? nil : items[indexPath.row]
        // 上一个格子
        let up = items[indexPath.row - 1]
        if let dragged = longPressedCell, let item = dragged.item, now !== item {
            
            if !item.isGroup, dragged.subCells.count > 1 { // 多选时候拖动了多个元素(不是组header)
                
                if let f = now?.layerInfo as? FocusableLayerInfo, f.group != nil {  // 不能拖动到组内
                    return false
                }
                
            } else if let f = item.layerInfo as? FocusableLayerInfo, let group = f.group {  // 拖动项是组内元素
                
                if let anotherF = now?.layerInfo as? FocusableLayerInfo, anotherF.group?.key == group.key {   // 同一个组内的元素才可以相互拖动
                    return true
                } else if let anotherF = up.layerInfo as? FocusableLayerInfo, anotherF.group?.key == group.key {
                    // 要改为加入到组内的最后一个，是可以的！
                    return true
                }
                return false
                
            } else {    // 拖动项就是一个普通的层 或者 一个组header
                
                if let f = now?.layerInfo as? FocusableLayerInfo, f.group != nil {  // 不能拖动到组内
                    return false
                }
            }
        }
        return true
    }
    
    /// indexPath处的cell是否允许拖拽交互
    func shouldInteract(at indexPath: IndexPath) -> Bool {
        let it = items[indexPath.row]
        if let dragged = longPressedCell, let item = dragged.item, it !== item {
            if item.isGroup {   // 拖动项是一个组header
                
                if it.isGroup { // 交叉处是一个组header
                    return false
                } else if let f = it.layerInfo as? FocusableLayerInfo {
                    if f.group != nil {    // 交叉项属于一个组，不管是自己的组还是其他的组，都不能交互
                        return false
                    }
                }
                
            } else if let f = item.layerInfo as? FocusableLayerInfo, let group = f.group {  // 拖动项是组内元素
                
                if let anotherF = it.layerInfo as? FocusableLayerInfo, anotherF.group?.key == group.key {   // 同一个组内的元素才可以相互拖动
                    return true
                }
                return false
                
            } else {    // 拖动项就是一个普通的层
                
                if it.isGroup || (it.layerInfo as? FocusableLayerInfo)?.group != nil {  // 不能拖动到组或者组内元素
                    return false
                }
                
            }
        }
        return true
    }
    
    /// 选中某个cell
    func didSelect(cell: CCTableViewCell) {
        
    }
}


// MARK: -

extension CCTableView {
    
    var visibleCells: [CCTableViewCell] {
        var cs: [CCTableViewCell] = []
        contentView.subviews.forEach { v in
            if let c = v as? CCTableViewCell {
                let frame = c.convert(c.bounds, to: self)
                if frame.intersects(bounds) {
                    cs.append(c)
                }
            }
        }
        return cs
    }
    
    /// 找到和拖拽中的cell有交叉的第一个cell
    /// - Parameter draggingCell: 拖动中的cell
    /// - Returns: 第一个交叉的cell以及它的indexPath
    func findFirstIntersectCell(of draggingCell: CCTableViewCell) -> (IndexPath?, CCTableViewCell?) {
        let frame = draggingCell.frame
        if frame.maxX < 0 {
            return (nil, nil)
        }
        
        for (row, item) in items.enumerated() {
            if draggingCell === item.cell { continue }
            if frame.intersects(item.frame) {
                let indexPath = IndexPath(row: row, section: 0)
                return (indexPath, item.cell)
            }
        }
        return (nil, nil)
    }
    
    /// 找到和拖拽中的cell有交叉的所有cell
    /// - Parameter draggingCell: 拖动中的cell
    /// - Returns: 所有交叉的cell
    func findIntersectCells(of draggingCell: CCTableViewCell) -> [CCTableViewCell] {
        let frame = draggingCell.frame
        if frame.maxX < 0 {
            return []
        }
        
        var once = false
        var cells: [CCTableViewCell] = []
        for (_, item) in items.enumerated() {
            if draggingCell === item.cell { continue }
            if frame.intersects(item.frame), let cell = item.cell {
                cells.append(cell)
                once = true
            } else {
                // 交叉后，却出现不再交叉了，后面的就没必要遍历了！
                if once { break }
            }
        }
        return cells
    }
    
    
    func indexPath(for cell: CCTableViewCell) -> IndexPath? {
        for (row, item) in items.enumerated() {
            if item.cell === cell {
                return IndexPath(row: row, section: 0)
            }
        }
        return nil
    }
    
    func cell(at indexPath: IndexPath) -> CCTableViewCell? {
        let cell = contentView.subviews[indexPath.row] as? CCTableViewCell
        return cell
    }
    
    func cell(at point: CGPoint) -> CCTableViewCell? {
        for item in items {
            if item.frame.contains(point) {
                return item.cell
            }
        }
        return nil
    }
    
    func scroll(to indexPath: IndexPath, animated: Bool) {
        if let c = cell(at: indexPath) {
            let minH: CGFloat = min(contentView.bounds.height, bounds.height)
            let offsetY = c.center.y - minH * 0.5
            setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
        }
    }
    
    func selectCell(at indexPath: IndexPath) {
        let c = cell(at: indexPath)
        c?.makeSelected()
    }
    
    /// 找到属于某个组的cell
    /// - Parameter group: 指定的组cell
    /// - Returns: 属于该组的所有cell
    func cells(in group: CCGroupHeader) -> [CCTableViewCell] {
        guard let item = group.item, let index = items.firstIndex(of: item) else { return [] }
        var once = false
        var cs: [CCTableViewCell] = []
        let start: Int = index + 1
        for i in start..<items.count {
            let it = items[i]
            if let c = it.cell, let f = it.layerInfo as? FocusableLayerInfo, f.group?.key == item.layerInfo.key {
                cs.append(c)
                once = true
            } else {
                if once { break }
            }
        }
        return cs
    }
    
    /// 找到和某个cell同组的格子
    /// - Parameters:
    ///   - cell: 指定的cell
    ///   - includeSelf: 是否包含自身
    /// - Returns: 同组的其他cell
    func cellsInSameGroup(with cell: CCTableViewCell, includeSelf: Bool = true) -> [CCTableViewCell] {
        guard let f = cell.item?.layerInfo as? FocusableLayerInfo, let group = f.group else { return [] }
        var cs: [CCTableViewCell] = []
        for it in items {
            if it.cell === cell, !includeSelf { continue }
            if let c = it.cell,
               let tmp = it.layerInfo as? FocusableLayerInfo, tmp.group?.key == group.key {
                cs.append(c)
            }
        }
        return cs
    }
}
