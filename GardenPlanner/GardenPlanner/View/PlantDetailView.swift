//
//  PlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import SwiftUI

struct PlantDetailView: View {
    @StateObject var plantViewModel = PlantsViewModel()
    
    var plantid: Int
    
    init(plantid: Int) {
        self.plantid = plantid
    }
    
    var body: some View {
        var plant = plantViewModel.plantDetail
        
        VStack {
            ScrollView {
                AsyncImage(url: URL(string: plantViewModel.plantDetail.imageURL ?? ""))
                
                Text(plant.commonName ?? "No commonName")
                Text(plant.scientificName ?? "scienicy plant name")
                Text(plant.vegetable ?? true ? "Fruit" : "Vegetable")
                ForEach(plant.mainSpecies.ediblePart ?? [], id: \.self) { part in
                    Text(part)
                }
                
                Text(plant.mainSpecies.edible ?? false ? "Edible" : "NOT Edible")
                
                HStack {
                    Text("Flower Colors:")
                    ForEach(plant.mainSpecies.flower.color ?? [], id: \.self) { color in
                        Text(color)
                    }
                }
                
                VStack {
                    Text("Growth Info:")
                    plant.mainSpecies.growth.description.map { Text($0)}
                    Text("How much light on 0 to 10 scale: \(plant.mainSpecies.growth.light ?? 5)")
                    HStack {
                        ForEach(plant.mainSpecies.growth.growthMonths ?? [], id: \.self) { string in
                            Text(string)
                        }
                    }
                    HStack {
                        ForEach(plant.mainSpecies.growth.bloomMonths ?? [], id: \.self) { string in
                            Text(string)
                        }
                    }
                    HStack {
                        ForEach(plant.mainSpecies.growth.fruitMonths ?? [], id: \.self) { string in
                            Text(string)
                        }
                    }
                }
                
                VStack {
                    Text(plant.mainSpecies.specifications.growthHabit ?? "")
                    Text(plant.mainSpecies.specifications.growthRate ?? "")
                }
            }
        }
        .onAppear(perform: {
            fetchPlantDetails()
        })
    }
    
    func fetchPlantDetails() {
        Task {
            await plantViewModel.fetchPlantDetail(using: plantid)
        }
    }
}

#Preview {
    PlantDetailView(plantid: 265263)
}
