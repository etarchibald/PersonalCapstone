//
//  Notify.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 3/6/24.
//

import Foundation

struct Notify { 
    var id: Int
    var name: String
    var subtitle: String
    var time: Date
    var repeats: Bool
    
    init(id: Int, name: String, subtitle: String, time: Date, repeats: Bool) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.time = time
        self.repeats = repeats
    }
}
