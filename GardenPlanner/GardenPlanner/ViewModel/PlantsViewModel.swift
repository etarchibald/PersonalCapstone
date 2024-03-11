//
//  PlantsViewModel.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation

class PlantsViewModel: ObservableObject {
    
    var token = "ZcXbvzEqOE0qjuBSavumezdVboTXipVKGkLMr"
    
    @Published var plants = [Plant]()
    @Published var plantDetail = PlantDetail(id: 0, commonName: "", scientificName: "", imageURL: "", vegetable: false, mainSpecies: MainSpecies(edible: false, plantImages: PlantImages(fruitImages: [], flowerImages: [], habitImages: []), flower: Flower(color: []), growth: Growth(), specifications: Specifications()))
    
    func fetchPlants(using searchTerm: String) async {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/plants/search")!
        let searchForQueryItem = URLQueryItem(name: "q", value: searchTerm)
        let tokenQueryItem = URLQueryItem(name: "token", value: "qwV\(token)-a0")
        urlComponents.queryItems = [searchForQueryItem, tokenQueryItem]
        
        guard let downloadedPlants: PlantArray = await WebService().downloadData(fromURL: urlComponents.url!) else { return }
        DispatchQueue.main.async {
            self.plants = downloadedPlants.arrayOfPlants
        }
    }
    
    func fetchPlantDetail(using plantId: Int) async {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/plants/\(plantId)")!
        let tokenQueryItem = URLQueryItem(name: "token", value: "qwV\(token)-a0")
        urlComponents.queryItems = [tokenQueryItem]
        guard let downlaedPlantDetails: AllPlantDetails = await WebService().downloadData(fromURL: urlComponents.url!) else { return }
        DispatchQueue.main.async {
            self.plantDetail = downlaedPlantDetails.allPlantDetails
        }
    }
}
