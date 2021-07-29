//
//  CCReuse.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/7/9.
//  Copyright © 2021 dadong. All rights reserved.
//

import Foundation

class CCReusePool {
    
    var unusedCells: [String: Array<CCGridCell>] = [:]
    
    func dequeueCell(for type: CCGridCell.Type) -> CCGridCell {
        let k = key(for: type)
        if var cells = unusedCells[k], let cell = cells.popLast()  {
            unusedCells[k] = cells
            cell.prepareForReuse()
            return cell
        } else {
            let cell = type.init(frame: .zero)
            return cell
        }
    }
    
    func returnCell(_ cell: CCGridCell) {
        let k = key(for: type(of: cell))
        if var cells = unusedCells[k] {
            cells.append(cell)
            unusedCells[k] = cells
        } else {
            unusedCells[k] = [cell]
        }
    }
    
    func returnCells(_ cells: [CCGridCell]) {
        for cell in cells {
            returnCell(cell)
        }
    }
    
    private func key(for type: CCGridCell.Type) -> String {
        String(describing: type)
    }
}
