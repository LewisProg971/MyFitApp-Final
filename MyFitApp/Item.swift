//
//  Item.swift
//  MyFitApp
//
//  Created by CRANE Lewis on 23/03/2026.
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
