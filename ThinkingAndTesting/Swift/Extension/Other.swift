//
//  Other.swift
//  ThinkingAndTesting
//
//  Created by zhangxiaodong on 2020/6/13.
//  Copyright © 2020 dadong. All rights reserved.
//

import Foundation

func local(code: () -> ()) {
    code()
}

struct Kotlin {
    
    static func `let`<T>(_ it: T, code: (T) -> Void) {
        code(it)
    }
    
    static func run<T,K>(_ it: T, code: (T) -> K) -> K {
        return code(it)
    }
    
//    static func apply<T>(_ it: T, code: (T) -> Void) -> T {
//        code(it)
//        return it
//    }
}

//func T.run<T,R>(block: (_ self: T) -> R?) -> R? {
//    block(self)
//}


func asynMain(code: @escaping () -> ()) {
    DispatchQueue.main.async {
        code()
    }
}

func syncMain(code: () -> ()) {
    DispatchQueue.main.sync {
        code()
    }
}

func delayMain(_ seconds: TimeInterval, code: @escaping () -> ()) {
    let time = DispatchTime.now() + seconds
    DispatchQueue.main.asyncAfter(deadline: time) {
        code()
    }
}
