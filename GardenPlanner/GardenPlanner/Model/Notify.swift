//
//  Notify.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/6/24.
//

import Foundation
import SwiftUI

// Help keep track of notifications and help the user keep track of them
struct Notify: Codable, Hashable, Comparable {
    var id: UUID
    var name: String
    var subtitle: String
    var time: Date
    var repeats: Bool
    var howOften: RepeatingNotifications
    var ownerPlant: OwnerPlant
    
    static func < (lhs: Notify, rhs: Notify) -> Bool {
        lhs.time < rhs.time
    }
}

struct OwnerPlant: Codable, Hashable {
    var id: Int
    var name: String
    var addedEntry: Bool
}

enum RepeatingNotifications: String, Equatable, CaseIterable, Codable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
