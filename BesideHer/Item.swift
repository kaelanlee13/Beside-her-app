//
//  Item.swift
//  BesideHer
//
//  Created by Kaelan Lee on 4/2/26.
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
