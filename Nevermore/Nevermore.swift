//
//  Nevermore.swift
//  Nevermore
//
//  Created by 蒋永翔 on 17/3/21.
//  Copyright © 2017年 dingo. All rights reserved.
//

import Foundation

let shareSingleton = Nevermore()

open class Nevermore: NSObject {
    //singleton
    class var shared: Nevermore {
        return shareSingleton;
    }
    
}
