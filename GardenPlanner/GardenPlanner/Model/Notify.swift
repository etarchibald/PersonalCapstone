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
    case daily = "Daily"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
    
    func dateComponents(for date: Date) -> DateComponents {
        switch self {
        case .daily:
            guard let oneDayFromNow = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
                print("Error Calculating one day later")
                return .init()
            }
            var dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: oneDayFromNow)
            dateComponents.second = 0
            return dateComponents
        case .week:
            guard let oneWeekFromNow = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date) else {
                print("Error Calculating one week later")
                return .init()
            }
            let dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: oneWeekFromNow)
            return dateComponents
        case .month:
            guard let oneMonthFromNow = Calendar.current.date(byAdding: .month, value: 1, to: date) else {
                print("Error Calculating one month later")
                return .init()
            }
            var dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: oneMonthFromNow)
            dateComponents.calendar = Calendar.current
            return dateComponents
        case .year:
            guard let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: date) else {
                print("Error Calculating one year later")
                return .init()
            }
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: oneYearFromNow)
            return dateComponents
        }
        
    }
}
