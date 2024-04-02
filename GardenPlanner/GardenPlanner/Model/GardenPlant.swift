//
//  GardenPlant.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import Foundation
import SwiftData
import SwiftUI

//Data model for persisting the plants in your garden
@Model
class YourPlant: Hashable {
    @Attribute(.unique) var id: Int
    var imageURL: String
    var name: String
    var sowing: String
    var daysToHarvest: Int
    var rowSpacing: Int
    var spread: Int
    var growthMonths: [String]
    var bloomMonths: [String]
    var fruitMonths: [String]
    var light: Int
    var growthHabit: String
    var growthRate: String
    @Relationship(deleteRule: .cascade) var entrys: [Entry]
    var notes: String
    @Relationship(deleteRule: .cascade) var photos: [UserPhotos]
    @Relationship(deleteRule: .cascade) var reminders: [Reminder]
    
    init(id: Int, imageURL: String, name: String, sowing: String, daysToHarvest: Int, rowSpacing: Int, spread: Int, growthMonths: [String], bloomMonths: [String], fruitMonths: [String], light: Int, growthHabit: String, growthRate: String, entrys: [Entry], notes: String, photos: [UserPhotos], reminders: [Reminder]) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.sowing = sowing
        self.daysToHarvest = daysToHarvest
        self.rowSpacing = rowSpacing
        self.spread = spread
        self.growthMonths = growthMonths
        self.bloomMonths = bloomMonths
        self.fruitMonths = fruitMonths
        self.light = light
        self.growthHabit = growthHabit
        self.growthRate = growthRate
        self.entrys = entrys
        self.notes = notes
        self.photos = photos
        self.reminders = reminders
    }
}

@Model
class Entry: Comparable {
    var id: UUID
    var title: String
    var body: String
    var date: Date
    
    init(id: UUID, title: String, body: String, date: Date) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
    }
    
    static func < (lhs: Entry, rhs: Entry) -> Bool {
        lhs.date > rhs.date
    }
}

@Model
class UserPhotos: Comparable {
    var id: UUID
    var dateAdded: Date
    @Attribute(.externalStorage) var photo: Data
    
    init(id: UUID, dateAdded: Date, photo: Data) {
        self.id = id
        self.dateAdded = dateAdded
        self.photo = photo
    }
    
    static func < (lhs: UserPhotos, rhs: UserPhotos) -> Bool {
        lhs.dateAdded > rhs.dateAdded
    }
}

@Model
class Reminder: Identifiable {
    var id: UUID
    var name: String
    var subtitle: String
    var time: Date
    var repeats: Bool
    var howOften: RepeatingNotifications
    var ownerPlant: OwnerPlant
    
    static func < (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.time < rhs.time
    }
    
    init(id: UUID, name: String, subtitle: String, time: Date, repeats: Bool, howOften: RepeatingNotifications, ownerPlant: OwnerPlant) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.time = time
        self.repeats = repeats
        self.howOften = howOften
        self.ownerPlant = ownerPlant
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
