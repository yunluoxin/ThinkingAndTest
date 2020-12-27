//
//  StackViewController.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/12/26.
//  Copyright © 2020 dadong. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = StackView<AItem>(frame: CGRect(x: 0, y: 100, width: 300, height: 50))
        v.cellType = ACell.self
        v.items = [
            .init(name: "A"),
            .init(name: "B"),
            .init(name: "C"),
            .init(name: "D"),
        ]
        v.spacing = 18
        v.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        v.backgroundColor = .purple
        v.selectionStyle = .one
        view.addSubview(v)
        
        v.shouldSelectAt = { item in
            if item.name == "F" {
                return false
            }
            return true
        }
        
        v.didSelectAt = { cell, item in
            print("\(item.name ?? "")")
//            item.selected = !item.selected
//            item.changed = true
//            cell.refreshUI()
            
            let newItem: AItem = .init(name: "F")
            v.items.append(newItem)
            v.reloadData()

//            if let index = v.items.firstIndex(of: item) {
//                v.items.remove(at: index)
//                v.reloadData()
//            }
        }
    }
}


class AItem: StackViewItem {
    var name: String?
    init(name: String?) {
        super.init()
        self.name = name
        self.itemSize = CGSize(width: 50, height: 50)
    }
}


class ACell: StackView<AItem>.Cell {
    
    lazy var textLabel: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 13)
        v.backgroundColor = .red
        v.alpha = 0.5
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var item: AItem? {
        didSet {
            textLabel.text = item?.name
            
            if item?.selected == true {
                textLabel.alpha = 1
            } else {
                textLabel.alpha = 0.5
            }
        }
    }
    
    override func refreshUI() {
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveLinear) {
            if self.item?.selected == true {
//                self.textLabel.backgroundColor = .orange
                self.textLabel.alpha = 1
            } else {
//                self.textLabel.backgroundColor = .red
                self.textLabel.alpha = 0.5
            }
        } completion: { (_) in
            
        }

    }
}
