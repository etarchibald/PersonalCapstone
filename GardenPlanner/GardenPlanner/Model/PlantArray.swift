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
    
    static var dummyArrayOfPlants = [Plant(id: 0, commonName: "Apple", scientificName: "Applus fruitus", imageURL: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", genus: "Billardiera", family: "pittosporaceae"), Plant(id: 0, commonName: "Apple", scientificName: "Applus fruitus", imageURL: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", genus: "Billardiera", family: "pittosporaceae"), Plant(id: 0, commonName: "Apple", scientificName: "Applus fruitus", imageURL: "https://bs.plantnet.org/image/o/a42b6ba0beea54fbba5aaec0c785ac52ad3440c0", genus: "Billardiera", family: "pittosporaceae")]
}
