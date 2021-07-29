//
//  ArrayExtention.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/27.
//  Copyright © 2021 dadong. All rights reserved.
//


extension Array where Element: AnyObject {
    
    /// 交换数组里的两个元素
    mutating func swap(_ element: Element, with anotherElement: Element) {
        guard
            let i = firstIndex(where: { $0 === element }),
            let j = firstIndex(where: { $0 === anotherElement })
        else {
            return
        }
        swapAt(i, j)
    }
    
    /// 移除某个元素
    /// - Warning: 只会移除从头到尾检测到的第一个元素。
    /// - Parameter element: 要移除的元素
    /// - Returns: 是否成功移除
    @discardableResult
    mutating func remove(_ element: Element) -> Bool {
        if let firstIndex = firstIndex(where: { $0 === element }) {
            remove(at: firstIndex)
            return true
        }
        return false
    }
    
    /// 查找该元素在数组中的位置（通过内存地址比对的！）
    /// - Returns: 返回查找到的第一个元素
    func firstIndex(of element: Element) -> Index? {
        let index = firstIndex(where: { $0 === element })
        return index
    }
}


extension Array {
    
    /// 移除某个元素
    /// - Warning: 只会移除从头到尾检测到的第一个元素。 如果你需要移除多个一样的元素，请使用`removeAll(where:)`方法！
    /// - Parameter predict: 判断条件。 返回true的元素要被移除
    /// - Returns: 被移除的元素
    mutating func remove(where predict: (Self.Element) throws -> Bool) rethrows -> Element? {
        do {
            if let index = try firstIndex(where: predict) {
                return remove(at: index)
            }
        } catch let e {
            throw e
        }
        return nil
    }
}
