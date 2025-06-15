//
//  Item.swift
//  HighlightSyntaxPlayground
//
//  Created by Xcode Developer on 6/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
