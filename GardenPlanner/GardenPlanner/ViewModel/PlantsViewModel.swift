//
//  PlantsViewModel.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation
import SwiftUI

class PlantsViewModel: ObservableObject {
    
    var token = "ZcXbvzEqOE0qjuBSavumezdVboTXipVKGkLMr"
    
    @Published var plants = [Plant]()
    @Published var plantDetail = PlantDetail(id: 0, commonName: "", scientificName: "", mainSpeciesId: 0, imageURL: "", vegetable: false, mainSpecies: MainSpecies(edible: false, plantImages: PlantImages(fruitImages: [], flowerImages: [], habitImages: []), flower: Flower(color: []), growth: Growth(), specifications: Specifications()))
    
    func fetchPlants(using searchTerm: String, pageNumber number: Int) async {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/plants/search")!
        let searchForQueryItem = URLQueryItem(name: "q", value: searchTerm)
        let pageNumberQueryItem = URLQueryItem(name: "page", value: String(number))
        let tokenQueryItem = URLQueryItem(name: "token", value: "qwV\(token)-a0")
        urlComponents.queryItems = [searchForQueryItem, tokenQueryItem, pageNumberQueryItem]
        
        guard let downloadedPlants: PlantArray = await WebService().downloadData(fromURL: urlComponents.url!) else { return }
        DispatchQueue.main.async {
            withAnimation(.smooth) {
                self.plants.append(contentsOf: downloadedPlants.arrayOfPlants)
            }
        }
    }
    
    func fetchPlantDetail(using plantId: Int) async {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/plants/\(plantId)")!
        let tokenQueryItem = URLQueryItem(name: "token", value: "qwV\(token)-a0")
        urlComponents.queryItems = [tokenQueryItem]
        guard let downloadPlantDetails: AllPlantDetails = await WebService().downloadData(fromURL: urlComponents.url!) else { return }
        DispatchQueue.main.async {
            withAnimation(.smooth) {
                self.plantDetail = downloadPlantDetails.allPlantDetails
            }
        }
    }
}
