//
//  Notify.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/6/24.
//

import Foundation
import SwiftUI

// Help keep track of notifications and help the user keep track of them
struct Notify {
    var id: UUID
    var name: String
    var subtitle: String
    var time: Date
    var repeats: Bool
    var howOften: RepeatingNotifications
}

enum RepeatingNotifications: String, Equatable, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
