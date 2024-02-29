//
//  PlantArray.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation

struct PlantArray: Codable {
    var arrayOfPlants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case arrayOfPlants = "data"
    }
}
