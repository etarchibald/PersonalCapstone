//
//  PlantDetailView.swift
//  GardenPlanner
//
//  Created by Ethan Archibald on 2/23/24.
//

import SwiftUI
import SwiftData

struct PlantDetailView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var plantViewModel = PlantsViewModel()
    
    var plantid: Int
    
    var body: some View {
        let plant = plantViewModel.plantDetail
        
        VStack {
            Button {
                let newPlant = GardenPlant(id: plantViewModel.plantDetail.id, imageURL: plantViewModel.plantDetail.imageURL ?? "image", name: plantViewModel.plantDetail.commonName ?? "Plant", notes: "")
                modelContext.insert(newPlant)
            } label: {
                Text("Add to Garden")
                    .foregroundStyle(.green)
            }
            .frame(width: 380, alignment: .trailing)
            
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
                    plant.mainSpecies.flower.color.map { _ in Text("Flower Color(s):") }
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
                
                VStack {
                    if let flowerImages = plant.mainSpecies.plantImages.flowerImages {
                        Text("Flowers:")
                        PlantPictureScrollView(pictures: flowerImages)
                            .padding(.leading)
                    }
                    if let fruitImages = plant.mainSpecies.plantImages.fruitImages {
                        Text("Fruit:")
                        PlantPictureScrollView(pictures: fruitImages)
                            .padding(.leading)
                    }
                    if let habitImages = plant.mainSpecies.plantImages.habitImages {
                        Text("Habitat:")
                        PlantPictureScrollView(pictures: habitImages)
                            .padding(.leading)
                    }
                    if let otherImages = plant.mainSpecies.plantImages.otherImages {
                        Text("Other Pictures:")
                        PlantPictureScrollView(pictures: otherImages)
                            .padding(.leading)
                    }
                }
            }
            .navigationTitle(plant.commonName ?? "No commonName")
            .navigationBarTitleTextColor(Color.green)
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

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}
