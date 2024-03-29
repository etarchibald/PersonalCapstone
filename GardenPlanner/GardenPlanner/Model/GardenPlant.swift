//
//  GardenPlant.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import Foundation
import SwiftData

//Data model for persisting the plants in your garden
@Model
class YourPlant: Hashable {
    @Attribute(.unique) var id: Int
    var imageURL: String
    var name: String
    var growthMonths: [String]
    var bloomMonths: [String]
    var fruitMonths: [String]
    var light: Int
    var growthHabit: String
    var growthRate: String
    @Relationship(deleteRule: .cascade) var entrys: [Entry]
    var notes: String
    @Relationship(deleteRule: .cascade) var photos: [UserPhotos]
    
    init(id: Int, imageURL: String, name: String, growthMonths: [String], bloomMonths: [String], fruitMonths: [String], light: Int, growthHabit: String, growthRate: String, entrys: [Entry], notes: String, photos: [UserPhotos]) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.growthMonths = growthMonths
        self.bloomMonths = bloomMonths
        self.fruitMonths = fruitMonths
        self.light = light
        self.growthHabit = growthHabit
        self.growthRate = growthRate
        self.entrys = entrys
        self.notes = notes
        self.photos = photos
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
