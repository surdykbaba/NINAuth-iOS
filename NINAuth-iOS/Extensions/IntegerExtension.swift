//
//  IntegerExtension.swift
//  NINAuth-iOS
//
//  Created by Chioma Amanda Mmegwa  on 22/02/2025.
//

import SwiftUI

extension Int {
init(_ range: Range<Int> ) {
    let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
    let min = UInt32(range.lowerBound + delta)
    let max = UInt32(range.upperBound   + delta)
    self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}
