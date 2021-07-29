//
//  CustomTableViewDemoVC.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/12.
//  Copyright © 2021 dadong. All rights reserved.
//

import Foundation

class CustomTableViewDemoVC: UIViewController {
    
    let gridView: CCGridView = .init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w: CGFloat = 100
        let x: CGFloat = view.bounds.width - w
        let frame = CGRect(x: x, y: 0, width: w, height: view.bounds.height)
        gridView.frame = frame
        gridView.backgroundColor = .gray
        view.addSubview(gridView)
        
        var layers: [BaseLayerInfo] = []
        for i in 0...20 {
            if i % 6 == 0 {
                let group = LayerGroupInfo()
                for _ in 0..<3 {
                    let layer = FocusableLayerInfo()
                    layer.group = group
                    group.subLayers.append(layer)
                }
                layers.append(group)
            } else {
                let layer = BaseLayerInfo()
                layers.append(layer)
            }
        }
        
        var items: [CCItem] = []
        for (i, layerInfo) in layers.enumerated() {
            let isGroup: Bool = layerInfo is LayerGroupInfo
            let item = CCItem(kind: isGroup ? 2 : 1, layerInfo: layerInfo)
            item.color = .randomColor()
            item.index = i
            if i == 3 {
                item.rowHeight = 120
            }
            if isGroup {
                item.rowHeight = 30
            }
            items.append(item)
            if let group = layerInfo as? LayerGroupInfo {
                group.subLayers.enumerated().forEach { (j, subLayer) in
                    let item = CCItem(kind: 1, layerInfo: subLayer)
                    item.color = .randomColor()
                    item.index = i * 10 + j
                    items.append(item)
                }
            }
        }
        gridView.items = items
        gridView.reloadData()
    }
}


class BaseLayerInfo {
    var key = ""
}

class FocusableLayerInfo: BaseLayerInfo {
    var group: LayerGroupInfo?
}

class LayerGroupInfo: FocusableLayerInfo {
    var subLayers: [FocusableLayerInfo] = []
}
