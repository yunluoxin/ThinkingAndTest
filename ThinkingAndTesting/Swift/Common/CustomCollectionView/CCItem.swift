//
//  CCItem.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/11.
//  Copyright © 2021 dadong. All rights reserved.
//

import Foundation

class CCItem {
    
    let kind: Int
        
    let layerInfo: BaseLayerInfo
    
    var cell: CCTableViewCell?
    
    /// 处在原来轨道上的frame
    var frame: CGRect = .zero
    
    /// 行高
    var rowHeight: CGFloat = 64
    
    var index: Int = 0
    var color: UIColor?
    
    /// 是否允许拖动
    var isAllowDragged: Bool = true
    /// 是否允许选中
    var isAllowFocus: Bool = true
    
    /// 是否是组
    var isGroup: Bool { layerInfo is LayerGroupInfo }
    
    init(kind: Int, layerInfo: BaseLayerInfo) {
        self.kind = kind
        self.layerInfo = layerInfo
    }
}
