//
//  PlantAPIController.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/22/24.
//

import Foundation

class PlantAPIController {
    
    enum APIError: Error, LocalizedError {
        case APIFetchError
    }
    
    static var shared = PlantAPIController()
    
    var token = "qwVZcXbvzEqOE0qjuBSavumezdVboTXipVKGkLMr-a0"
    
    func fetchListOfPlants(searchParam: String) async throws -> [Plant] {
        var urlComponents = URLComponents(string: "https://trefle.io/api/v1/plants/search")!
        let searchForQueryItem = URLQueryItem(name: "q", value: searchParam)
        let tokenQueryItem = URLQueryItem(name: "token", value: token)
        urlComponents.queryItems = [searchForQueryItem, tokenQueryItem]
        
        let session = URLSession.shared
        let (data, response) = try await session.data(from: urlComponents.url!)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else { throw APIError.APIFetchError }
        
        let results = try JSONDecoder().decode(PlantArray.self, from: data)
        return results.arrayOfPlants
    }
    
}
