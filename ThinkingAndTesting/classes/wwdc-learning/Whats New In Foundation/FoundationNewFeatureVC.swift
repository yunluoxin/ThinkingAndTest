//
//  FoundationNewFeatureVC.swift
//  ThinkingAndTesting
//
//  Created by East.Zhang on 2021/1/27.
//  Copyright © 2021 dadong. All rights reserved.
//
//  2018 WWDC: `What's new in Foundation?`
//

import UIKit

class FoundationNewFeatureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .purple
        
        if #available(iOS 13.0, *) {
            let queue = OperationQueue()
            queue.progress.totalUnitCount = 3
        }
    }
    
    /// 高级特性: 计算两个集合的差别
    func advanceCollectionDiff() {
        if #available(iOS 13, *) {
            let bird = "bird"
            let bear = "bear"
            // bear => bird 的差别(需要做出的动作, 删除 ea, 然后插入i,d)
            let diff = bird.difference(from: bear)
            // 这个相当于回放.. bear + 差别 = bird
            if let newBird = bear.applying(diff) {
                print(newBird)
            } else {
                print("error")
            }
        }
    }
    
    /// 相对时间格式化
    func relativeDate() {
        if #available(iOS 13.0, *) {
//            let now = Date().timeIntervalSince1970
            let future: TimeInterval = 24 * 60 * 60 * 7
            let formatter = RelativeDateTimeFormatter()
            formatter.dateTimeStyle = .numeric
            formatter.unitsStyle = .full
            let str = formatter.localizedString(fromTimeInterval: future)
            print(str)
            
            /**
             dateTimeStyle => .name和.numric区别是
                在前后一天时候，一个是 'yesterday/tomorrow', 一个是'1 day ago/ in 1 day';
                前后一周时候，一个是'last week/next week', 一个是'1 week ago/in 1 week';
                同理，月份、年份，and so on.
             */
        }
    }
    
    /// 列表格式化
    func listFormatter() {
        if #available(iOS 13.0, *) {
            let array = ["😄", "😭", "💰"]
            let formatter = ListFormatter()
            formatter.locale = Locale(identifier: "en-US")
            if let result = formatter.string(from: array) {
                print(result)
                // en-US:
                // 😄, 😭, and 💰
                // zh-CN:
                // 😄、😭和💰
            }
        }
    }
    
    /// Swift版本的Barrier怎么写呢？
    func barrier() {
        let queue = DispatchQueue(label: "com.east.queue.test-barrier", attributes: .concurrent)
        queue.async {
            print("first task")
        }
        
        queue.async {
            print("begin second task")
            Thread.sleep(forTimeInterval: 2)
            print("end second task")
        }
        
        queue.async(group: nil, qos: .background, flags: .barrier) {
            print("in barrier")
        }
    }
}
