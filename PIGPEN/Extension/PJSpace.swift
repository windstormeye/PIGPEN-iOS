//
//  PJSpace.swift
//  PIGPEN
//
//  Created by 翁培钧 on 2019/7/21.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

extension UIScrollView: PJSpaceCompatiable { }

struct PJSpaceWrapper<T> {
    public let t: T
    public init(_ t: T) { self.t = t }
}

protocol PJSpaceCompatiable: AnyObject { }

extension PJSpaceCompatiable {
    public var pj: PJSpaceWrapper<Self> {
        get { return PJSpaceWrapper(self) }
        set { }
    }
}
