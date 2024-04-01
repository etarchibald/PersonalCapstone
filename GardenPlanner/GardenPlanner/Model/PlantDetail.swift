//
//  PlantDetail.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import Foundation

struct AllPlantDetails: Codable {
    var allPlantDetails: PlantDetail
    
    enum CodingKeys: String, CodingKey {
        case allPlantDetails = "data"
    }
}

struct PlantDetail: Codable {
    var id: Int
    var commonName: String?
    var scientificName: String?
    var imageURL: String?
    var observations: String?
    var vegetable: Bool?
    var mainSpecies: MainSpecies
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case imageURL = "image_url"
        case observations = "observations"
        case vegetable = "vegetable"
        case mainSpecies = "main_species"
    }
}

struct MainSpecies: Codable {
    var rank: String?
    var ediblePart: [String]?
    var edible: Bool?
    var plantImages: PlantImages
    var distribution: Distribution?
    var flower: Flower
    var growth: Growth
    var specifications: Specifications
    
    enum CodingKeys: String, CodingKey {
        case rank = "rank"
        case ediblePart = "edible_part"
        case edible = "edible"
        case plantImages = "images"
        case distribution = "distribution"
        case flower = "flower"
        case growth = "growth"
        case specifications = "specifications"
    }
}

struct PlantImages: Codable {
    var fruitImages: [APIImage]?
    var flowerImages: [APIImage]?
    var habitImages: [APIImage]?
    var otherImages: [APIImage]?
    
    enum CodingKeys: String, CodingKey {
        case fruitImages = "fruit"
        case flowerImages = "flower"
        case habitImages = "habit"
        case otherImages = "other"
    }
}

struct APIImage: Codable, Hashable {
    var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

struct Distribution: Codable {
    var native: [String]?
    var introduced: [String]?
    
    enum CodingKeys: CodingKey {
        case native
        case introduced
    }
}

struct Flower: Codable {
    var color: [String]?
    
    enum CodingKeys: CodingKey {
        case color
    }
}

struct Growth: Codable {
    var description: String?
    var sowing: String?
    var daysToHarvest: Int?
    var rowSpacing: RowSpacing?
    var spread: Spread?
    var light: Int?
    var growthMonths: [String]?
    var bloomMonths: [String]?
    var fruitMonths: [String]?
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case sowing = "sowing"
        case daysToHarvest = "days_to_harvest"
        case rowSpacing = "row_spacing"
        case spread = "spread"
        case light = "light"
        case growthMonths = "growth_months"
        case bloomMonths = "bloom_months"
        case fruitMonths = "fruit_months"
    }
}

struct Specifications: Codable {
    var growthForm: String?
    var growthHabit: String?
    var growthRate: String?
    
    enum CodingKeys: String, CodingKey {
        case growthForm = "growth_form"
        case growthHabit = "growth_habit"
        case growthRate = "growth_rate"
    }
}

struct RowSpacing: Codable {
    var cm: Int?
    
    enum CodingKeys: CodingKey {
        case cm
    }
}

struct Spread: Codable {
    var cm: Int?
    
    enum CodingKeys: CodingKey {
        case cm
    }
}
