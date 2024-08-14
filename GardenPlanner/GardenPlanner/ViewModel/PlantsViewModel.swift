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
    @Published var userSlug = "UTA"
    @Environment(\.modelContext) var modelContext
    
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
    
    func fetchPlantSuggestions(using slug: String, page number: Int) async {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/distributions/\(slug)/plants")!
        let tokenQueryItem = URLQueryItem(name: "token", value: "qwV\(token)-a0")
        let pageNumberQueryItem = URLQueryItem(name: "page", value: String(number))
        urlComponents.queryItems = [tokenQueryItem, pageNumberQueryItem]
        
        if let downloadPlants: PlantArray = await WebService().downloadData(fromURL: urlComponents.url!) {
            DispatchQueue.main.async {
                withAnimation(.smooth) {
                    self.userSlug = slug
                    self.plants.append(contentsOf: downloadPlants.arrayOfPlants)
                }
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
    
    func addPlantToGarden() {
        let plant = self.plantDetail
        
        let newPlant = YourPlant(id: plant.id, imageURL: plant.imageURL ?? "image", name: plant.commonName ?? "", mainSpeciesId: plant.mainSpeciesId ?? 0, sowing: plant.mainSpecies.growth.sowing ?? "", daysToHarvest: plant.mainSpecies.growth.daysToHarvest ?? 0, rowSpacing: plant.mainSpecies.growth.rowSpacing?.cm ?? 0, spread: plant.mainSpecies.growth.spread?.cm ?? 0, growthMonths: plant.mainSpecies.growth.growthMonths ?? [], bloomMonths: plant.mainSpecies.growth.bloomMonths ?? [], fruitMonths: plant.mainSpecies.growth.growthMonths ?? [], light: plant.mainSpecies.growth.light ?? 5, growthHabit: plant.mainSpecies.specifications.growthHabit ?? "", growthRate: plant.mainSpecies.specifications.growthRate ?? "", entrys: [], notes: "", photos: [], reminders: [])
        
        modelContext.insert(newPlant)
    }
    
    func removePlantFromGarden(plants: [YourPlant]) {
        let plant = self.plantDetail
        
        for eachPlant in plants {
            if eachPlant.id == plant.id {
                eachPlant.entrys = []
                eachPlant.photos = []
                
                for reminder in eachPlant.reminders {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
                }
                
                eachPlant.reminders = []
                modelContext.delete(eachPlant)
                break
            }
        }
    }
}
