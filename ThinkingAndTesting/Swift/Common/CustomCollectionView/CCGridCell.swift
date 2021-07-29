//
//  CCGridCell.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/9.
//  Copyright © 2021 dadong. All rights reserved.
//

import UIKit

class CCGridCell: UIView {
    
    lazy var contentView: UIView = .init(frame: bounds)
    
    lazy var textLabel: UILabel = {
        let v = UILabel(frame: bounds)
        v.font = .systemFont(ofSize: 30, weight: .bold)
        v.textAlignment = .center
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
    func perpareForReuse()  {
        alpha = 1
        transform = .identity
    }
    
    /// 更新数据（子类记得调用父类的）
    func update(with item: CCItem) {
        self.item = item
    }
    
    func makeSelected(_ selected: Bool = true) {
        
    }
}
