//
//  GardenPlant.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/27/24.
//

import Foundation
import SwiftData

@Model
class GardenPlant: Hashable {
    @Attribute(.unique) var id: Int
    var imageURL: String
    var name: String
    var notes: String
    
    init(id: Int, imageURL: String, name: String, notes: String) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.notes = notes
    }
}
