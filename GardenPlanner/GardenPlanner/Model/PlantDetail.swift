//
//  PlantDetail.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import Foundation

struct PlantDetail: Codable {
    var id: Int
    var commonName: String
    var scientificName: String
    var imageURL: String
    var vegetable: Bool
    var mainSpecies: MainSpecies
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case imageURL = "image_url"
        case vegetable = "vegetable"
        case mainSpecies = "main_species"
    }
}

struct MainSpecies: Codable {
    var ediblePart: String?
    var edible: Bool
    var plantImages: PlantImages
    var flower: Flower
    var growth: Growth
//    var specifications: Specifications
    
    enum CodingKeys: String, CodingKey {
        case ediblePart = "edible_part"
        case edible = "edible"
        case plantImages = "images"
        case flower = "flower"
    }
}

struct PlantImages: Codable {
    var fruitImages: [APIImage]
    var flowerImages: [APIImage]
    var habitImages: [APIImage]
    var otherImages: [APIImage]?
    
    enum CodingKeys: String, CodingKey {
        case fruitImages = "fruit"
        case flowerImages = "flower"
        case habitImages = "habit"
        case otherImages = "other"
    }
}

struct APIImage: Codable {
    var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

struct Flower: Codable {
    var color: [String]
    
    enum CodingKeys: CodingKey {
        case color
    }
}

struct Growth: Codable {
    var description: String?
    var light: String?
    var growthMonths: String?
    var bloomMonths: String?
    var fruitMonths: String?
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case light = "light"
        case growthMonths = "growth_months"
        case bloomMonths = "bloom_months"
        case fruitMonths = "fruit_months"
    }
}

//struct Specifications: Codable {
//    
//}
