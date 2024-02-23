//
//  PlantsViewModel.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation

class PlantsViewModel: ObservableObject {
    
    var token = "qwVZcXbvzEqOE0qjuBSavumezdVboTXipVKGkLMr-a0"
    
    @Published var plants = [Plant]()
    
    func fetchPlants(using searchTerm: String) async {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/plants/search")!
        let searchForQueryItem = URLQueryItem(name: "q", value: searchTerm)
        let tokenQueryItem = URLQueryItem(name: "token", value: token)
        urlComponents.queryItems = [searchForQueryItem, tokenQueryItem]
        
        guard let downloadedPlants: PlantArray = await WebService().downloadData(fromURL: urlComponents.url!) else { return }
        plants = downloadedPlants.arrayOfPlants
    }
    
    
}
