//
//  Plant.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation

struct Plant: Codable, Identifiable {
    var id: Int
    var commonName: String?
    var scientificName: String?
    var imageURL: String?
    var genus: String
    var family: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case imageURL = "image_url"
        case genus = "genus"
        case family = "family"
    }
}
